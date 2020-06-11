import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchWhatsApp({
  @required String phone,
  String message = '',
}) async {
  String url() {
    if (Platform.isIOS) {
      return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
    } else {
      return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
    }
  }

  if (await canLaunch(url())) {
    await launch(url());
  } else {
    throw ('الرجاء تثبيت واتساب');
  }
}
