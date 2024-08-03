import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Center(
            child: Text(
          'Privacy Policy',
          style: TextStyle(color: Colors.black),
        )),
        backgroundColor: Color(0xFFFEF7F0),
        elevation: 0,
      ),
      body: WebView(
        initialUrl: "https://flutterbugsolver.blogspot.com/",
      ),
    );
  }
}
