import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elancer_chat_app/controllers/fb_auth_controller.dart';
import 'package:elancer_chat_app/controllers/fire_store_user_controller.dart';
import 'package:elancer_chat_app/models/chat.dart';
import 'package:elancer_chat_app/models/chat_user.dart';
import 'package:elancer_chat_app/models/process_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FireStoreChatController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<ProcessResponse<Chat>> checkChat({required String peerUid}) async {
    //
    /*QuerySnapshot*/
    List<Chat> querySnapshot = await getChatByPeer(peerUid: peerUid);
    print("Number of Chats:${querySnapshot.length}");
    if (querySnapshot.isNotEmpty) {
      //CHAT EXISTS!!!!
      print('CHat Exist: ID: ${querySnapshot[0].id}');
      return ProcessResponse(
          message: 'Success', success: true, object: querySnapshot[0]);
    } else {
      //CREATE NEW CHAT
      print('CREATE NEW CHAT');
      Chat chat = _createNewChatModel(peerUid);
      return await createChat(chat: chat);
    }
  }

  Chat _createNewChatModel(String peerUid) {
    Chat chat = Chat();
    chat.peer1Uid = FbAuthController().user.uid;
    chat.peer2Uid = peerUid;
    // chat.peer1Ref=_firestore.doc("/Users/${FbAuthController().user.uid}");
    // chat.peer2Ref=_firestore.doc("/Users/$peerUid");
    return chat;
  }

  Future<ProcessResponse<Chat>> createChat({required Chat chat}) async {
    // print("Chat ,${chat.peer1Uid},${chat.peer2Uid}");
    return await _firestore
        .collection('Chats')
        .add(chat.toMap())
        .then((DocumentReference value) async {
      chat.id = value.id;
      await value.update({'id': value.id});
      return ProcessResponse<Chat>(
        message: 'Chat Created successfully',
        success: true,
        object: chat,
      );
    }).onError((error, stackTrace) {
      return ProcessResponse<Chat>(
        message: 'Failed to create chat',
        success: false,
      );
    });
  }

  Future<QuerySnapshot<Chat>> getChatById({required String id}) async {
    return _firestore
        .collection('Chats')
        .where('id', isEqualTo: id)
        .withConverter<Chat>(
            fromFirestore: (snapshot, options) =>
                Chat.fromMap(snapshot.data()!),
            toFirestore: (Chat chat, options) => chat.toMap())
        .get();
  }

  Future< /*QuerySnapshot<Chat>*/ List<Chat>> getChatByPeer(
      {required String peerUid}) async {
    // print('PEER UID: $peerUid');
    // print('MY UID: ${FbAuthController().user.uid}');
    CollectionReference collectionReference = _firestore.collection('Chats');
    // print("{UserId:${FbAuthController().user.uid}");
    // print("{peerUid:$peerUid");
    print("My UID: FbAuthController().user.uid:${FbAuthController().user.uid}");
    List<Chat> results = [];
    QuerySnapshot<Chat> querySnapshot1 = await collectionReference
        .where('peer1_uid', isEqualTo: FbAuthController().user.uid)
        .where('peer2_uid', isEqualTo: peerUid)
        .withConverter(
          fromFirestore: (snapshot, options) => Chat.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap(),
        )
        .get();
    querySnapshot1.docs.forEach((DocumentSnapshot<Chat> document) {
      results.add(document.data()!);
    });

    QuerySnapshot<Chat> querySnapshot2 = await collectionReference
        .where('peer1_uid', isEqualTo: peerUid)
        .where('peer2_uid', isEqualTo: FbAuthController().user.uid)
        .withConverter(
          fromFirestore: (snapshot, options) => Chat.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap(),
        )
        .get();
    querySnapshot2.docs.forEach((DocumentSnapshot<Chat> document) {
      results.add(document.data()!);
    });

    return results;

    // Query query = collectionReference
    //     .where('peer1_uid', isEqualTo: FbAuthController().user.uid)
    //     .where('peer2_uid', isEqualTo: peerUid);
    //
    // query
    //     .where('peer1_uid', isEqualTo: peerUid)
    //     .where('peer2_uid', isEqualTo: FbAuthController().user.uid);

    // return collectionReference
    //     .withConverter<Chat>(
    //         fromFirestore: (snapshot, options) =>
    //             Chat.fromMap(snapshot.data()!),
    //         toFirestore: (Chat chat, options) => chat.toMap())
    //     .get();
  }

// Fire store interception with each other that caused ignore inside with-converted with outside with-converted
  Stream<List<Chat> /*QuerySnapshot<Chat>*/ > getChats() async* {
    //SELECT * FROM chats WHERE peer1_uid = 'MY_UID' AND peer2_uid = 'MY_UID';
    //SELECT * FROM chats WHERE peer1_uid = 'MY_UID' OR peer2_uid = 'MY_UID';

    print("My uid is: ${FbAuthController().user.uid}");
    CollectionReference collectionReference = _firestore.collection('Chats');
    // Query query = collectionReference.where('peer1_uid',
    //     isEqualTo: FbAuthController().user.uid);
    // query.where('peer2_uid', isEqualTo: FbAuthController().user.uid);

    Query query = collectionReference.where('peer2_uid',
        isEqualTo: FbAuthController().user.uid);
    query.where('peer1_uid', isEqualTo: FbAuthController().user.uid);
    print(query);
    print("yes");
    print("Start Stream");
    Stream<QuerySnapshot<Chat>> chatStream = query
        .withConverter<Chat>(
            fromFirestore: (snapshot, options) {
              print("=============getchat================");

              // print(snapshot.data()!['user_ref']);
              // DocumentReference<ChatUser> user=snapshot.data()!['user_ref'] as DocumentReference<ChatUser>;
              // DocumentReference<Map<String, dynamic>> user=snapshot.data()!['user_ref'] as DocumentReference<Map<String, dynamic>>;
              // print(user.path);
              // snapshot.data()!['user_ref'].get().then((value){print("value:${value.data()}");});

              // DocumentReference<ChatUser> user=snapshot.data()!['user_ref'].withConverter<ChatUser>(
              //   fromFirestore: ( DocumentSnapshot<Map<String, dynamic>> snapshot,SnapshotOptions? options){print("value:1");return ChatUser.fromMap(snapshot.data()!);},
              //   toFirestore: (ChatUser value,SetOptions? options) {print("value:${value}");return value.toMap();});
              // print(snapshot.data());
              // DocumentReference<Map<String, dynamic>> documentReference = snapshot
              //     .data()!['user_ref'];

              // DocumentReference<Map<String, dynamic>> documentReference = snapshot
              //     .data()!['peer1_ref'];
              // print("UserRef:${documentReference.path}");

              // DocumentReference<ChatUser> chatUser=documentReference.withConverter<ChatUser>(
              //     fromFirestore: (snapshot, options) =>
              //         ChatUser.fromMap(snapshot.data()!), toFirestore: (value, options) => value.toMap(),);

              // DocumentSnapshot<ChatUser> user = await _firestore
              //     .collection("Users")
              //     .doc(userRef)
              //     .withConverter(
              //         fromFirestore: (snapshot, options) =>
              //             ChatUser.fromMap(snapshot.data()!),
              //         toFirestore: (value, options) => value.toMap(),)
              //     .get();

              // _firestore
              //     // .collection('Users')
              //     .doc(userRef.path/*'F55KyU7XOCvUNNb6GHZm'*/)
              //     .withConverter<ChatUser>(
              //   fromFirestore: (snapshot, options) =>
              //       ChatUser.fromMap(snapshot.data()!),
              //   toFirestore: (ChatUser value, options) => value.toMap(),)
              //     .get().then((value) => print("value:${value.data()}")).onError((error,
              //     stackTrace) => print(error.toString()));

              // user.get().then((value) => print(value.data()!.name));
              // print(user);

              // print("WE ARE HERE");
              //
              //     chatFunction(
              //       snapshot,
              //       (Chat chat) {
              //         print("UserName:${chat.chatUser!.name}");
              //         return chat;
              //       },
              //     );
              return Chat.fromMap(snapshot.data()!);
            },
            toFirestore: (value, options) => value.toMap())
        .snapshots();
    print("End Stream");

    Stream<List<Chat>> processedStream = processStream(chatStream);
    print("processedStream");
    yield* processedStream;

    //   .listen((event) {print(event.docs);},onDone: () {
    // getFuture(event);
    //   },)
    // ;

    // .asyncMap<List<Chat>>((event) async => await getFuture(event.docs));
  }

  Stream<List<Chat>> getChats1() async* {
    print("My uid is: ${FbAuthController().user.uid}");
    CollectionReference collectionReference = _firestore.collection('Chats');
    Stream<List<Chat>> stream1=collectionReference
        .where('peer1_uid', isEqualTo: FbAuthController().user.uid)
        .withConverter(
          fromFirestore: (snapshot, options) => Chat.fromMap(snapshot.data()!),
          toFirestore: (value, options) => value.toMap(),
        ).snapshots().asyncMap<List<Chat>>((event) async => await getFuture(event.docs));;
    Stream<List<Chat>> stream2=collectionReference
        .where('peer2_uid', isEqualTo: FbAuthController().user.uid)
        .withConverter(
      fromFirestore: (snapshot, options) => Chat.fromMap(snapshot.data()!),
      toFirestore: (value, options) => value.toMap(),
    ).snapshots().asyncMap<List<Chat>>((event) async => await getFuture(event.docs));
    yield* mergeStreams(stream1, stream2);
    // print("Start Stream");
    //
    // print("End Stream");
    //
    // Stream<List<Chat>> processedStream = processStream(chatStream);
    // print("processedStream");
    // yield* processedStream;

    //   .listen((event) {print(event.docs);},onDone: () {
    // getFuture(event);
    //   },)
    // ;

    // .asyncMap<List<Chat>>((event) async => await getFuture(event.docs));
  }
  Stream<List<Chat>> mergeStreams(
      Stream<List<Chat>> stream1, Stream<List<Chat>> stream2) {
    return stream1.asyncExpand((list1) => stream2.map((list2) => list1 + list2));
  }
  Future<List<Chat>> getFuture(List<QueryDocumentSnapshot<Chat>> data) async {
    print("Start Future");
    print("data:$data");
    print('123');
    List<Chat> chats = data.map((e) {
      print(e.data().peer1Uid);
      return e.data();
    }).toList();
    print('456');
    print(chats);

    for (Chat chat in chats) {
      print("chat.id");
      String s = getMyRefFriends(chat);
      print(s);
      // ChatUser? chatUser = await FirestoreUserController()
      //     .getUserByPath(path:data /*chat.chatUserRefPath*//*getMyRefFriends(chat)*/);
      ChatUser? chatUser = await FirestoreUserController()
          .getUserById(id: getMyRefFriends(chat));
      print("object");
      chat.chatUser = chatUser;
      print(chat);
    }
    print("End Future");

    return chats;
  }

  String getMyRefFriends(Chat chat) {
    print("getMyRefFriends");
    print(chat.peer1Uid == FbAuthController().user.uid);
    if (chat.peer1Uid == FbAuthController().user.uid) {
      print(chat.peer2Uid);
      return chat.peer2Uid;
    }
    return chat.peer1Uid;
  }

  Stream<List<Chat>> processStream(Stream<QuerySnapshot<Chat>> stream) {
    print("processStream");
    return stream.asyncExpand((snapshot) {
      print("=============getchat================");
      return Stream.fromFuture(getFuture(snapshot.docs));
    });
  }
// Future<Chat> chatFunction(DocumentSnapshot<Map<String, dynamic>> snapshot,
//     Chat Function(Chat chat) onDone) async {
//   Chat chat = Chat.fromMap(snapshot.data()!);
//
//   DocumentReference<Map<String, dynamic>> userRef =
//   snapshot.data()!['user_ref'];
//   DocumentSnapshot<ChatUser> chatUserDocument = await _firestore
//       .doc(userRef.path)
//       .withConverter<ChatUser>(
//       fromFirestore: (snapshot, options) =>
//           ChatUser.fromMap(snapshot.data()!),
//       toFirestore: (ChatUser chatUser, options) => chatUser.toMap())
//       .get();
//
//   chat.chatUser = chatUserDocument.data()!;
//   onDone(chat);
//   return chat;
// }
}
