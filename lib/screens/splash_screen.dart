import 'dart:convert';

// packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

// services
import 'package:movie_app_riverpod/services/http_service.dart';
import 'package:movie_app_riverpod/services/movie_service.dart';

// model
import '../models/config_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required this.onInitializationComplete});
  final VoidCallback onInitializationComplete;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _setup(context).then((_) {
      Future.delayed(const Duration(seconds: 2)).then(
          (_) => widget.onInitializationComplete());
    });
  }

  Future<void> _setup(BuildContext context) async {
    final getIt = GetIt.instance;

    try {
      final configFile = await rootBundle.loadString("assets/config/main.json");
      final configData = jsonDecode(configFile);

      getIt.registerSingleton<AppConfig>(AppConfig(
        API_KEY: configData['API_KEY'],
        BASE_API_URL: configData['BASE_API_URL'],
        BASE_IMAGE_API_URL: configData['BASE_IMAGE_API_URL'],
      ));

      getIt.registerSingleton<HttpService>(HttpService());
      getIt.registerSingleton<MovieService>(MovieService());
    } catch (e) {
      print('Error during setup: $e');
      // Optionally, show an error message or retry logic here
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Splash",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage("assets/images/logo.png"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
