import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voting_app/view/screen/homePage.dart';
import 'package:voting_app/view/screen/loginPage.dart';
import 'package:voting_app/view/screen/ragistrationPage.dart';
import 'package:voting_app/view/screen/splashScreen.dart';
import 'package:voting_app/view/screen/votePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/intro_screen',
      getPages: <GetPage>[
        GetPage(name: '/intro_screen', page: () => const IntroScreen()),
        GetPage(name: '/', page: () => const HomePage()),
        GetPage(name: '/login_page', page: () => const LoginPage()),
        GetPage(name: '/result_page', page: () => const VotePage()),
        GetPage(name: '/r_page', page: () => const RegistrationPage()),
      ],
    ),
  );
}
