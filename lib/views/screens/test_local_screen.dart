import 'package:flutter/material.dart';
import '../../helpers/local_notifications_helpers.dart';

class TestLocalScreen extends StatefulWidget {
  const TestLocalScreen({super.key});

  @override
  State<TestLocalScreen> createState() => _TestLocalScreenState();
}

class _TestLocalScreenState extends State<TestLocalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:
        ElevatedButton(onPressed: (){
          LocalNotificationsHelper helper = LocalNotificationsHelper();
          //helper.showAlert(message);
        }, child: Text("click")),),
    );
  }
}
