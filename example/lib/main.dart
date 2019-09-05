import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_error_report/flutter_error_report.dart';

bool get isInDebugMode {
  // 假设为production模式
  bool inDebugMode = false;

  // Assert表达式只在开发模式下会被解析，在production模式下会被忽略。
  // 因此，以下代码只在开发模式下会将`inDebugMode`设为true。
  assert(inDebugMode = true);

  return inDebugMode;
}

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      // In development mode simply print to console.
      FlutterError.dumpErrorToConsole(details);
    } else {
      // In production mode report to the application zone to report to
      // Crashlytics.
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  bool optIn = true;
  if (optIn) {
    await FlutterErrorReport()
      .initializeBugly('b79b139c7e', FlutterErrorReportConfig(debugMode: true, reportLogLevel: FlutterErrorReportLogLevel.verbose));
  } else {
    // In this case Crashlytics won't send any reports.
    // Usually handling opt in/out is required by the Privacy Regulations
  }

  runZoned<Future<Null>>(() async {
    runApp(MyApp());
  }, onError: (error, stackTrace) async {
    // Whenever an error occurs, call the `reportCrash` function. This will send
    // Dart errors to our dev console or Crashlytics depending on the environment.
    debugPrint(error.toString());
    await FlutterErrorReport().reportError(error, stackTrace, forceCrash: false);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin Example'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: RaisedButton(
                onPressed: () {
                  final crash = List()[69];
                  debugPrint(crash);
                },
                child: Text('Crash'),
              ),
            ),
            Center(
              child: RaisedButton(
                onPressed: () {
                  try {
                    throw new FormatException();
                  } catch (exception, stack) {
                    debugPrint(exception.toString());
                    FlutterErrorReport().reportError(exception, stack, forceCrash: false);
                  }
                },
                child: Text('Manual exception'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
