import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/google_fonts.dart';

class StoriesScreen extends StatefulWidget {
  const StoriesScreen({Key? key}) : super(key: key);

  @override
  State<StoriesScreen> createState() => _StoriesState();
}

class _StoriesState extends State<StoriesScreen> {
  late ScrollController _scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController=ScrollController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: NeverScrollableScrollPhysics(),

      children: [
        Container(
          height: 80.h,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            border: Border.all(
              color: Colors.grey.shade300,
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                color: Colors.black45,
                blurRadius: 6,
              ),
            ],
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60.w,
                height: 60.h,
                margin: EdgeInsetsDirectional.only(end: 10.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue.shade100,
                  border: Border.all(
                    color: Colors.orange,
                    width: 1,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Username",
                    style: GoogleFonts.acme(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                        color: Colors.black),
                  ),
                  Text(
                    "Status",
                    style: GoogleFonts.acme(
                        fontWeight: FontWeight.w300,
                        fontSize: 14.sp,
                        color: Colors.black45),
                  ),
                ],
              ),
              Spacer(),
              IconButton(onPressed: () {}, icon: Icon(Icons.edit))
            ],
          ),
        ),
        Container(
          // height:_scrollController.position.maxScrollExtent,
          constraints:BoxConstraints(maxHeight: MediaQuery.of(context).size.height-186.h) ,
          child: ListView.builder(
            // physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 20.h),
            // shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.only(bottom:10.h ),
                child: Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.h,
                      margin: EdgeInsetsDirectional.only(end: 10.w),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.shade100,
                        border: Border.all(
                          color: Colors.orange,
                          width: 1,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          style: GoogleFonts.acme(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: Colors.black54),
                        ),
                        // Text(
                        //   "Status",
                        //   style: GoogleFonts.acme(
                        //       fontWeight: FontWeight.w300,
                        //       fontSize: 14.sp,
                        //       color: Colors.black45),
                        // ),
                      ],
                    ),
                    Spacer(),
                    // IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                  ],
                ),
              );
            },
            itemCount: 10,
          ),
        ),
      ],
    );
  }
}
