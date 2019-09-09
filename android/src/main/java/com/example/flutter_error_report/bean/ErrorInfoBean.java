package com.example.flutter_error_report.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * @ Description: 错误信息的Bean
 * @ Author: 樊磊
 * @ Email:fanlei01@missfresh.cn
 * @ CreateDate: 2019-09-06 14:23
 */
public class ErrorInfoBean {

    private String cause;

    private String message;

    private ArrayList<HashMap> trace;

    private Boolean forceCrash;

    public ErrorInfoBean() {
    }

    public String getCause() {
        return cause;
    }

    public void setCause(String cause) {
        this.cause = cause;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public ArrayList<HashMap> getTrace() {
        return trace;
    }

    public void setTrace(ArrayList<HashMap> trace) {
        this.trace = trace;
    }

    public Boolean getForceCrash() {
        return forceCrash;
    }

    public void setForceCrash(Boolean forceCrash) {
        this.forceCrash = forceCrash;
    }

    @Override
    public String toString() {
        return "ErrorInfoBean{" +
                "cause='" + cause + '\'' +
                ", message='" + message + '\'' +
                ", trace=" + trace.toString() +
                ", forceCrash=" + forceCrash +
                '}';
    }
}
