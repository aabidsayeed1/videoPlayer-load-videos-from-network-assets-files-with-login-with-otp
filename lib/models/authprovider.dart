import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:musicplayer/screens/musicplayer.dart';

class Authprovider {
  Future<bool?> loginwithPhone(BuildContext context, String phone) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    TextEditingController otpC = TextEditingController();
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (AuthCredential credential) async {
          UserCredential result = await _auth.signInWithCredential(credential);
          Navigator.pop(context);
          User? user = result.user;
          if (user != null) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => MusicPlayer()));
          } else {
            print(' User Does not exist');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          Fluttertoast.showToast(msg: e.toString());
          print(e.toString());
        },
        codeSent: (String verficationCode, int? token) {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text('Enter otp'),
                  content: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: otpC,
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () async {
                          final code = otpC.text;
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verficationCode,
                                  smsCode: code);
                          UserCredential result =
                              await _auth.signInWithCredential(credential);
                          User? user = result.user;
                          if (user != null) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MusicPlayer()));
                            print('sucess');
                          } else {
                            Fluttertoast.showToast(msg: 'error');
                          }
                        },
                        child: Text('Verify'))
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: (id) => {});
  }
}
