import 'package:flutter/material.dart';
import 'package:instagram_flutter/pages/home.dart';
import 'package:instagram_flutter/pages/sign_up_page.dart';
import 'package:instagram_flutter/services/auth_fribase.dart';

class SignIn extends StatefulWidget {
  String? id;
  SignIn({this.id});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailC = TextEditingController();
  TextEditingController _passwordC = TextEditingController();

  bool isLoad = false;

  signIn() {
    Navigator.push(context, MaterialPageRoute(builder: (c) {
      return Home();
    }));
  }

  getUser() async {
    if (widget.id != null) {
      setState(() {
        isLoad = true;
      });
      final map = await FirebaseServices.getUser(widget.id!);
      print(map);

      final _map = map as Map<String, dynamic>;
      _emailC.text = _map['email'];
      _passwordC.text = _map['password'];
      setState(() {
        isLoad = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent.shade700,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2 + 40,
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
                            style: TextStyle(color: Colors.white),
                            controller: _emailC,
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
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            style: TextStyle(color: Colors.white),
                            keyboardType: TextInputType.visiblePassword,
                            controller: _passwordC,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Password",
                                hintStyle: TextStyle(color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: signIn,
                          child: Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.center,
                              height: 47,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                  color: Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3 + 10,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Don`t have an Account?",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (c) {
                                return SignUp();
                              }));
                            },
                            child: Text(
                              "Sing up",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          isLoad
              ? Container(
                  color: Colors.black.withOpacity(0.4),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
