import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elancer_chat_app/controllers/fire_store_chat_controller.dart';
import 'package:elancer_chat_app/controllers/fire_store_user_controller.dart';
import 'package:elancer_chat_app/models/chat_user.dart';

class Chat {
  late String id;
  late String peer1Uid;
  late String peer2Uid;
  late String createdAt;

  // late String chatUserRefPath;
  //  late DocumentReference<Map<String, dynamic>> peer1Ref;
  //  late DocumentReference<Map<String, dynamic>> peer2Ref;

  ChatUser? chatUser;

  Chat();

  Chat.fromMap(Map<String, dynamic> documentMap) {
    id = documentMap['id'];
    peer1Uid = documentMap['peer1_uid'];
    peer2Uid = documentMap['peer2_uid'];
    createdAt = documentMap['created_at'];
    // DocumentReference<Map<String, dynamic>> documentReference = documentMap['user_ref'];
    // chatUserRefPath=documentReference.path;

    // DocumentReference<ChatUser> user =
    //     documentMap['user_ref'].withConverter<ChatUser>(
    //   fromFirestore: (DocumentSnapshot<Map<String, dynamic>> snapshot,
    //       SnapshotOptions? options) {
    //     chatUser = ChatUser.fromMap(snapshot.data()!);
    //     print("chatUser ${chatUser}");
    //     return chatUser!;
    //   },
    //   toFirestore: (ChatUser value, SetOptions? options) => value.toMap(),
    // );

    // FirestoreUserController().getUserByPath(path: chatUserRefPath).then((value) => chatUser=value);
    // if(documentMap.containsKey('user_ref'))
    //   {
    //     DocumentReference<Map<String, dynamic>> documentReference = documentMap['user_ref'];
    //     chatUserRefPath = documentReference.path;
    //   }

    // print("peer1_ref:${documentMap.containsKey('peer1_ref')}");
    // print("peer2_ref:${documentMap.containsKey('peer2_ref')}");

    // if(documentMap.containsKey('peer1_ref')&&documentMap.containsKey('peer2_ref'))
    // {
    //   DocumentReference<Map<String, dynamic>> documentReference1 = documentMap['peer1_ref'];
    //   DocumentReference<Map<String, dynamic>> documentReference2 = documentMap['peer2_ref'];
    //   peer1Ref = documentReference1;
    //   peer2Ref = documentReference2;
    //   print("peer1_ref:${documentReference1.path}");
    //   print("peer2_ref:${documentReference2.path}");
    // }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['peer1_uid'] = peer1Uid;
    map['peer2_uid'] = peer2Uid;
    // map['peer1_ref']=peer1Ref;
    // map['peer2_ref']=peer2Ref;
    map['created_at'] = DateTime.now().toString();
    return map;
  }
}
