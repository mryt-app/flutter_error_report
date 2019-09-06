package com.example.flutter_error_report.manager;

import android.content.Context;
import android.util.Log;
import com.example.flutter_error_report.bean.ErrorInfoBean;
import com.example.flutter_error_report.utils.ErrorReportUtils;
import com.tencent.bugly.crashreport.CrashReport;

/**
 * @ Description: Bugly管理类
 * @ Author: 樊磊
 * @ Email:fanlei01@missfresh.cn
 * @ CreateDate: 2019-09-06 13:04
 */
public class FlutterBuglyErrorReportManager {


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
        Log.d("fanlei", "appId = " + appId);
        CrashReport.initCrashReport(context, appId, isDebug);
    }

    /**
     * 设置用户id
     *
     * @param userId 用户ID
     */
    public void setUserIdToBugly(String userId) {
        Log.d("fanlei", "userId = " + userId);
        CrashReport.setUserId(userId);
    }

    /**
     * 上传错误信息
     *
     * @param uploadErrorBean 错误信息类
     */
    public void uploadErrorToBugly(ErrorInfoBean uploadErrorBean) {
        Log.d("fanlei", "ErrorInfoBean = " + uploadErrorBean.toString());
        CrashReport
                .postException(8, "Flutter Exception ->", uploadErrorBean.getMessage(), uploadErrorBean.getCause(),
                        null);
    }


}
