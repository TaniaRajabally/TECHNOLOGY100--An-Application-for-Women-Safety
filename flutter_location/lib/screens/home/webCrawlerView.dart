import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class WebCrawlerView extends StatelessWidget {
  String url;
   final webview = FlutterWebviewPlugin();
  WebCrawlerView(String urlparam){
    this.url = urlparam;
  }
  
  
  

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      appBar: AppBar(
        title:Text("Women Safety News")
      ),
      url: url,
      withJavascript: true,
      withZoom: true,
      withLocalStorage: true,
      );
  }
}