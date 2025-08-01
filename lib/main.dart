import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:jobs_app/auth/loginScreen.dart';
import 'package:jobs_app/home/homeScreen.dart';
import 'package:jobs_app/providers/auth_provider.dart';
import 'package:jobs_app/utils/Const.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

Future<String?> readToken() async {
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      const storage = FlutterSecureStorage();
      return await storage.read(key: 'jwt');
    } else {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('jwt');
    }
  } catch (e) {
    debugPrint('! Storage read error: $e');
    return null;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  final token = await readToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider()..setInitialToken(token),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: auth.isAuthenticated == false
          ?  LoginScreen()
          : PersistentTabView(
              tabs: [
                PersistentTabConfig(
                  screen: const HomeScreen(),
                  item: ItemConfig(
                    icon: const Icon(Icons.home),
                    title: "Home",
                    activeForegroundColor: Colorone,
                  ),
                ),
                PersistentTabConfig(
                  screen: const SecondScreen(),
                  item: ItemConfig(
                    icon: const Icon(Icons.search_outlined),
                    title: "Search",
                  ),
                ),
                PersistentTabConfig(
                  screen: const ThirdScreen(),
                  item: ItemConfig(
                    icon: const Icon(Icons.history),
                    title: "Reservations",
                  ),
                ),
                PersistentTabConfig(
                  screen: const ThirdScreen(),
                  item: ItemConfig(
                    icon: const Icon(Icons.person),
                    title: "Account",
                  ),
                ),
              ],
              navBarBuilder: (navBarConfig) => Style4BottomNavBar(
                navBarConfig: navBarConfig,
              ),
            ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Messages Screen')));
}

class ThirdScreen extends StatelessWidget {
  const ThirdScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Settings Screen')));
}
