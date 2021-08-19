import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(), // Provide light theme
      darkTheme: ThemeData.dark(), // Provide dark theme
      home: SplashScrren(),
    );
  }
}

class SplashScrren extends StatelessWidget {
  const SplashScrren({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreenView(
      navigateRoute: MyHomePage(),
      duration: 5000,
      imageSize: 200,
      imageSrc: "assets/images/Vanix.png",
      backgroundColor: HexColor('#D7EFFB'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pos = 1;
  final _key = UniqueKey();

  void _handleLoad(String value) {
    setState(() {
      pos = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text('Are you sure you want to exit?'),
                actions: <Widget>[
                  // ignore: deprecated_member_use
                  FlatButton(
                    child: Text('No'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  // ignore: deprecated_member_use
                  FlatButton(
                    child: Text('Yes, exit'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            });

        return value == true;
      },
      child: SafeArea(
          child: IndexedStack(
        index: pos,
        children: [
          WebView(
            key: _key,
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (ff) {
              setState(() {
                pos = 1;
              });
            },
            onPageFinished: _handleLoad,
            gestureNavigationEnabled: true,
            initialUrl: 'https://www.vanix.com.ng/',
          ),
          Container(
            color: Colors.white,
            child: Center(
              child: CupertinoActivityIndicator(animating: true, radius: 15),
            ),
          ),
        ],
      )),
    );
  }
}
