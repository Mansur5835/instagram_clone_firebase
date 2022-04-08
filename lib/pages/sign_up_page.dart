import 'package:flutter/material.dart';
import 'package:instagram_flutter/pages/sign_in_page.dart';
import 'package:instagram_flutter/services/prefs.dart';

import '../services/auth_fribase.dart';
import '../services/notification.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _nameC = TextEditingController();
  TextEditingController _emailC = TextEditingController();
  TextEditingController _passwordC = TextEditingController();

  creadUser() async {
    String name = _nameC.text.trim();
    String email = _emailC.text.trim();
    String password = _passwordC.text.trim();

    Map<String, dynamic> map = await Notfcation.deviceParams();

    await FirebaseServices.creadUser(name, email, password, map).then((id) {
      if (id != null) {
        Prefs.saveId(id).then((value) {
          print(value);
          if (value) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) {
              return SignIn(
                id: id,
              );
            }));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent.shade700,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Instagram",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Billabong",
                        color: Colors.white,
                        fontSize: 40),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.center,
                    height: 49,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _nameC,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "User name",
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.center,
                    height: 49,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _emailC,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.center,
                    height: 49,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _passwordC,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    alignment: Alignment.center,
                    height: 49,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: _passwordC,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Confing password",
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: creadUser,
                    child: Container(
                        padding: EdgeInsets.only(left: 10),
                        alignment: Alignment.center,
                        height: 47,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white),
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Already have an Account?",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) {
                          return SignIn();
                        }));
                      },
                      child: Text(
                        "Sing Ip",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
