import 'package:flutter/widgets.dart';

import 'conf/app_conf.dart';

export 'conf/app_conf.dart';
export 'util/extensions.dart';

class Global {
  Global._();
  static Future init() async {
    debugPrint('global.dart~init: ${AppConf.isProduct}');
    WidgetsFlutterBinding.ensureInitialized();
  }
}
