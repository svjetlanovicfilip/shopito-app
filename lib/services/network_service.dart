import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';

enum NetworkStatus { online, offline }

class NetworkService {
  NetworkService() {
    _connectivitySubscriptions = _connectivity.onConnectivityChanged.listen(
      (statuses) => networkStatusController.add(_getNetworkStatus(statuses)),
    );
  }

  final _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscriptions;

  final StreamController<NetworkStatus> networkStatusController =
      StreamController<NetworkStatus>();

  Future<NetworkStatus> checkConnectivity() async {
    List<ConnectivityResult> results;

    try {
      results = await _connectivity.checkConnectivity();
    } on PlatformException {
      return NetworkStatus.offline;
    }

    return _getNetworkStatus(results);
  }

  NetworkStatus _getNetworkStatus(List<ConnectivityResult> statuses) {
    for (final status in statuses) {
      if (status == ConnectivityResult.mobile ||
          status == ConnectivityResult.wifi) {
        return NetworkStatus.online;
      }
    }

    return NetworkStatus.offline;
  }

  Future<bool> isAppOnline() async {
    final r = await _connectivity.checkConnectivity();

    // First check if we have connectivity
    if (_getNetworkStatus(r) != NetworkStatus.online) {
      return false;
    }

    // Then verify actual internet access by attempting to resolve a DNS lookup
    try {
      final result = await InternetAddress.lookup('google.com').timeout(
        const Duration(seconds: 3),
        onTimeout: () => throw TimeoutException('DNS lookup timeout'),
      );
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  void dispose() => _connectivitySubscriptions.cancel();
}
