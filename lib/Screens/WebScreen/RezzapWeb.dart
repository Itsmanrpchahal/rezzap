import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// ignore: must_be_immutable
class RezzapWebView extends StatefulWidget {
  String webUrl = "";
  String title = "";
  bool contact = false;
  RezzapWebView(this.webUrl, this.title,this.contact);
  @override
  _RezzapWebViewState createState() => _RezzapWebViewState();
}

class _RezzapWebViewState extends State<RezzapWebView> {
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(widget.title,style: TextStyle(color: Colors.black),),
        actions: [
          (widget.contact)
              ? IconButton(
                  icon: Icon(Icons.contact_mail),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RezzapWebView(
                              "https://rezzap.com/contact", "Contact",false)),
                    );
                  })
              : Container()
        ],
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: widget.webUrl,
      ),
    );
  }
}
