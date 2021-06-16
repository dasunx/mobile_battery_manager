import 'package:battery_manager/constants/constants.dart';
import 'package:battery_manager/constants/loading.dart';
import 'package:battery_manager/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  //const Register({Key? key}) : super(key: key);

  final Function toggleView;
  Register({required this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: secondary_bg_color,
            appBar: AppBar(
              backgroundColor: secondary_bg_color,
              elevation: 0.0,
              title: Text('Register'),
              actions: <Widget>[
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: secondary_bg_color,
                    ),
                    icon: Icon(Icons.person),
                    label: Text('Sign in'),
                    onPressed: () {
                      widget.toggleView();
                    })
              ],
            ),
            body: Column(children: <Widget>[
              Container(
                height: 165,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage("assets/images/login.png"))),
                    ))
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Hello, \nWelcome!",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 30.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20.0),
                                TextFormField(
                                  decoration:
                                      formFields.copyWith(hintText: 'Email'),
                                  validator: (val) =>
                                      val!.isEmpty ? 'Enter email' : null,
                                  onChanged: (val) {
                                    setState(() => email = val);
                                  },
                                ),
                                SizedBox(height: 20.0),
                                TextFormField(
                                  decoration:
                                      formFields.copyWith(hintText: 'Password'),
                                  obscureText: true,
                                  validator: (val) => val!.length < 4
                                      ? 'Password must be 4 characters or more'
                                      : null,
                                  onChanged: (val) {
                                    setState(() => password = val);
                                  },
                                ),
                                SizedBox(height: 20.0),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: secondary_bg_color,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                    ),
                                    child: Text(
                                      'Register',
                                      style: TextStyle(color: secondary_green),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => loading = true);
                                        dynamic result = await _auth
                                            .registerWithEmailAndPassword(
                                                email, password);
                                        if (result == null) {
                                          setState(() {
                                            error =
                                                'Please enter valid credentials';
                                            loading = false;
                                          });
                                        }
                                      }
                                    }),
                                SizedBox(height: 12.0),
                                Text(
                                  error,
                                  style: TextStyle(
                                      color: Colors.redAccent, fontSize: 14.0),
                                )
                              ],
                            ),
                          )),
                    ]),
              ),
            ]),
          );
  }
}
