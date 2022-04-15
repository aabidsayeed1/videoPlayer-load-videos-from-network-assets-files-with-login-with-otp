// ignore_for_file: unused_local_variable, prefer_const_declarations, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/login-page.dart';
import '../screens/settings.dart';

class NavigatorDrawer extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    final text = MediaQuery.of(context).platformBrightness == Brightness.dark
        ? 'DarkTheme'
        : 'LightTheme';
    final name = 'Abid Bin Syeed';
    final email = 'aabid@gmail.com';
    final dob = '11/02/1995';
    final urlImage =
        'https://media-exp1.licdn.com/dms/image/C4D03AQH5PFPH4odMIg/profile-displayphoto-shrink_200_200/0/1648738453286?e=1655337600&v=beta&t=GitFwAttUA3Np9--H9Ty0kI9EgHmXdojdJ8JnFr5qjI';

    return Drawer(
      child: Material(
        color: Color.fromRGBO(50, 75, 205, 1),
        child: ListView(
          padding: padding,
          children: <Widget>[
            buildHeader(
              name: name,
              email: email,
              dob: dob,
              urlImage: urlImage,
            ),
            buildMenuItem(
                text: 'LogOut',
                icon: Icons.logout,
                onClicked: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                      (route) => false);
                }),
            Divider(
              color: Colors.white,
              thickness: 1,
            ),
            buildMenuItem(
                text: 'Login/Register',
                icon: Icons.login,
                onClicked: () => selectedItem(context, 1)),
            buildMenuItem(
              text: 'Setting',
              icon: Icons.settings,
              onClicked: () => selectedItem(context, 2),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildHeader({
  required String urlImage,
  required String name,
  required String email,
  required String dob,
}) =>
    Container(
      padding: (EdgeInsets.symmetric(vertical: 40)),
      child: Row(
        children: [
          CircleAvatar(radius: 40, backgroundImage: NetworkImage(urlImage)),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                dob,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );

Widget buildMenuItem({
  required String text,
  required IconData icon,
  VoidCallback? onClicked,
}) {
  final color = Colors.white;
  final hoverColor = Colors.white70;
  return ListTile(
    leading: Icon(
      icon,
      color: color,
    ),
    title: Text(
      text,
      style: TextStyle(color: color),
    ),
    hoverColor: hoverColor,
    onTap: onClicked,
  );
}

void selectedItem(BuildContext context, int index) {
  Navigator.of(context).pop();
  switch (index) {
    case 1:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginPage()));

      break;
    case 2:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Settings()));

      break;
  }
}
