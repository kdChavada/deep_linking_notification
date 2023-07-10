import 'package:deep_linking_notification/page/home_page.dart';
import 'package:deep_linking_notification/utils/NotificationUtils.dart';
import 'package:deep_linking_notification/utils/SharedPref.dart';
import 'package:deep_linking_notification/utils/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await PushNotificationService().setupInteractedMessage();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initFCM();
    initNotification();
  }

  initFCM() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    debugPrint(fcmToken);
    await SharedPrefs.writeValue(PrefConstants.fcmToken, fcmToken);
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      SharedPrefs.writeValue(PrefConstants.fcmToken, fcmToken);
    });
  }

  getFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await SharedPrefs.writeValue(PrefConstants.fcmToken, token);
  }

  initNotification() async {
    String? token = await FirebaseMessaging.instance.getToken();
    await SharedPrefs.writeValue(PrefConstants.fcmToken, token);

    FirebaseMessaging.instance.onTokenRefresh.listen((token) async {
      await SharedPrefs.writeValue(PrefConstants.fcmToken, token);
      debugPrint('FirebaseToken: $token');
      /*  var isLogin = SharedPrefs.readBoolValue(PrefConstants.isUserLogin);
      if (isLogin && token.isNotEmpty) {
        try {
          // await AuthAPIs.registerFCM(token);
        } catch (e) {
          e.printError();
        }
      }*/
    });

    FirebaseMessaging.onMessage.listen(
      (event) {
        NotificationUtils.handleNotificationOnForeground(event);
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (event) {
        NotificationUtils.handleNotificationOnAppOpened(remoteMessage: event);
      },
    );
    SchedulerBinding.instance.addPostFrameCallback(
      (_) {
        NotificationUtils.handleNotificationOnAppOpened();
      },
    );
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      NotificationUtils.handleNotificationOnAppOpened(remoteMessage: message, isAppKilled: true);
    });
    debugPrint('GetFirebaseToken1: ${SharedPrefs.readStringValue(PrefConstants.fcmToken)}');
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Deep Linking And Notification',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [GetPage(name: '/', page: () => const HomePage())],
    );
  }
}
