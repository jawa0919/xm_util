import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/main';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final appLinks = AppLinks();
  StreamSubscription<Uri>? sub;

  @override
  void initState() {
    super.initState();
    debugPrint('main_page.dart~initState: ');
    sub = appLinks.uriLinkStream.listen((uri) {
      debugPrint('main_page.dart~initState: $uri');
    });
  }

  @override
  void dispose() {
    sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('小明工具箱'),
        centerTitle: true,
        actions: [Icon(CupertinoIcons.info_circle_fill)],
      ),
      body: SafeArea(child: const Placeholder()),
    );
  }
}
