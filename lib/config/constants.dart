import 'dart:io';

import 'package:safe_device/safe_device.dart';

class Constants {
  // Set at app startup for Android to distinguish emulator vs real device.

  // Dynamična konfiguracija na osnovu platforme
  static Future<String> get baseUrl async {
    if (Platform.isAndroid) {
      if (!(await SafeDevice.isRealDevice)) {
        // Android emulator koristi 10.0.2.2 da pristupi host mašini
        return 'http://10.0.2.2:8080/api';
      } else {
        return 'https://192.168.0.127:8080/api';
      }
    } else if (Platform.isIOS) {
      // iOS simulator može koristiti localhost ili 127.0.0.1
      return 'http://127.0.0.1:8080/api';
    } else {
      // Fallback za druge platforme
      return 'http://localhost:8080/api';
    }
  }

  static Future<String> get baseImageUrl async {
    if (Platform.isAndroid) {
      // Korištenje IP‑a računara na fizičkom uređaju, a 10.0.2.2 na emulatoru
      if (!(await SafeDevice.isRealDevice)) {
        return 'http://10.0.2.2:8080';
      } else {
        return 'http://192.168.0.127:8080';
      }
    } else if (Platform.isIOS) {
      // iOS simulator može koristiti localhost ili 127.0.0.1
      return 'http://127.0.0.1:8080';
    } else {
      // Fallback za druge platforme
      return 'http://localhost:8080';
    }
  }

  // Ako testirate na fizičkom uređaju, koristite IP adresu vaše mašine:
  // static const baseUrl = 'http://192.168.1.XXX:8080/api/auth';
}
