import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stack_trace/stack_trace.dart';

enum FlutterErrorReportLogLevel {
  silent, error, warn, info, debug, verbose
}

class FlutterErrorReportConfig {
  /// SDK Debug 信息开关, 默认关闭
  final bool debugMode;
  /// 自定义渠道标识
  final String channel;
  /// 设置标识
  final String deviceId;
  /// 日志等级
  final FlutterErrorReportLogLevel reportLogLevel;

  FlutterErrorReportConfig({this.debugMode = false, this.channel = '', this.deviceId = '', this.reportLogLevel = FlutterErrorReportLogLevel.silent});

  Map<String, dynamic> toMap() {
    return {
      'debugMode': debugMode,
      'channel': channel,
      'deviceId': deviceId,
      'reportLogLevel': reportLogLevel.index,
    };
  }
}

class FlutterErrorReport {
  static const MethodChannel _channel =
      const MethodChannel('flutter_error_report');

  static final FlutterErrorReport _instance = FlutterErrorReport._internal();
  factory FlutterErrorReport() => _instance;

  FlutterErrorReport._internal();

  /// Initializes the plugin.
  /// If you want to opt in into sending the reports please first call this method.
  Future<void> initializeBugly(String appId, FlutterErrorReportConfig config) async => 
    await _channel.invokeMethod('initializeBugly', { 'appId': appId, 'config': config.toMap() });

  /// Reports an Error.
  /// A good rule of thumb is not to catch Errors as those are errors that occur
  /// in the development phase.
  ///
  /// This method provides the option In case you want to catch them anyhow.
  /// @deprecated please use reportCrash
  Future<void> onError(FlutterErrorDetails details,
      {bool forceCrash = false}) async {
    final data = {
      'message': details.exception.toString(),
      'cause': details.stack == null ? 'unknown' : _cause(details.stack),
      'trace': details.stack == null ? [] : _traces(details.stack),
      'forceCrash': forceCrash,
    };

    return await _channel.invokeMethod('reportError', data);
  }

  Future<void> reportError(dynamic error, StackTrace stackTrace,
      {bool forceCrash = false}) async {
    final data = {
      'message': error.toString(),
      'cause': stackTrace == null ? 'unknown' : _cause(stackTrace),
      'trace': stackTrace == null ? [] : _traces(stackTrace),
      'forceCrash': forceCrash,
    };

    return await _channel.invokeMethod('reportError', data);
  }

  Future<void> setUserId(String userId) async {
    return await _channel.invokeMethod('setUserId', {"UserId": setUserId});
  }

  List<Map<String, dynamic>> _traces(StackTrace stack) =>
      Trace.from(stack).frames.map(_toTrace).toList(growable: false);

  String _cause(StackTrace stack) => Trace.from(stack).frames.first.toString();

  Map<String, dynamic> _toTrace(Frame frame) {
    final List<String> tokens = frame.member.split('.');

    return {
      'library': frame.library ?? 'unknown',
      'line': frame.line ?? 0,
      // Global function might have thrown the exception.
      // So in some cases the method is the first token
      'method': tokens.length == 1 ? tokens[0] : tokens.sublist(1).join('.'),
      // Global function might have thrown the exception.
      // So in some cases class does not exist
      'class': tokens.length == 1 ? null : tokens[0],
    };
  }

}
