import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

import '../../conf/app_conf.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/main';
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final appLinks = AppLinks();
  StreamSubscription<Uri>? linkSub;
  final fluwx = Fluwx();
  FluwxCancelable? fluwxSub;

  @override
  void initState() {
    super.initState();
    debugPrint('main_page.dart~initState: ');
    linkSub = appLinks.uriLinkStream.listen((uri) {
      debugPrint('main_page.dart~initState: $uri');
    });
  }

  @override
  void dispose() {
    linkSub?.cancel();
    fluwxSub?.cancel();
    super.dispose();
  }

  void wxLogin(BuildContext context) async {
    await fluwx.registerApi(appId: AppConf.wxAppId);
    var isInstalled = await fluwx.isWeChatInstalled.catchError((e) {
      debugPrint('main_page.dart~wxLogin: $e');
      return false;
    });
    if (!isInstalled) {
      debugPrint('main_page.dart: 微信未安装');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('微信未安装'), duration: Duration(seconds: 2)),
      );
      return;
    }
    fluwxSub = fluwx.addSubscriber((r) {
      if (r is WeChatAuthResponse) {
        debugPrint('main_page.dart~addSubscriber: ${r.state} ${r.code}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('微信${r.state} ${r.code}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
    var w = NormalAuth(scope: 'snsapi_userinfo', state: 'wechat_sdk_demo_test');
    await fluwx.authBy(which: w);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('小明工具箱')),
      body: SafeArea(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => wxLogin(context),
              child: Text('微信登录'),
            ),
            const Placeholder(),
          ],
        ),
      ),
    );
  }
}
