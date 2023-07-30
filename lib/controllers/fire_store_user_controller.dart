import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elancer_chat_app/controllers/fb_auth_controller.dart';
import 'package:elancer_chat_app/models/chat_user.dart';

// import 'package:elancer_chat_app/models/chat_user.dart';
import 'package:elancer_chat_app/models/process_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class FirestoreUserController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> saveUser({required User user}) async {
    // User user=FirebaseAuth.instance.currentUser! ;
    return await _firebaseFirestore
        .collection('Users')
        .add({
      'id': user.uid,
      'name': user.displayName,
      'email': user.email,
    })
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }

  Stream<QuerySnapshot<ChatUser>> readUsers() async* {
    yield* _firebaseFirestore
        .collection('Users')
        .where('id', isNotEqualTo: FbAuthController().user.uid)
        .withConverter<ChatUser>(
            fromFirestore: (snapshot, options) =>
                ChatUser.fromMap(snapshot.data()!),
            toFirestore: (ChatUser value, SetOptions? options) => value.toMap())
        .snapshots();
  }

Future<ChatUser> getUserByPath({required String path}) async {
    print("getUserByPath");
    print("path:$path");
      DocumentSnapshot<Map<String, dynamic>> documentReference=await _firebaseFirestore.doc(path).get();
      print(documentReference.data());
    DocumentSnapshot<ChatUser> chatUserDocument = await _firebaseFirestore
          .doc(path)
          .withConverter<ChatUser>(
          fromFirestore: (snapshot, options) =>
              ChatUser.fromMap(snapshot.data()!),
          toFirestore: (ChatUser chatUser, options) => chatUser.toMap())
          .get();
       return chatUserDocument.data()!;
}
  Future<ChatUser> getUserById({required String id}) async {
    QuerySnapshot<ChatUser> chatUserDocument = await _firebaseFirestore
        .collection("Users").where("id",isEqualTo: id).withConverter<ChatUser>(
        fromFirestore: (snapshot, options) =>
            ChatUser.fromMap(snapshot.data()!),
        toFirestore: (ChatUser chatUser, options) => chatUser.toMap())
        .get();
    return chatUserDocument.docs[0].data();
  }

Future<bool> blockUser({required String blockUserId}) async {
  QueryDocumentSnapshot<ChatUser> queryDocumentSnapshot =
      await getMyAccount();
  ChatUser chatUser = queryDocumentSnapshot.data();
  chatUser.blockedUsers.add(blockUserId);
  return await queryDocumentSnapshot.reference
      .update({'blocked_users': chatUser.blockedUsers})
      .then((value) => true)
      .catchError((error) => false);
}

Future<QueryDocumentSnapshot<ChatUser>> getMyAccount() async {
  QuerySnapshot<ChatUser> querySnapshot = await _firebaseFirestore
      .collection('Users')
      .where('id', isEqualTo: FbAuthController().user.uid)
      .limit(1)
      .withConverter<ChatUser>(
          fromFirestore: (snapshot, options) =>
              ChatUser.fromMap(snapshot.data()!),
          toFirestore: (ChatUser chatUser, options) => chatUser.toMap())
      .get();

  return querySnapshot.docs.first;
}
}
