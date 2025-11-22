import 'dart:ffi';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'local_notifications_helpers.dart';

class FCMHelpers{
  FirebaseMessaging fcm = FirebaseMessaging.instance;

  initFCM() async{
    fcm.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );

    String? appToken = await fcm.getToken();
    print("the Device is $appToken");
    HandleFCM();
  }

  HandleFCM(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotificationsHelper localNotificationsHelper = LocalNotificationsHelper();
      localNotificationsHelper.showAlert(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){

    });
  }
}