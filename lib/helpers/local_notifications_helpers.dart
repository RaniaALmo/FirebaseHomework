import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsHelper {

    FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings androidsettings =AndroidInitializationSettings("@mipmap/ic_launcher");
    DarwinInitializationSettings iossettings = DarwinInitializationSettings();
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails("channel1", "Defaulte");
    DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    initLocalNotification() async{
      InitializationSettings settings = InitializationSettings(android: androidsettings,iOS: iossettings);
      await plugin.initialize(settings);
    }

    showAlert(RemoteMessage message){
      plugin.show(1, message.notification!.title, message.notification!.body, NotificationDetails(iOS: iosDetails, android: androidDetails));
    }
}