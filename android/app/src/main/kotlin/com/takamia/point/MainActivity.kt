package com.daejeoni.di
import android.annotation.TargetApi
import android.content.ActivityNotFoundException
import android.content.Intent
import android.content.Intent.*
import android.os.Build

//import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.net.URISyntaxException

import android.os.Bundle
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity

private var CHANNEL = "fcm_default_channel";

class MainActivity: FlutterActivity() {

    //@TargetApi(Build.VERSION_CODES.DONUT)
    override fun onCreate(savedInstanceState: Bundle?){
        super.onCreate(savedInstanceState)

        GeneratedPluginRegistrant.registerWith(FlutterEngine(this))
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when {
                call.method.equals("getAppUrl") -> {
                    try
                    {
                        val url: String = call.argument("url")!!
                        println("-----------------");
                        println(url.toString());
                        println("------------------");
                        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.DONUT) {
                            parseUri(url, URI_INTENT_SCHEME)
                        } else {
                            TODO("VERSION.SDK_INT < DONUT")
                        }
                        result.success(intent.dataString)

                    } catch (e: URISyntaxException) {
                        result.notImplemented()
                    } catch (e: ActivityNotFoundException) {
                        result.notImplemented()
                    }
                }
            }
        }
    }
}


