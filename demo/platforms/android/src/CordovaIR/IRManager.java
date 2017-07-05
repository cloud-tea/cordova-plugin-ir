package CordovaIR;

import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CallbackContext;

import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.os.Handler;
import android.app.ProgressDialog;
import android.util.Log;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnDismissListener;

import android.app.Activity;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.view.View;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.tiqiaa.client.IRemoteClient;
import com.tiqiaa.client.impl.RemoteClient;
import com.tiqiaa.constant.ApplianceType;
import com.tiqiaa.remote.entity.Brand;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import CordovaIR.utils.AppliantTypeUtils;

/**
 * This class echoes a string called from JavaScript.
 */
public class IRManager extends CordovaPlugin implements IRemoteClient.CallbackOnBrandLoaded {
    private Activity activity;
    private CallbackContext callbackCtx;
    private static final String TAG = "IR";
    private List<Brand> brands = new ArrayList<Brand>();
    private static final String GET_BRAND = "GET_BRAND";
    private static final String SEND_IR_CODE = "SEND_IR_CODE";
    private static final String SEARCH_REMOTE = "SEARCH_REMOTE";
    private static final String ADD_REMOTE = "ADD_REMOTE";
    private static final String GET_ALL_APPLICANCE = "GET_ALL_APPLICANCE";

    @Override
    public void initialize(CordovaInterface cordova, CordovaWebView webview) {
        super.initialize(cordova, webView);

        activity = cordova.getActivity();
    }


    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        callbackCtx = callbackContext;
        PluginResult result;

        if(action.equals(GET_BRAND)) {

            result = new PluginResult(PluginResult.Status.NO_RESULT);
            result.setKeepCallback(true);
            callbackCtx.sendPluginResult(result);

            final IRemoteClient client = new RemoteClient(activity);
            new Thread(new Runnable() {
                @Override
                public void run() {
                    client.load_brands(IRManager.this);
                }
            }).start();

            return true;
        } else if(action.equals(SEND_IR_CODE)) {
            String code = args.getString(0);

            return true;
        } else if(action.equals(ADD_REMOTE)) {


            return true;
        } else if(action.equals(SEARCH_REMOTE)) {


            return true;
        } else if(action.equals(GET_ALL_APPLICANCE)) {
            String applicancesString = JSON.toJSONString(AppliantTypeUtils.getAllAppliance());

            callbackCtx.success(applicancesString);
            return true;
        }

        return false;
    }

    /*
    *  获取到品牌信息
    * */
    @Override
    public void onBrandLoaded(int errcode, List<Brand> bs) {
        Log.e(TAG, "errcode:"+errcode);

        if (bs != null)
        {
            for (int i = 0; i < bs.size(); i++)
            {
                brands.add(bs.get(i));
            }

            PluginResult result = new PluginResult(PluginResult.Status.OK, new JSONArray(brands));

            result.setKeepCallback(false);

            if (callbackCtx != null) {
                callbackCtx.sendPluginResult(result);
                callbackCtx = null;
            }

        }
        else
        {
            Log.e(TAG, "Brand loaded with null");
        }
    }


    @Override
    public void onDestroy() {

    }

}