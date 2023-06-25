import 'package:elancer_chat_app/controllers/fb_auth_controller.dart';
import 'package:elancer_chat_app/models/process_response.dart';
import 'package:elancer_chat_app/screens/auth/register_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Login",
          style: GoogleFonts.acme(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome back ...",
              style: GoogleFonts.acme(
                color: Colors.black,
                fontSize: 20.sp,
                // fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "Enter email & password",
              style: GoogleFonts.acme(
                color: Colors.black45,
                fontSize: 15.sp,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            TextField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              style: GoogleFonts.acme(),
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                print("email");
              },
              decoration: InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
                hintStyle: GoogleFonts.acme(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue.shade400,
                    width: 1,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            TextField(
              controller: _passwordTextController,
              keyboardType: TextInputType.text,
              style: GoogleFonts.acme(),
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.done,
              obscureText: _obscureText,
              onSubmitted: (value) {
                // ToDo: CALL (_performLogin) function
              },
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() {
                    _obscureText = !_obscureText;
                  }),
                ),
                hintStyle: GoogleFonts.acme(),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.blue.shade400,
                    width: 1,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: TextButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, "/forget_password_screen"),
                  child: Text(
                    "Forget Password?",
                  ),
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )),
            SizedBox(
              height: 20.h,
            ),
            ElevatedButton(
              child: Text(
                "LOGIN",
                // style: GoogleFonts.acme(),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.h),
              ),
              onPressed: ()async => await _performLogin(),
            ),
            SizedBox(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Don\'t have an account? "),
                TextButton(
                  onPressed: () async {
                    print("object");
                    // String? data =await Navigator.of(context).pushNamed<String>('/register_screen');
                    String? data = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ));
                    print("Return Data: ${data ?? "Nothing Returned"}");
                  },
                  child: Text("Create Now!"),
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                    child: Divider(
                  endIndent: 5,
                  thickness: 0.8.h,
                )),
                Text(
                  "OR",
                  style: GoogleFonts.acme(fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Divider(
                  indent: 5,
                  thickness: 0.8.h,
                )),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DecoratedBox(
                    decoration: BoxDecoration(
                        color: Color(0xff4267B2),
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 0),
                              blurRadius: 6,
                              spreadRadius: 3),
                        ]),
                    child: IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.facebook,
                        color: Colors.white,
                      ),
                      // icon: Icon(
                      //   Icons.facebook,size: 20,
                      //   color: Colors.white,
                      // ),
                      onPressed: () {},
                    )),
                SizedBox(
                  width: 10.w,
                ),
                DecoratedBox(
                    decoration: BoxDecoration(
                        color: Color(0xffc71610),
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 0),
                              blurRadius: 6,
                              spreadRadius: 3),
                        ]),
                    child: IconButton(
                      // icon: Icon(
                      //   Icons.,
                      //   color: Colors.white,
                      // ),
                      icon: FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.white,
                      ),

                      onPressed: () {},
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performLogin() async {
    if (_checkData()) {
      await _login();
    }
  }

  bool _checkData() {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> _login() async {
    ProcessResponse processResponse = await FbAuthController().signIn(
        email: _emailTextController.text,
        password: _passwordTextController.text);
    if (processResponse.success) {
      Navigator.pushReplacementNamed(context, '/main_screen');
    }
  }
}
