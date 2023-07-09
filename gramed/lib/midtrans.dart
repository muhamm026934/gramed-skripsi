// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gramed/page_routes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
// #enddocregion platform_imports

void main() => runApp(const MaterialApp(home: WebViewExample()));


class WebViewExample extends StatefulWidget {
  const WebViewExample({super.key});

  @override
  State<WebViewExample> createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  late final WebViewController _controller;
  
  get session => null;

  @override
  void initState() {
    super.initState();

    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromARGB(0, 0, 0, 0))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
  Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('http://192.168.1.3:8080/gramed/midtrans/examples/snap-redirect/checkout-process.php')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse('http://192.168.1.3:8080/gramed/midtrans/examples/snap-redirect/checkout-process.php'));

    // #docregion platform_features
    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text('Pembayaran'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        actions: <Widget>[
          NavigationControls(webViewController: _controller),
          // SampleMenu(webViewController: _controller),
        ],
      ),
      body: Container(
        color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      height:MediaQuery.of(context).size.height ,
        child: Expanded(
          child: WebViewWidget(
            controller: _controller
            ),
        )),
      floatingActionButton: favoriteButton(),
    );
  }

  Widget favoriteButton() {
    return FloatingActionButton(
      onPressed: () {
        PageRoutes.routeToHome(context);
      },
      child: const Icon(Icons.home),
    );
  }
}

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
  doPostRequest,
  loadLocalFile,
  loadFlutterAsset,
  loadHtmlString,
  transparentBackground,
  setCookie,
}


class NavigationControls extends StatelessWidget {
  const NavigationControls({super.key, required this.webViewController});

  final WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await webViewController.canGoBack()) {
              await webViewController.goBack();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No back history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await webViewController.canGoForward()) {
              await webViewController.goForward();
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No forward history item')),
                );
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => webViewController.reload(),
        ),
      ],
    );
  }
}

final List<String> htmlStrings = [
  '''<p>Table shows some compounds and the name of their manufacturing process</p>
<table style="border-collapse: collapse; width: 100%; height: 85px;" border="1">
<tbody>
<tr style="height: 17px;">
<td style="width: 150%; text-align: center; height: 17px;">Compounds/Elements</td>
<td style="width: 150%; text-align: center; height: 17px;">Manufacture process</td>
</tr>
<tr style="height: 17px;">
<td style="width: 150%; height: 17px;">Nitric acid</td>
<td style="width: 150%; height: 17px;">Ostwald's process</td>
</tr>
<tr style="height: 17px;">
<td style="width: 150%; height: 17px;">Ammonia</td>
<td style="width: 150%; height: 17px;">Haber's process</td>
</tr>
<tr style="height: 17px;">
<td style="width: 150%; height: 17px;">Sulphuric acid</td>
<td style="width: 150%; height: 17px;">Contact process</td>
</tr>
<tr style="height: 17px;">
<td style="width: 150%; height: 17px;">Sodium</td>
<td style="width: 150%; height: 17px;">Down's process</td>
</tr>
</tbody>
</table>''',
  '''<p>\(L=[M{L }^{2 }{T }^{-2 }{A }^{-2 }]\)</p>
<p>\(C=[{M }^{-1 }{L }^{-2 }{T }^{4 }{A }^{2 }]\)</p>
<p>\(R=[M{L }^{2 }{T }^{-3 }{A }^{-2 }]\)</p>
<p>\(\therefore \frac {R}{L}=\frac{[M{L }^{2 }{T }^{-2 }{A }^{-2 }]}{[M{L }^{2 }{T }^{-3 }{A }^{-2 }]}=[T]\)</p>''',
  '''<p>Displacement(s)\(=\left(13.8\pm0.2\right)m\)</p>
<p>Time(t)\(=\left(4.0\pm0.3\right)s\)</p>
<p>Velocity(v)\(=\frac{13.8}{4.0}=3.45m{s}^{-1}\)</p>
<p>\(\frac{\delta v}{v}=\pm\left(\frac{\delta s}{s}+\frac{\delta t}{t}\right)=\pm\left(\frac{0.2}{13.8}+\frac{0.3}{4.0}\right)=\pm0.0895\)</p>
<p>\(\delta v =\pm0.0895*3.45=\pm0.3\)(rounding off to one place of decimal)</p>
<p>\(v=\left(3.45\pm0.3\right)m{s}^{-1}\)</p>''',
  '''<p>The only real numbers satisfying \(x^2=4\) are 2 and -2. But none of them satisfy the final condition, \(x+2=3\). So, there is no real number such that these conditions are met. Hence this is null set.</p>
<p>Note that, for \(x\) to be a memner of \(\{x:p(x),q(x)\}\),&nbsp;<em><strong>both</strong></em> \(p(x)\) and \(q(x)\) should be true.</p>''',
];