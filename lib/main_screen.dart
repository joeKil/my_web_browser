import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // 레이트를 붙여주면 늦게 초기화하겠다. 레이트 없이는 빨간불 들어옴.
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    // 웹브라우저 띄움.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('나만의 웹브라우저'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
          // 눌렀을 때 어떤값을 표시할건지
          PopupMenuButton<String>(
            // 값 들어오는 곳.
            onSelected: (value) {
              _webViewController.loadUrl(value);
            },
            itemBuilder: (context) => [
              // 무슨 값을 받을건지 타입을 넣어줘야함.
              PopupMenuItem<String>(
                value: 'https://www.google.com',
                child: Text('구글'),
              ),
              PopupMenuItem<String>(
                value: 'https://www.naver.com',
                child: Text('네이버'),
              ),
              PopupMenuItem<String>(
                value:
                    'https://map.naver.com/v5/search/%EC%9A%A9%EC%82%B0%20%EB%8F%99%EB%AC%BC%EB%B3%91%EC%9B%90/place/1537525136?placePath=%3Fentry=pll%26from=nx%26fromNxList=true',
                child: Text('카카오'),
              ),
            ],
          ),
        ],
      ),
      // 뒤로가기
      body: WillPopScope(
        // 비동기로 작성해야함.
        onWillPop: () async {
          if (await _webViewController.canGoBack()) {
            // 뒤로가기
           await _webViewController.goBack();
           return false;
          }
          return true;
        },
        child: WebView(
          initialUrl: 'https://flutter.dev',
          javascriptMode: JavascriptMode.unrestricted,
          // 컨트롤러로 각 페이지에 접속할 수 있도록 url밸류를 넘기는 컨트롤러임.
          onWebViewCreated: (controller) {
            _webViewController = controller;
          },
        ),
      ),
    );
  }
}
