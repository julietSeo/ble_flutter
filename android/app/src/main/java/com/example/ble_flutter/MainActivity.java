package com.example.ble_flutter;

import android.os.Build;

import androidx.annotation.NonNull;
import androidx.core.content.*;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import android.bluetooth.*;
import android.util.*;
import android.content.pm.*;

import java.util.*;
import java.lang.reflect.Method;

public class MainActivity extends FlutterActivity {

    BluetoothAdapter mBleAdapter = BluetoothAdapter.getDefaultAdapter();

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        final MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), "com.example.ble_flutter");
        channel.setMethodCallHandler(handler);
    }

    private MethodChannel.MethodCallHandler handler = (methodCall, result) -> {
        if (methodCall.method.equals("getBondedDevices")) {
            List<Map<String, Object>> devices = new ArrayList<>();

            for(BluetoothDevice device : mBleAdapter.getBondedDevices()){
                Map<String, Object> results = new HashMap<>();
                if(device.getName() != null) {
                    results.put("name", device.getName());
                } else {
                    results.put("name", "No Name");
                }
                results.put("address", device.getAddress());
                devices.add(results);
            }
            result.success(devices);
        } else {
            result.notImplemented();
            Log.d("MethodChannel", "result.notImplemented()");
        }
    };


}
