package com.example.flutter_error_report.manager;

import android.content.Context;
import com.example.flutter_error_report.bean.ErrorInfoBean;
import com.tencent.bugly.crashreport.CrashReport;
import org.json.JSONArray;
import org.json.JSONException;

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
     * @param uploadErrorBean 错误信息类
     */
    public void uploadErrorToBugly(ErrorInfoBean uploadErrorBean) {
        try {
            JSONArray jsonArray = new JSONArray();
            for (int i = 0; i < uploadErrorBean.getTrace().size(); i++) {
                jsonArray.put(i,uploadErrorBean.getTrace().get(i));
            }
            CrashReport.postException(8, uploadErrorBean.getCause(), uploadErrorBean.getMessage(), jsonArray.toString(4),
                    null);
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }


}
