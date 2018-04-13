package com.newmodule;

/**
 * Created by xuyazhong on 2018/1/9.
 */

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Bundle;
import android.provider.MediaStore;
import android.support.annotation.NonNull;
import android.support.v7.app.AlertDialog;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.xuyazhong.test.activity.VideoRecordActivity;
import android.support.v7.app.AppCompatActivity;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.WritableArray;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeArray;
import com.facebook.react.bridge.WritableNativeMap;

import java.io.File;
import java.util.Map;
import java.util.HashMap;
import org.json.*;

public class VideoRecordModule extends ReactContextBaseJavaModule {
    private static final int REQUEST_CODE_Video = 109;

    @Override
    public String getName() {
        return "VideoRecord";
    }

    public VideoRecordModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @ReactMethod
    public void start() {
        startActivity();
    }

    private void startActivity() {

        Activity currentActivity = getCurrentActivity();
        Intent intent = new Intent(currentActivity.getApplicationContext(), VideoRecordActivity.class);
        intent.putExtra(VideoRecordActivity.PREVIEW_SIZE_RATIO, 0);
        intent.putExtra(VideoRecordActivity.PREVIEW_SIZE_LEVEL, 0);
        intent.putExtra(VideoRecordActivity.ENCODING_MODE, 0);
        intent.putExtra(VideoRecordActivity.ENCODING_SIZE_LEVEL, 0);
        intent.putExtra(VideoRecordActivity.ENCODING_BITRATE_LEVEL, 0);
        intent.putExtra(VideoRecordActivity.AUDIO_CHANNEL_NUM, 0);
        currentActivity.startActivityForResult(intent, REQUEST_CODE_Video);

    }



}
