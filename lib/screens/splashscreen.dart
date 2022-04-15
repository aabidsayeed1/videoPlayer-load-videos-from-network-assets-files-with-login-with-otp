// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/screens/musicplayer.dart';

import 'login-page.dart';

class SplashInitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashPage();
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return LoginPage();
            } else if (snapshot.data!.phoneNumber != null) {}
            return SplashPage();
          }),
    );
  }
}

class SplashPage extends StatefulWidget {
  static const id = '/SplashPage';

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer(Duration(seconds: 3), () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => MusicPlayer()));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text('MazXha YUP'))),
          Text(
            'VideoPlayer',
            style: TextStyle(fontSize: 30, fontFamily: 'roboto-bold'),
          ),
          Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}
