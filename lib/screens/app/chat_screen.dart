import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elancer_chat_app/controllers/fb_auth_controller.dart';
import 'package:elancer_chat_app/controllers/fb_storage_controller.dart';
import 'package:elancer_chat_app/controllers/fire_store_message_controller.dart';
import 'package:elancer_chat_app/models/chat.dart';
import 'package:elancer_chat_app/models/chat_user.dart';
import 'package:elancer_chat_app/models/message.dart';
import 'package:elancer_chat_app/widgets/message_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/fb_notifications.dart';

class ChatScreen extends StatefulWidget {
  final Chat chat;

  ChatScreen({required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with FbNotifications{
  late TextEditingController _messageTextController;
  final ScrollController _scrollController = ScrollController();

  XFile? _pickedImageFile;
  late ImagePicker _imagePicker;
  late Message _newMessage;
  Stream<QuerySnapshot<Message>>? _messageQSnapshot;
  StreamSubscription<QuerySnapshot<Message>>? _streamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messageTextController = TextEditingController();

    _messageQSnapshot=FireStoreMessageController().readMessages(chatId: widget.chat.id);
    _streamSubscription=FireStoreMessageController().readMessages(chatId: widget.chat.id).listen((event) {
        // if(event.docs.length!=0){
          print("${event.docs.length!=0}:len:${event.docs.length}");
          scrollToLastMessage();
        // }
      // _messageQSnapshot=event;
    });
    _imagePicker = ImagePicker();
  }


  // Method to scroll to the last message
  void scrollToLastMessage() {
    print("Scrolling");
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    // WidgetsBinding.instance!.removeObserver(this);
    _streamSubscription!.cancel();
    _scrollController.dispose();
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          // elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios)),
          title: Text(
            "CHAT",
            style: GoogleFonts.acme(
              color: Colors.black,
            ),
          ),
          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                highlightColor: Colors.white,
              ), // <--------- here
              child: PopupMenuButton<int>(
                onSelected: (value) {},
                initialValue: 1,
                // color: Colors.green,
                elevation: 4,
                offset: Offset(0, 25),
                icon: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert,
                      size: 24,
                      color: Colors.black,
                    )),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                // padding: EdgeInsets.zero,
                // constraints: BoxConstraints(maxWidth: 100,maxHeight:60,minHeight: 0 ),
                // constraints: BoxConstraints(minHeight: 0, maxHeight: 20),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      height: 28,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.clear,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Text(
                            "Clear Message",
                            style:
                                GoogleFonts.acme(fontWeight: FontWeight.normal),
                          ),
                          
                        ],
                      ),
                      value: 1,
                      // padding: EdgeInsets.zero,

                      // height: 10,
                    ),
                    // PopupMenuItem(
                    //   child: Text("data"),
                    //   value: 2,
                    // ),
                    // PopupMenuItem(
                    //   child: Text("data"),
                    //   value: 3,
                    // ),
                  ];
                },
              ),
            ),
            IconButton(onPressed: ()async{
              await sendNotify("title", "body", "1");

            }, icon: Icon(Icons.add_call)),
          ],
        ),
        body: Column(
          children: [
            StreamBuilder<QuerySnapshot<Message>>(
                stream:_messageQSnapshot /*FireStoreMessageController()
                    .readMessages(chatId: widget.chat.id)*/,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if (snapshot.hasData &&
                      snapshot.data!.docs.isNotEmpty){
                    return Expanded(
                      child: ListView(
                        controller: _scrollController,
                        // reverse: true,
                        physics: BouncingScrollPhysics(),
                        children: [Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: snapshot.data!.docs
                              .where((element) => !element.data().isDeletedForMe)
                              .map(
                            (e) {
                              return Align(
                                alignment: e.data().isSender
                                    ? AlignmentDirectional.centerEnd
                                    : AlignmentDirectional.centerStart,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: e.data().isSender
                                        ? Colors.pink.shade200
                                        : Colors.blue.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.w, vertical: 10.h),
                                  margin: EdgeInsetsDirectional.only(
                                    bottom: 10.h,
                                    start: !e.data().isSender ? 10.w : 50.w,
                                    end: e.data().isSender ? 10.w : 50.w,
                                  ),
                                  child: MessageItem(
                                      message: e.data(),
                                      onLongPress: () async => !e.data().deletedForEveryOne?await _showMessageOptionsDialog(documentSnapshot: e):null,
                                        // {
                                        // print("dddd");
                                        // await _showMessageOptionsDialog(documentSnapshot: e);
                                      // }
                                      ),
                                ),
                              );
                            },
                          ).toList(),
                        ),]
                      ),
                    );
                  }
                  else {
                    return Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.warning,
                            size: 80,
                            color: Colors.grey,
                          ),
                          Text(
                            "No Messages",
                            style: GoogleFonts.acme(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                                fontSize: 20.sp),
                          ),
                        ],
                      ),
                    );
                  }
                }),
            Container(
              height: 50.h,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
                borderRadius: BorderRadius.circular(25.w),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.acme(
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                        fontSize: 14.sp),
                    textCapitalization: TextCapitalization.sentences,
                    minLines: 1,
                    maxLines: 3,
                    controller: _messageTextController,
                  )),
                  VerticalDivider(
                    indent: 5.h,
                    endIndent: 5.h,
                    thickness: 0.8,
                    color: Colors.blue.shade200,
                  ),
                  IconButton(
                    onPressed: () async => await _pickImage(),
                    icon: Icon(Icons.camera_alt_outlined),
                    // padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.mic),
                  ),
                  IconButton(
                    onPressed: () {
                      _performSendTextMessage();
                    },
                    icon: Icon(Icons.send),
                    constraints: BoxConstraints(),
                    // padding: EdgeInsets.zero,
                  ),
                ],
              ),
            )
          ],
        ));
  }

  Future<void> _performSendTextMessage() async {
    if (_checkData()) {
      await _sendMessage();
    }
  }

  bool _checkData() {
    if (_messageTextController.text.isNotEmpty) {
      getMessage();
      _newMessage.messageType = MessageType.text;
      _newMessage.message = _messageTextController.text;
      return true;
    }
    return false;
  }

  Future<void> _sendMessage() async {
    bool sent =
        await FireStoreMessageController().sendMessage(message: _newMessage);
    if (sent) {
      // setState(()  {
      //   // _messages.add(Message(
      //   //     message: _messageTextController.text.toString(), isSender: true));
      // });
      _clear();
      if(_scrollController.hasClients)
        Future.delayed(
          Duration(milliseconds: 100),
              () {
            _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeIn);
          },
        );
      // _scrollToBottom();

    }
  }

  void _scrollToBottom() {
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void getMessage() {
    _newMessage = Message();
    // _newMessage.message = _messageTextController.text;
    // _newMessage.messageType = _messageType;
    _newMessage.chatId = widget.chat.id;
  }

  void _clear() => _messageTextController.clear();

  Future<void> _pickImage() async {
    XFile? pickedImageFile =
        await _imagePicker.pickImage(source: ImageSource.camera);
    if (pickedImageFile != null) {
      _pickedImageFile = pickedImageFile;
      _uploadImage();
    }
  }

  // MessageType get _messageType {
  //   return _pickedImageFile != null ? MessageType.image : MessageType.text;
  // }

  Future<void> _uploadImage() async {
    getMessage();
    _newMessage.messageType = MessageType.image;
    FbStorageController().upload(
      message: _newMessage,
      file: File(_pickedImageFile!.path),
      uploadCallback: ({required url}) async {
        print(url);
        _newMessage.message = url;
        await _sendMessage();
        _pickedImageFile = null;
      },
    );
  }

  Future<void> _showMessageOptionsDialog(
      {required QueryDocumentSnapshot<Message> documentSnapshot}) async {
    print("show dialog");
    MessageOption? messageOption = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          actionsAlignment: MainAxisAlignment.start,
          actionsOverflowDirection: VerticalDirection.down,
          actionsOverflowAlignment: OverflowBarAlignment.start,
          title: Text('Message Options'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, MessageOption.deleteForMe);
              },
              child: Text('Delete For me'),
            ),
            if (documentSnapshot.data().isSender)
              TextButton(
                onPressed: () {
                  Navigator.pop(context, MessageOption.deleteForEveryone);
                },
                child: Text('Delete For everyone'),
              ),
          ],
        );
      },
    );
    if (messageOption != null) {
      if (messageOption == MessageOption.deleteForEveryone) {
        await FireStoreMessageController()
            .deleteMessageForEveryOne(messageId: documentSnapshot.id);
      }
      else {
        await FireStoreMessageController().deleteForMe(
          messageId: documentSnapshot.id, array: documentSnapshot.data().deletedFor,
        );
      }
    }
  }
}

enum MessageOption { deleteForEveryone, deleteForMe }
