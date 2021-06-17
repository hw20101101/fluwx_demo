import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as image;
import 'package:path/path.dart' as path; 

import 'package:fluwx/fluwx.dart';

const String WECHAT_APPID = 'your app id';
const String WECHAT_UNIVERSAL_LINK = 'your Universal Links'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
 
  @override
  State<StatefulWidget> createState() {     
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initFluwx();
  }

  void _initFluwx() async {
    await registerWxApi(
        appId: WECHAT_APPID,
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: WECHAT_UNIVERSAL_LINK);
    var result = await isWeChatInstalled;
    print("-->> is installed $result");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  
  String? _result = "none";

  @override
  void initState() {
    super.initState();     

    weChatResponseEventHandler.distinct((a, b) => a == b).listen((res) {
      if (res is WeChatAuthResponse) {
        setState(() {
          _result = "state: ${res.state} \n code: ${res.code}";
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wechat Kit Demo2'),
      ),
      body: ListView(
        children: <Widget>[
          
          OutlineButton( //登录按钮
            onPressed: () {              
              sendWeChatAuth(
                  scope: "snsapi_userinfo", state: "wechat_sdk_demo_test")
              .then((data) {});
            },
            child: const Text("微信登录"),
          ),
          const Text("响应结果:"),
          Text("$_result"),
        ],
      ),
    );
  }
}

