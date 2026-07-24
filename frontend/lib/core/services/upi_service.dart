import 'package:flutter/services.dart';

class UpiApp {
  final String name;
  final String packageName;

  UpiApp({
    required this.name,
    required this.packageName,
  });

  factory UpiApp.fromJson(
    Map<dynamic, dynamic> json,
  ) {
    return UpiApp(
      name: json["name"],
      packageName: json["packageName"],
    );
  }
}

class UpiService {
  static const MethodChannel _channel =
      MethodChannel("fairsplit/upi");

  static Future<List<UpiApp>> getInstalledApps() async {
    final result =
        await _channel.invokeMethod<List<dynamic>>(
      "getInstalledApps",
    );

    return result!
        .map(
          (e) => UpiApp.fromJson(e),
        )
        .toList();
  }

  static Future<void> launch({
    required String packageName,
    required String upiId,
    required String name,
    required double amount,
    required String note,
  }) async {
    final uri =
        "upi://pay"
        "?pa=$upiId"
        "&pn=${Uri.encodeComponent(name)}"
        "&am=${amount.toStringAsFixed(2)}"
        "&cu=INR"
        "&tn=${Uri.encodeComponent(note)}";

    await _channel.invokeMethod(
      "launchUpi",
      {
        "packageName": packageName,
        "upiUri": uri,
      },
    );
  }
}