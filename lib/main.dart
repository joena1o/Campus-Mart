import 'dart:async';
import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/feed_back_provider.dart';
import 'package:campus_mart/Provider/message_provider.dart';
import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/Provider/sign_up_provider.dart';
import 'package:campus_mart/Provider/theme_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/Utils/colors.dart';
import 'package:campus_mart/Wrapper.dart';
import 'package:campus_mart/firebase_options.dart';
import 'package:campus_mart/network/notification_service_class.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await requestNotificationPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService.initialize();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(dotenv.env['ONE_SIGNAL_APP_ID_LIVE']!);
  OneSignal.Notifications.requestPermission(true);

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProvider()),
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => SignUpProvider()),
    ChangeNotifierProvider(create: (_) => FeedbackProvider()),
    ChangeNotifierProvider(create: (_) => MessageProvider()),
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return const MySplashPage();
  }
}

class MySplashPage extends StatefulWidget {
  const MySplashPage({super.key});

  @override
  State<MySplashPage> createState() => _MyHomePageState();
}

 Future<void> requestNotificationPermission() async {
    await Permission.notification.request();
  }

class _MyHomePageState extends State<MySplashPage> {
  Color? statusBarColor;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      Provider.of<ThemeProvider>(context, listen: false).loadTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    statusBarColor = Theme.of(context).scaffoldBackgroundColor;

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: primary,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark));

    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
            title: 'Campus Mart',
            scrollBehavior: NoGlowScrollBehavior(),
            debugShowCheckedModeBanner: provider.isTest,
            navigatorKey: navigatorKey,
            scaffoldMessengerKey: rootScaffoldMessengerKey,
            theme: provider.isDark ? ThemeData.dark() : ThemeData.light(),
            home: const Wrapper());
      },
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
