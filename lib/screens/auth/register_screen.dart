import 'package:elancer_chat_app/controllers/fb_auth_controller.dart';
import 'package:elancer_chat_app/models/process_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _nameTextController;

  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Register",
          style: GoogleFonts.acme(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        leading: IconButton(
            onPressed: () => Navigator.pop(context, "Return To Login"),
            icon: Icon(Icons.arrow_back_ios)),
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Create Account",
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
              "Enter new account details",
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
              controller: _nameTextController,
              keyboardType: TextInputType.text,
              style: GoogleFonts.acme(),
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                print("name");
              },
              decoration: InputDecoration(
                hintText: "Name",
                prefixIcon: Icon(Icons.person),
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
              height: 20.h,
            ),
            ElevatedButton(
              child: Text(
                "Register",
                // style: GoogleFonts.acme(),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.h),
              ),
              onPressed: ()async=>await _performRegister(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performRegister() async {
    if (_checkData()) {
      await _register();
    }
  }

  bool _checkData() {
    if (_nameTextController.text.isNotEmpty &&
        _emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  Future<void> _register() async {
    ProcessResponse processResponse = await FbAuthController().createAccount(
        name: _nameTextController.text,
        email: _emailTextController.text,
        password: _passwordTextController.text);
    if (processResponse.success == true) {
      Navigator.pop(context);
      //TODO: [ShowSnanckbar]
    } else {
      //TODO: [ShowSnanckbar]
    }
  }
}
