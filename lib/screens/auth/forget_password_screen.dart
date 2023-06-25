import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  late TextEditingController _emailTextController;

  @override
  void initState() {
    super.initState();
    _emailTextController = TextEditingController();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false ,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Forget Password",
          style: GoogleFonts.acme(
              color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color:Colors.black),

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
              "Forget Password ...",
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
              "Enter email to send reset link",
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

            SizedBox(height: 20.h,),
            ElevatedButton(
              child: Text(
                "Send",
                // style: GoogleFonts.acme(),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40.h),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
