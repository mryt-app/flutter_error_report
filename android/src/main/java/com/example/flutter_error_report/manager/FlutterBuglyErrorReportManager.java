package com.example.flutter_error_report.manager;

import android.annotation.SuppressLint;
import android.content.Context;
import com.example.flutter_error_report.bean.ErrorInfoBean;
import com.tencent.bugly.crashreport.CrashReport;
import org.json.JSONObject;

/**
 * @ Description: Bugly管理类
 * @ Author: 樊磊
 * @ Email:fanlei01@missfresh.cn
 * @ CreateDate: 2019-09-06 13:04
 */
public class FlutterBuglyErrorReportManager {

    private final String TAG = "FlutterBuglyErrorReport";

    private static class FlutterBuglyErrorReportManagerInstance {

        private static final FlutterBuglyErrorReportManager instance = new FlutterBuglyErrorReportManager();
    }

    private FlutterBuglyErrorReportManager() {

    }

    public static FlutterBuglyErrorReportManager getInstance() {
        return FlutterBuglyErrorReportManagerInstance.instance;
    }

    /**
     * 初始化Bugly
     *
     * @param context 上下文
     * @param appId 注册bugly的id
     * @param isDebug 是否开始debug模式
     */
    public void initBugly(Context context, String appId, boolean isDebug) {
        CrashReport.initCrashReport(context, appId, isDebug);
    }

    /**
     * 设置用户id
     *
     * @param userId 用户ID
     */
    public void setUserIdToBugly(String userId) {
        CrashReport.setUserId(userId);
    }

    /**
     * 上传错误信息
     *
     * @param bean 错误信息类
     */
    @SuppressLint("DefaultLocale")
    public void uploadErrorToBugly(ErrorInfoBean bean) {
        try {

            StringBuilder builder = new StringBuilder();
            for (int i = 0; i < bean.getTrace().size(); i++) {
                JSONObject jsonObject = new JSONObject(bean.getTrace().get(i));
                String temp = String.format("%s.%s(%s:%d)\n",
                        jsonObject.optString("class"),
                        jsonObject.optString("method"),
                        jsonObject.optString("library"),
                        jsonObject.optInt("line"));
                builder.append(temp);
            }

            // 上传错误异常
            CrashReport.postException(8, bean.getCause(), bean.getMessage(), builder.toString(), null);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }


}
