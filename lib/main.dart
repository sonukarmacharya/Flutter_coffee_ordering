import 'package:coffee_ordering_app/provider/login_provider.dart';
import 'package:coffee_ordering_app/provider/selected_provider.dart';
import 'package:coffee_ordering_app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Something went wrong");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => LoginProvider()),
              ChangeNotifierProvider(create: (_) => SelectedProvider()),
            ],
            child: GetMaterialApp(
              theme: ThemeData(
                appBarTheme: const AppBarTheme(
                  backgroundColor: Color.fromARGB(151, 83, 12, 12),
                  foregroundColor: Colors.white,
                ),
                iconTheme: const IconThemeData(color: Color(0xFF0C4BA2)),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(109, 120, 46, 12),
                    ), //button color
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Colors.white,
                    ), //text (and icon)
                  ),
                ),
              ),
              home: LoginScreen(),
              debugShowCheckedModeBanner: false,
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}
