import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elancer_chat_app/controllers/fire_store_chat_controller.dart';
import 'package:elancer_chat_app/models/chat.dart';
import 'package:elancer_chat_app/models/chat_user.dart';
import 'package:elancer_chat_app/models/process_response.dart';
import 'package:elancer_chat_app/screens/app/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/fire_store_user_controller.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UsersScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<ChatUser>>(
        stream: FirestoreUserController().readUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              // shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 10.h,
                  childAspectRatio: 1),
              itemBuilder: (context, index) {
                print(snapshot.data!.docs[index].reference.path);
                return InkWell(
                  child: Card(
                    // color: Colors.grey.shade500,
                    margin: EdgeInsets.zero,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: Colors.cyan.shade200, width: 0.8),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CircleAvatar(
                              radius: 25.w,
                              backgroundColor: Colors.grey.shade200,
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              snapshot.data!.docs[index].data().name,
                              style: GoogleFonts.acme(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13.sp,
                                  color: Colors.black45),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        PositionedDirectional(
                          top: 0,
                          end: 0,
                          child: PopupMenuButton<int>(
                            color: Colors.white,
                            onSelected: (value) {},

                            // constraints: BoxConstraints(
                            //     maxWidth: 10, maxHeight: 10, minHeight: 10, minWidth: 10),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  child: Text("Profile"),
                                  height: 25.h,
                                  value: 1,
                                  onTap: () {},
                                ),
                                PopupMenuDivider(),
                                PopupMenuItem(
                                  child: Text("Block"),
                                  height: 25.h,
                                  value: 2,
                                  onTap: () async{
                                    await FirestoreUserController().blockUser(
                                        blockUserId:
                                        snapshot.data!.docs[index].data().id);
                                  },
                                ),
                              ];
                            },
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.black45,
                            ),
                            iconSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: ()async{
                    print("Chat with UserUid:${snapshot.data!.docs[index].data().id} and UserName:${snapshot.data!.docs[index].data().name} ");
                    await _navigateToChatScreen(snapshot, index, context);
                  },
                );
              },
              itemCount: snapshot.data!.docs.length,
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning,
                    size: 85.w,
                    color: Colors.grey,
                  ),
                  Text(
                    "No Users",
                    style: GoogleFonts.acme(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        fontSize: 26.sp),
                  )
                ],
              ),
            );
          }
        });
  }

  Future<void> _navigateToChatScreen(AsyncSnapshot<QuerySnapshot<ChatUser>> snapshot, int index, BuildContext context) async {
    print("Chat with UserUid:${snapshot.data!.docs[index].data().id} and UserName:${snapshot.data!.docs[index].data().name} ");

    ProcessResponse<Chat> processResponse=await FireStoreChatController().checkChat(peerUid: snapshot.data!.docs[index].data().id);
   print(processResponse.object!.peer1Uid);
    print(processResponse.object!.peer2Uid);
    print(processResponse.message);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            chat: processResponse.object!,
          ),
        ));
  }
}
