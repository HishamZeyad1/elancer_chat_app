import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elancer_chat_app/controllers/fb_auth_controller.dart';
import 'package:elancer_chat_app/models/message.dart';
import 'package:elancer_chat_app/models/process_response.dart';

class FireStoreMessageController {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> sendMessage({required Message message}) async {
    return await _firebaseFirestore
        .collection('Messages')
        .add(message.toMap())
        .then((value) async {
      // await value.update({'id': value.id});
      return true;
    }).onError((error, stackTrace) => false);
  }

  Future<bool> deleteMessageForEveryOne({required String messageId}) async {
    return await _firebaseFirestore
        .collection('Messages')
        .doc(messageId)
        .update({'deleted_for_everyone': true})
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }

  Future<bool> deleteForMe({required List<String> array, required String messageId}) async {
    array.add(FbAuthController().user.uid);
    return await _firebaseFirestore
        .collection('Messages')
        .doc(messageId)
        .update({
          'deleted_for': array
        })
        .then((value) => true)
        .onError((error, stackTrace) => false);
  }

  Stream<QuerySnapshot<Message>> readMessages({required String chatId}) async* {
    print(FbAuthController().user.uid);
    yield* _firebaseFirestore
        .collection('Messages')
        .where('chat_id', isEqualTo: chatId)
        // .where('deleted_for', arrayContains: FbAuthController().user.uid)
        // .where('deleted_for', whereIn: <String>['asOKgfsRg6Q9cGFqmUehsVqiRpx1'])
        // .where('deleted_for', whereNotIn: <String>[FbAuthController().user.uid].toList())
        .orderBy('sent_at', descending: false)
        .withConverter<Message>(
            fromFirestore: (snapshot, options) =>
                Message.fromMap(snapshot.data()!),
            toFirestore: (Message message, options) => message.toMap())
        .snapshots();
  }
}
