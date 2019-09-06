package com.example.flutter_error_report.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * @ Description: 工具类集合
 * @ Author: 樊磊
 * @ Email:fanlei01@missfresh.cn
 * @ CreateDate: 2019-09-06 14:45
 */
public class ErrorReportUtils {


    private ErrorReportUtils() {
    }

    /**
     * list转换成map
     *
     * @param list 列表
     */
    public static Map<String, String> arrayListToMap(ArrayList<String> list) {
        if (list == null || list.isEmpty()) {
            return null;
        }
        Map<String, String> map = new HashMap<>();
        for (int i = 0; i < list.size(); i++) {
            map.put(String.valueOf(i), list.get(i));
        }
        return map;
    }

}
