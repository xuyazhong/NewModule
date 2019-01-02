package com.newmodule;

import android.os.AsyncTask;
import android.support.annotation.NonNull;
import android.util.Log;
import android.widget.Toast;

import com.espressif.iot.esptouch.task.__IEsptouchTask;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

import java.net.InetAddress;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

import com.espressif.iot.esptouch.EsptouchTask;
import com.espressif.iot.esptouch.IEsptouchResult;
import com.espressif.iot.esptouch.IEsptouchTask;

/**
 * Created by xuyazhong on 2018/4/2.
 */

public class ESPModule extends ReactContextBaseJavaModule {

    String TAG = "ESPModule";
    private EspWifiAdminSimple mWifiAdmin;
    private Callback mCallback; // 保存回调
    private final ReactApplicationContext reactContext;

    @Override
    public String getName() {
        return "ESP";
    }

    public ESPModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @ReactMethod
    public void getSSID(Callback callback) {
        mWifiAdmin = new EspWifiAdminSimple(reactContext);
        String apSsid = mWifiAdmin.getWifiConnectedSsid();
        callback.invoke(null, apSsid);
    }

    @ReactMethod
    public void Connect(String pwd, Callback callback) {
        this.mCallback = callback;
        String apSsid = mWifiAdmin.getWifiConnectedSsid();
        String apBssid = mWifiAdmin.getWifiConnectedBssid();
        if (apSsid == "" || apBssid == "") {
            invokeError("网络错误###");
            return;
        }
        new EsptouchAsyncTask().execute(pwd);
    }


    class EsptouchAsyncTask extends AsyncTask<String, Void, List<IEsptouchResult>> {
        private final Object mLock = new Object();
        private IEsptouchTask mEsptouchTask;

        //onPreExecute用于异步处理前的操作
        @Override
        protected void onPreExecute() {
            super.onPreExecute();

        }

        //在doInBackground方法中进行异步任务的处理.
        @Override
        protected List<IEsptouchResult> doInBackground(String... params) {
            try {
                int taskResultCount = 1;
                synchronized (mLock) {
                    String apSsid = mWifiAdmin.getWifiConnectedSsid();
                    String apPassword = params[0];
                    String apBssid = mWifiAdmin.getWifiConnectedBssid();
                    mEsptouchTask = new EsptouchTask(apSsid, apBssid, apPassword, reactContext);
                    List<IEsptouchResult> resultList = mEsptouchTask.executeForResults(taskResultCount);
                    return resultList;
                }
            } catch (Exception e) {
                Log.e(TAG, "doInBackground: error"+ e.toString());
            } finally {
                List<IEsptouchResult> resultList = new ArrayList<IEsptouchResult>();
                return  resultList;
            }
        }

        //onPostExecute用于UI的更新.此方法的参数为doInBackground方法返回的值.
        @Override
        protected void onPostExecute(List<IEsptouchResult> result) {
            Log.e(TAG, "onPostExecute: load");
            if (result.size() == 0) {
                Log.e(TAG, "size = 0");
                invokeError("错误###");
            } else {
                IEsptouchResult firstResult = result.get(0);
                execResult(firstResult);
            }
        }

    }

    private void execResult(IEsptouchResult result) {
        if (!result.isCancelled()) {
            if (result.isSuc()) {
                invokeSuccessWithResult(result.getInetAddress().getHostAddress());
            } else {
                invokeError("失败###");
            }
        } else {
            invokeError("cancel");
        }
    }

    /**
     * 识别成功时触发
     *
     */
    private void invokeSuccessWithResult(String result) {
        if (this.mCallback != null) {
            this.mCallback.invoke(null, result);
            this.mCallback = null;
        }
    }

    /**
     * 失败时触发
     */
    private void invokeError(String result) {
        if (this.mCallback != null) {
            this.mCallback.invoke(result, null);
            this.mCallback = null;
        }
    }

}
