import 'package:elancer_chat_app/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key? key,
    required this.message,
    required this.onLongPress,
  }) : super(key: key);

  final Message message;
  final void Function() onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      // async {
      //   print("Long press");
      //   await showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Text("data"),
      //     ),
      //   );
      // },
      onTap: () {
        print("tap press");
      },
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
      if (message.messageType.name == MessageType.text.name)
      Text(
      message.message,
      style: GoogleFonts.acme(
        color: message.deletedForEveryOne
            ? Colors.grey.shade700
            : Colors.black,
      ),
    ),
    if (message.messageType == MessageType.image)
    message.deletedForEveryOne?Text(
    message.message,
    style: GoogleFonts.acme(
    color: message.deletedForEveryOne
    ? Colors.grey.shade700
        : Colors.black,
    ),
    ):Image.network(
    message.message,
    height: 300.h,
    fit: BoxFit.cover,
    ),
    // SizedBox(height: 10.h,),
    SizedBox(
    height: 10.h,
    ),
    Text(
    getFormattedTime(),
    style: GoogleFonts.acme(
    color: Colors.black45,
    fontSize: 12.sp,
    fontWeight: FontWeight.w500),
    )
    ,
    ]
    ,
    )
    ,
    );
    // return InkWell(
    //   onLongPress: onLongPress,
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.end,
    //     children: [
    //       if (message.messageType == MessageType.text)
    //         // Text(
    //         //   message.message,
    //         //   style: GoogleFonts.nanumGothic(
    //         //     color: message.deletedForEveryOne
    //         //         ? Colors.grey.shade700
    //         //         : Colors.black,
    //         //   ),
    //         // ),
    //       if (message.messageType == MessageType.image)
    //         Material(
    //           borderRadius: BorderRadius.circular(10),
    //           clipBehavior: Clip.antiAlias,
    //           child: Image.network(
    //             message.message,
    //             height: 300.h,
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //
    //       //DATE
    //       SizedBox(height: 5.h),
    //       Text(
    //         getFormattedTime(),
    //         style: GoogleFonts.nanumGothic(
    //           color: Colors.black45,
    //           fontSize: 12.sp,
    //           fontWeight: FontWeight.w500,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  String getFormattedTime() {
    DateTime dateTime = DateTime.parse(message.sentAt);
    return DateFormat.jm().format(dateTime);
  }
}
