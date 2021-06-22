
import 'dart:async';

import 'package:flutter/services.dart';

class NosqlTest {
  static const MethodChannel _channel =
      const MethodChannel('nosql_test');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
