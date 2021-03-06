import 'package:battery_manager/classes/new_user.dart';
import 'package:battery_manager/screens/wrapper.dart';
import 'package:battery_manager/services/auth.dart';
import 'package:battery_manager/services/notificationService.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

var initializationSettingAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');

final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_error) {
      return Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            'something went wrong',
          ));
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            'Loading..',
          ));
    }
    return StreamProvider<NewUser?>.value(
      value: AuthService().user,
      //initialData: null,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Battery Manager',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
        ),
        home: Wrapper(),
      ),
    );
  }
}
