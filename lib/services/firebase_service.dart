import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:safe_device/safe_device.dart';
import 'package:shopito_app/services/dio_service.dart';
import 'package:shopito_app/services/navigation_service.dart';
import 'package:shopito_app/services/notification_modal_service.dart';
import 'package:shopito_app/services/secure_storage_service.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');

  // Handle the notification data
  if (message.notification != null) {
    debugPrint('Notification Title: ${message.notification?.title}');
    debugPrint('Notification Body: ${message.notification?.body}');
  }

  // Handle the data payload
  if (message.data.isNotEmpty) {
    debugPrint('Data payload: ${message.data}');

    // Handle order notifications
    if (message.data['order_id'] != null) {
      try {
        await NotificationModalService.handleBackgroundNotification(message);
      } catch (e) {
        debugPrint('Error handling background notification: $e');
      }
    }
  }
}

class FirebaseService {
  FirebaseService({
    required this.dioService,
    required this.logger,
    required this.secureStorage,
  }) {
    _firebaseMessaging.onTokenRefresh.listen((token) async {
      logger.info('FCM token is refreshed! -> $token');

      await _registerDeviceToken(token);
    });
  }

  final DioService dioService;
  final Logger logger;
  final SecureStorageService secureStorage;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  String? get fcmToken => _fcmToken;

  String? _fcmToken;
  RemoteMessage? _initialMessage;

  Future<void> initListeners() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    _initialMessage = await _firebaseMessaging.getInitialMessage();

    if (_initialMessage != null) {
      logger.info('Initial message found: ${_initialMessage?.messageId}');
      // Handle initial message when app becomes ready
      _handleInitialMessage();
    }

    FirebaseMessaging.onMessage.listen((message) {
      logger.info('Foreground message: ${message.messageId}');
      handleNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      logger.info('Message opened app: ${message.messageId}');
      handleNotification(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _handleInitialMessage() async {
    if (_initialMessage?.data['order_id'] != null) {
      // Wait for the app to be ready, then show the modal
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          await Future.delayed(
            Duration(milliseconds: 500),
          ); // Give app time to initialize
          final context = NavigationService.instance.currentContext;
          if (context != null && context.mounted) {
            await NotificationModalService.handleForegroundNotification(
              context,
              _initialMessage!,
            );
          }
        } catch (e) {
          logger.warning('Failed to handle initial message: $e');
        }
      });
    }
  }

  RemoteMessage? getInitialMessage() => _initialMessage;

  void handleNotification(RemoteMessage message) {
    if (message.notification != null) {
      logger
        ..info('Notification Title: ${message.notification?.title}')
        ..info('Notification Body: ${message.notification?.body}');

      // Handle order notifications
      if (message.data['order_id'] != null) {
        final context = NavigationService.instance.currentContext;
        if (context != null && context.mounted) {
          try {
            NotificationModalService.handleForegroundNotification(
              context,
              message,
            );
            return; // Don't show toast for modal notifications
          } on Exception catch (e) {
            // If modal fails, fall back to toast
            logger.warning('Failed to show notification modal: $e');
          }
        }
      }
    }
  }

  Future<void> setupFirebaseMessaging() async {
    final notificationsSettings =
        await _firebaseMessaging.getNotificationSettings();

    final shouldRequestPermission =
        notificationsSettings.authorizationStatus ==
            AuthorizationStatus.denied ||
        notificationsSettings.authorizationStatus ==
            AuthorizationStatus.notDetermined;

    if (shouldRequestPermission) {
      final notificationSettings = await _firebaseMessaging.requestPermission();

      if (notificationSettings.authorizationStatus ==
              AuthorizationStatus.notDetermined ||
          notificationSettings.authorizationStatus ==
              AuthorizationStatus.denied) {
        return;
      }
    }

    final fcmToken =
        Platform.isIOS && !(await SafeDevice.isRealDevice)
            ? await _firebaseMessaging.getAPNSToken()
            : await _firebaseMessaging.getToken();
    _fcmToken = fcmToken;

    if (fcmToken == null) {
      return;
    }

    logger.info('FCM Token: $fcmToken');

    //register device token every time the app is opened
    await _registerDeviceToken(fcmToken);
    final userId = await secureStorage.getUserId();

    if (userId == null) {
      return;
    }

    await _firebaseMessaging.subscribeToTopic('user_$userId');
  }

  Future<void> _registerDeviceToken(String token) async {
    final resp = await dioService.post(
      url: '/notifications/fcm-token',
      data: {'fcmToken': token},
    );

    if (resp.statusCode == 200) {
      logger.info('FCM token registered successfully');
    } else {
      logger.severe('Error registering FCM token: ${resp.data}');
    }
  }

  Future<void> unregisterDeviceToken() async {
    final resp = await dioService.delete(url: '/notifications/fcm-token');

    if (resp.statusCode == 200) {
      logger.info('FCM token unregistered successfully');
    } else {
      logger.severe('Error unregistering FCM token: ${resp.data}');
    }
  }
}
