package com.rishitkothari.fairsplit

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class UpiChannel(
    private val context: Context
) : MethodChannel.MethodCallHandler {

    companion object {
        private const val CHANNEL = "fairsplit/upi"

        private val UPI_APPS = listOf(
            Pair("Google Pay", "com.google.android.apps.nbu.paisa.user"),
            Pair("PhonePe", "com.phonepe.app"),
            Pair("Paytm", "net.one97.paytm"),
            Pair("BHIM", "in.org.npci.upiapp"),
            Pair("Amazon Pay", "com.amazon.mShop.android.shopping")
        )
    }

    fun register(
        messenger: BinaryMessenger
    ) {
        MethodChannel(
            messenger,
            CHANNEL
        ).setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: MethodChannel.Result
    ) {

        when (call.method) {

            "getInstalledApps" -> {
                result.success(
                    getInstalledApps()
                )
            }

            "launchUpi" -> {

                val packageName =
                    call.argument<String>("packageName")!!

                val upiUri =
                    call.argument<String>("upiUri")!!

                launchUpi(
                    packageName,
                    upiUri,
                    result
                )
            }

            else ->
                result.notImplemented()
        }
    }

    private fun getInstalledApps(): List<Map<String, String>> {

        val pm = context.packageManager

        val installed =
            mutableListOf<Map<String, String>>()

        for ((name, packageName) in UPI_APPS) {

            try {

                pm.getPackageInfo(
                    packageName,
                    0
                )

                installed.add(
                    mapOf(
                        "name" to name,
                        "packageName" to packageName
                    )
                )

            } catch (_: PackageManager.NameNotFoundException) {
            }
        }

        return installed
    }

    private fun launchUpi(
        packageName: String,
        upiUri: String,
        result: MethodChannel.Result
    ) {

        try {

            val intent = Intent(
                Intent.ACTION_VIEW,
                Uri.parse(upiUri)
            )

            intent.setPackage(
                packageName
            )

            intent.addFlags(
                Intent.FLAG_ACTIVITY_NEW_TASK
            )

            context.startActivity(
                intent
            )

            result.success(true)

        } catch (e: Exception) {

            result.error(
                "UPI_ERROR",
                e.message,
                null
            )
        }
    }
}