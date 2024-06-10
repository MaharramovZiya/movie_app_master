import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app_riverpod/screens/main_screen.dart';
import 'package:movie_app_riverpod/screens/splash_screen.dart';

void main() {
  runApp( SplashScreen(onInitializationComplete: () =>runApp(const ProviderScope(child:  MyApp())),key: UniqueKey(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
       
      ),
      initialRoute: '/',
      routes: {
        '/':(context)=>  MainScreen()
      },
    );
  }
}
