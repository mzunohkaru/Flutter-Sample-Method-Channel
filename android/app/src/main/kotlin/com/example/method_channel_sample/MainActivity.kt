package com.example.multios

import android.Manifest
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
//import com.example.multios.map.GoogleMapViewFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    // 追加
    private val CHANNEL = "com.example.multios/location"

    // 2) 追加
//    var locationListener: LocationListener? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 1) 追加
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "getLocation") {
                val location = getLocation() // 実際の位置情報取得ロジックを実装
                if (location.isEmpty()) {
                    result.error("UNAVAILABLE", "Location not available.", null)
                } else {
                    result.success(location)
                }
            }
            // 2) 追加
            else {
                result.notImplemented()
            }
        }

        // 2) 追加
    }

    // 1) 位置情報取得ロジック
    private fun getLocation(): String {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), 1)
            return ""
        }

        val locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
        val location: Location? = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
        return if (location == null) {
            ""
        } else {
            "${location.latitude},${location.longitude}"
        }
    }

// 2) 位置情報の更新を開始するロジックを実装
}
