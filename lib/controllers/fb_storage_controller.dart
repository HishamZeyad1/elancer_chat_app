import 'dart:async';
import 'dart:io';

import 'package:elancer_chat_app/models/message.dart';
import 'package:firebase_storage/firebase_storage.dart';

typedef UploadCallback = void Function({required String url});

class FbStorageController {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  void upload(
      {required Message message,
      required File file,
      required UploadCallback uploadCallback}) {
    //'chats/{CHAT_ID}/{TYPE}/{CONTENT_NAME}
    UploadTask uploadTask = _firebaseStorage
        .ref(
            'chats/${message.chatId}/${message.messageType.name}/message_${DateTime.now().millisecond}')
        .putFile(file);
     uploadTask.snapshotEvents.listen((TaskSnapshot event) async {
       if(event.state==TaskState.success){
         String url = await event.ref.getDownloadURL();
         uploadCallback(url: url);
       }

    });
  }
}
