import 'package:flutter/material.dart';
import 'package:project_f2/api.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'homepage/homepage.dart';
import 'login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;
  bool _isLoggedIn = false;
  late ApiService apiService;
  @override
  void initState() {
    apiService = ApiService();
    super.initState();
    initUniLinks();
  }

  void initUniLinks() async {
    // Initialize uni_links
    _sub = linkStream.listen((String? link) {
      if (link != null) {
        handleDeepLink(Uri.parse(link));
      }
    }, onError: (err) {
      // Handle error
    });

    // Get initial deep link if the app was launched with one
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      handleDeepLink(Uri.parse(initialLink));
    }
  }

  void handleDeepLink(Uri uri) {
    if (uri.scheme == 'project_f2') {
      if (uri.host == 'authenticated') {
        final sessionId = uri.queryParameters['sessionId'] ?? '';
        final baseUrl = uri.queryParameters['baseUrl'] ?? '';

        setState(() {
          _isLoggedIn = true;
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              sessionId: sessionId,
              baseUrl: baseUrl,
            ),
          ),
        );
      } else if (uri.host == 'not_authenticated') {
        setState(() {
          _isLoggedIn = false;
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      } else if (uri.host == 'callback') {
      } else {
        setState(() {
          _isLoggedIn = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget initialRoute;

    // if (_isLoggedIn) {
    //   initialRoute = const HomePage(sessionId: '', baseUrl: '');
    // } else {
    //   initialRoute = const Scaffold(
    //     body: LoginPage(),
    //   );
    // }
    initialRoute = const HomePage(
        sessionId: 'q37uvsac4g0qejdil7zw9lq3r4z24uja',
        baseUrl: "http://10.0.2.2:8000/spotify");
    return MaterialApp(
      title: 'f2',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            color: Colors.white,
          ),
          bodySmall: TextStyle(
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: initialRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
