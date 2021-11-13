import 'package:financiera/pages/login_page.dart';
import 'package:financiera/pages/principal_page.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Financiera App',
      initialRoute: 'bienvenida',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        'bienvenida':(BuildContext context) => Bienvenida(),
        'login'     :(BuildContext context) => Login(),
        'principal' :(BuildContext context) => Principal()
      },
      
    );
  }
}


class Bienvenida extends StatefulWidget {
  @override
  _BienvenidaState createState() => _BienvenidaState();
}

class _BienvenidaState extends State<Bienvenida> {
  @override
  Widget build(BuildContext context) {
    return 
    SplashScreen(
      seconds: 5,
      navigateAfterSeconds: Login(),
      //title: Text('La Progresiva',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
      image: Image.asset('assets/logo1.jpg'),
      backgroundColor: Colors.white,
      loadingText: Text('Impulsado por INSIDE II'),
      photoSize: 200,

    );
  }
}