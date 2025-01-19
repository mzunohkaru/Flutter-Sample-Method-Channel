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

    private val CHANNEL = "com.example.method_channel_sample"

    var locationListener: LocationListener? = null

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "getLocation") {
                val location = getLocation()
                if (location.isEmpty()) {
                    result.error("UNAVAILABLE", "Location not available.", null)
                } else {
                    result.success(location)
                }
            } else if (call.method == "watchLocation") {
                if (watchLocation()) {
                    result.success(true)
                } else {
                    result.error("UNAVAILABLE", "Location not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.event_channel_sample").setStreamHandler(
            object : EventChannel.StreamHandler {

                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    locationListener = LocationListener { location ->
                        events?.success("${location.latitude},${location.longitude}")
                    }
                }

                override fun onCancel(arguments: Any?) {
                    // 位置情報の更新を停止するロジックを実装
                }
            }
        )

    }

    // 位置情報取得ロジック
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

    // 位置情報の更新を開始するロジックを実装
    private fun watchLocation(): Boolean {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), 1)
            return false
        }

        val locationManager = getSystemService(LOCATION_SERVICE) as LocationManager
        locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 10000, 0f, locationListener!!)
        return true
    }
}