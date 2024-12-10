import 'package:call_log_app/custom/custom_color.dart';
import 'package:call_log_app/network/api_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/session_manager.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool viewPass = true;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0.5,
        backgroundColor: CustomColor.MainColor,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 75,
          ),
          Image.asset(
            'assets/img/company_logo.png',
            height: 80,
          ),
          /*Transform.rotate(
            angle: -0.2,
            child: Container(

              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.green,
                // borderRadius: BorderRadius.circular(8.0)
              ),
              child: Text('Rotato',style: TextStyle(fontSize: 50,color: Colors.white),),
            ),
          ),*/
          const SizedBox(height: 75),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 3,
                      blurRadius: 3,
                      color: Colors.grey.shade400,
                    ),
                  ],
                  color: CustomColor.MainColor,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'LOGIN',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    // const Divider(),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8)),
                        fillColor: Colors.white,
                        filled: true,
                        prefixIcon: const Icon(Icons.alternate_email_rounded),
                        prefixIconColor: Colors.green,
                        hintText: 'Email',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: _passController,
                      obscureText: viewPass,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8)),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                viewPass = !viewPass;
                              });
                            },
                            child: viewPass
                                ? const Icon(
                                    CupertinoIcons.eye_slash,
                                    color: Colors.green,
                                  )
                                : const Icon(
                                    CupertinoIcons.eye,
                                    color: Colors.green,
                                  ),
                          ),
                          prefixIcon: const Icon(CupertinoIcons.lock),
                          prefixIconColor: Colors.green,
                          hintText: 'Password',
                          hintStyle: GoogleFonts.poppins()),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    _isLoading
                        ? SpinKitWaveSpinner(
                            trackColor: Colors.white,
                            waveColor: Colors.greenAccent.shade700,
                            color:
                                Colors.greenAccent.shade700, // Customize color
                            size: 50.0, // Customize size
                          )
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                backgroundColor: Colors.greenAccent.shade700,
                                minimumSize: const Size(double.infinity, 50)),
                            onPressed: () {
                              signIn(context);
                            },
                            child: Text(
                              'LOGIN',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void signIn(BuildContext context) async {
    String email = _emailController.text;
    String password = _passController.text;

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Enter Email',
        ),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Enter Password'),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });
    Map<String, String> body = {'email': email, 'password': password};
    ApiHelper.loginNew(body).then((value) {
      setState(() {
        _isLoading = false;
      });
      if (value.status == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            backgroundColor: Colors.greenAccent.shade700,
            content: Text(
              textAlign: TextAlign.center,
              'Welcome ${value.user!.name}',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
        SessionManager.setUserLoggedIn(true);
        SessionManager.setUserName(value.user!.name!);
        SessionManager.setUserEmail(value.user!.email!);
        SessionManager.setUserId(value.user!.id!.toString());
        SessionManager.setToken(value.user!.token!);
        SessionManager.setMobile(value.user!.mobile ?? 'Number Not Found');
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15))),
            backgroundColor: Colors.red,
            content: Text(
              textAlign: TextAlign.center,
              'Try Again',
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }
    });
  }
}
