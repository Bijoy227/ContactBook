import 'package:flutter/material.dart';
import './screens/login.dart';
import './screens/home.dart';
import './screens/register.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': ((context) => LogIn()),
          'register': (context) => Registration(),
          'home': (context) => HomePage(),
        },
        theme: ThemeData(
          fontFamily: 'RiseofKingdom',
        ),
      ),
    );
