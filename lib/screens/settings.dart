// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:musicplayer/themes/theme-provider.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(title: Text('Setting')),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.all(25),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'DarkMode',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Switch.adaptive(
                        value: themeProvider.isDarkMode,
                        onChanged: (value) {
                          final provider = Provider.of<ThemeProvider>(context,
                              listen: false);
                          provider.toggleTheme(value);
                        })
                    // Radio(value: true, groupValue: () {}, onChanged: (value) {})
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 1,
                ),
              ],
            ),
          ),
        ));
  }
}
