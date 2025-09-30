import 'package:flutter/material.dart';

import 'page/main/main_page.dart';
import 'shared/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('app.dart~build: ');
    return MaterialApp(
      title: '小明工具箱',
      theme: AppTheme.themeData,
      home: MainPage(),
    );
  }
}
