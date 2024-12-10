package com.isonet.app

import android.R
import android.app.AlertDialog
import android.util.Log
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.core.content.ContextCompat
import android.content.Context
import android.content.pm.PackageManager
import android.Manifest
import android.app.Activity;
import androidx.core.app.ActivityCompat
import android.os.Build

class MainActivity : FlutterActivity() {

    var builder: AlertDialog.Builder? = null

    private val CHANNEL = "flutter.native/helper"


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->


        }
    }
}
