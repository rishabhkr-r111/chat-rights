import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Web View'),
      ),
      body: WebViewWidget(
        controller: WebViewController()..loadRequest(Uri.parse(url)),
      ),
    );
  }
}
