import 'package:campus_mart/Network/NotificationServiceClass.dart';
import 'package:campus_mart/Provider/auth_provider.dart';
import 'package:campus_mart/Provider/feed_back_provider.dart';
import 'package:campus_mart/Provider/message_provider.dart';
import 'package:campus_mart/Provider/product_provider.dart';
import 'package:campus_mart/Provider/sign_up_provider.dart';
import 'package:campus_mart/Provider/theme_provider.dart';
import 'package:campus_mart/Provider/user_provider.dart';
import 'package:campus_mart/Utils/conn.dart';
import 'package:campus_mart/Wrapper.dart';
import 'package:campus_mart/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey = GlobalKey<
    ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.initialize();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  const isLive = false;
  String onesignalAppId = isLive
      ? dotenv.env['ONE_SIGNAL_APP_ID_LIVE']!
      : dotenv.env['ONE_SIGNAL_APP_ID_TEST']!;
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId(onesignalAppId);

  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => UserProvider()),
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => ProductProvider()),
            ChangeNotifierProvider(create: (_) => SignUpProvider()),
            ChangeNotifierProvider(create: (_) => FeedbackProvider()),
            ChangeNotifierProvider(create: (_) => MessageProvider()),
            ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ],
          child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          title: 'Campus Mart',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          scaffoldMessengerKey: rootScaffoldMessengerKey,
          theme: provider.isDark ? ThemeData.dark() : ThemeData.light(),
          home: const MySplashPage(),
        );
      },
    );
  }
}

class MySplashPage extends StatefulWidget {
  const MySplashPage({super.key});

  @override
  State<MySplashPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MySplashPage> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return const Wrapper();
  }
}
