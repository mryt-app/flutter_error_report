package com.example.flutter_error_report;

import android.app.Activity;
import android.text.TextUtils;
import android.util.Log;
import com.example.flutter_error_report.bean.ErrorInfoBean;
import com.example.flutter_error_report.manager.FlutterBuglyErrorReportManager;
import com.tencent.bugly.crashreport.CrashReport;
import io.flutter.BuildConfig;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import org.json.JSONObject;

/**
 * FlutterErrorReportPlugin
 */
public class FlutterErrorReportPlugin implements MethodCallHandler {

    private Activity mActivity;

    public FlutterErrorReportPlugin(Activity activity) {
        this.mActivity = activity;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "flutter_error_report");
        channel.setMethodCallHandler(new FlutterErrorReportPlugin(registrar.activity()));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        try {
            if (call.method.equals("initializeBugly")) {
                // 初始化Bugly
                initializeBuglyWithArgument(call, result);
            } else if (call.method.equals("setUserId")) {
                // 设置用户ID
                setUserIdWithArgument(call, result);
            } else if (call.method.equals("reportError")) {
                // 上传错误
                uploadErrorWithArgument(call, result);
            } else {
                result.notImplemented();
            }
        } catch (Exception e) {
            CrashReport.postCatchedException(e);
        }
    }


    private void initializeBuglyWithArgument(MethodCall call, Result result) {
        if (!call.hasArgument("appId")) {
            result.success(returnResult("没有传递appId", false));
            return;
        }
        String appId = call.argument("appId");
        if (TextUtils.isEmpty(appId)) {
            result.success(returnResult("\'appId\'不能为null  or \'\'", false));
            return;
        }

        FlutterBuglyErrorReportManager.getInstance()
                .initBugly(mActivity.getApplication(), appId, BuildConfig.DEBUG);

        result.success(returnResult("初始化Bugly成功", true));

    }

    private void setUserIdWithArgument(MethodCall call, Result result) {
        if (!call.hasArgument("userId")) {
            result.success(returnResult("没有传递userId", false));
            return;
        }

        String userId = call.argument("userId");
        if (TextUtils.isEmpty(userId)) {
            result.success(returnResult("\'userId\'不能为null  or \'\'", false));
            return;
        }

        FlutterBuglyErrorReportManager.getInstance().setUserIdToBugly(userId);

        result.success(returnResult("设置userId成功", true));

    }

    private void uploadErrorWithArgument(MethodCall call, Result result) {
        // 取值
        String cause = call.argument("cause");
        if (TextUtils.isEmpty(cause)) {
            cause = "Flutter Error";
        }
        String message = call.argument("message");
        if (TextUtils.isEmpty(message)) {
            message = "";
        }
        ArrayList<HashMap> trace = call.argument("trace");
        Boolean forceCrash = call.argument("forceCrash");

        // 包装
        ErrorInfoBean errorInfoBean = new ErrorInfoBean();
        errorInfoBean.setCause(cause);
        errorInfoBean.setMessage(message);
        errorInfoBean.setTrace(trace);
        errorInfoBean.setForceCrash(forceCrash);

        // 上传
        FlutterBuglyErrorReportManager.getInstance().uploadErrorToBugly(errorInfoBean);

    }


    private String returnResult(String resultWithMessage, boolean success) {
        JSONObject jsonObject = new JSONObject();
        try {
            jsonObject.put("resultWithMessage", resultWithMessage);
            jsonObject.put("success", success);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return jsonObject.toString();
    }

}
