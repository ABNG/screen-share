import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_agora_plugin/flutter_agora_plugin.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  TextEditingController channelName = TextEditingController();
  TextEditingController agoraID = TextEditingController();
  TextEditingController agoraToken = TextEditingController();
  Map<Permission, PermissionStatus> statuses;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<bool> checkPermission() async {
    statuses = await [
      Permission.storage,
      Permission.microphone,
      Permission.camera
    ].request();
    return statuses[Permission.storage] == PermissionStatus.granted &&
        statuses[Permission.microphone] == PermissionStatus.granted &&
        statuses[Permission.camera] == PermissionStatus.granted;
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterAgoraPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: ListView(
          children: [
            Text('Running on: $_platformVersion\n'),
            TextField(
              controller: channelName,
              decoration: InputDecoration(
                hintText: "channel name",
              ),
            ),
            TextField(
              controller: agoraID,
              decoration: InputDecoration(
                hintText: "agora app id",
              ),
            ),
            TextField(
              controller: agoraToken,
              decoration: InputDecoration(
                hintText: "agora access token",
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  bool val = await checkPermission();
                  if (val) {
                    await FlutterAgoraPlugin.joinChannel(
                        channelName.text, agoraID.text, agoraToken.text);
                  } else {
                    debugPrint("please allow permission");
                  }
                },
                child: Text("Join")),
            ElevatedButton(
                onPressed: () async {
                  await FlutterAgoraPlugin.openCamera;
                },
                child: Text("Camera")),
            ElevatedButton(
                onPressed: () async {
                  await FlutterAgoraPlugin.openRender;
                },
                child: Text("Render")),
            ElevatedButton(
                onPressed: () async {
                  await FlutterAgoraPlugin.openScreenShare;
                },
                child: Text("ScreenShare")),
            ElevatedButton(
                onPressed: () async {
                  await FlutterAgoraPlugin.openSwitchCamera;
                },
                child: Text("SwitchCamera")),
            ElevatedButton(
                onPressed: () async {
                  await FlutterAgoraPlugin.openMute;
                },
                child: Text("Mute")),
            ElevatedButton(
                onPressed: () async {
                  await FlutterAgoraPlugin.leaveChannel;
                },
                child: Text("Leave")),
          ],
        ),
      ),
    );
  }
}
