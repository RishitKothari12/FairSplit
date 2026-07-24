package com.rishitkothari.fairsplit

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        UpiChannel(this).register(
            flutterEngine.dartExecutor.binaryMessenger
        )
    }
}