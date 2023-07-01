import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elancer_chat_app/controllers/fire_store_chat_controller.dart';
import 'package:elancer_chat_app/controllers/fire_store_user_controller.dart';
import 'package:elancer_chat_app/models/chat.dart';
import 'package:elancer_chat_app/models/chat_user.dart';
import 'package:elancer_chat_app/screens/app/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder< List<Chat> /*QuerySnapshot<Chat>*/>(
        stream: FireStoreChatController().getChats1(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            print(snapshot.data![0].chatUser!.name);
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                print("refchat");
                // print(snapshot.data!.docs[index].reference.path);
                // print(snapshot.data!.docs[index].data().chatUser!);

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5.h),
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return ChatScreen(
                              // chat: snapshot.data!.docs[index].data(),
                              chat: snapshot.data![index],
                            );
                          },
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.black45,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // FutureBuilder<ChatUser>(
                              //   future: FirestoreUserController().getUserByPath(
                              //     path: snapshot.data!.docs[index].data().chatUserRefPath,
                              //   ),
                              //   builder: (context, snapshot) {
                              //     if (snapshot.connectionState ==
                              //         ConnectionState.waiting) {
                              //       return Text("----");
                              //     } else if (snapshot.hasData) {
                              //       return Text(
                              //         // "User Name",
                              //         snapshot.data!.name,
                              //         style: GoogleFonts.acme(
                              //             fontWeight: FontWeight.w500,
                              //             fontSize: 14.sp),
                              //       );
                              //     } else {
                              //       return Text("----");
                              //     }
                              //   },
                              // ),
                              Text(
                                // snapshot.data!.docs[index].data().chatUser!.name,
                                snapshot.data![index].chatUser!.name,
                                style: GoogleFonts.acme(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.sp),
                              ),
                              SizedBox(
                                width: 5.h,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Hello, How are you? Hello, How are you?  How are you?",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.acme(
                                          fontWeight: FontWeight.w100,
                                          color: Colors.grey.shade500),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Text(
                                    "3:33 pm",
                                    style: GoogleFonts.acme(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.grey.shade500),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Spacer(),
                        // Text("3:33 pm",style: GoogleFonts.acme(fontSize: 12.sp,fontWeight: FontWeight.w300),)
                      ],
                    ),
                  ),
                );
              },
              itemCount: snapshot.data!.length,
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.warning,
                  size: 80,
                  color: Colors.black45,
                ),
                Text('NO CHATS'),
                Container()
              ],
            );
          }
        });
  }
}
