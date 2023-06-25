import 'package:elancer_chat_app/controllers/fb_auth_controller.dart';
enum MessageType{text,image,voice}
class Message {
  // late String id;
  late String message;
  late String senderUid;
  late String chatId;
  late String sentAt;
  bool isSender=false;
  late MessageType messageType;

  late bool deletedForEveryOne = false;
  late List<String> deletedFor = <String>[];

  Message();
  // Message({required this.message,this.isSender=false});
  Message.fromMap(Map<String, dynamic> rowMap) {
    // id=rowMap["id"];
    message=rowMap["message"];
   messageType = getType(rowMap['message_type']);

   senderUid=rowMap["sender_uid"];
   chatId=rowMap["chat_id"];
   sentAt=rowMap["sent_at"];
   isSender=FbAuthController().user.uid==senderUid;

   deletedForEveryOne = rowMap['deleted_for_everyone'];

   List deletedForArray = rowMap['deleted_for'];
   for(String deletedUser in deletedForArray) {
     deletedFor.add(deletedUser);
   }
   message = deletedForEveryOne ? 'تم حذف الرسالة' : rowMap['message'];
  }
  bool get isDeletedForMe => deletedFor.contains(FbAuthController().user.uid);

  Map<String,dynamic> toMap(){
    Map<String, dynamic> rowMap=<String, dynamic>{};
    // id=rowMap["id"];
    rowMap["message"]=message;
    rowMap["message_type"]=messageType.name;

    rowMap["sender_uid"]=FbAuthController().user.uid;
    rowMap["chat_id"]=chatId;
    rowMap["sent_at"]=DateTime.now().toString();

    rowMap['deleted_for_everyone'] = false;
    rowMap['deleted_for'] = [];
    return rowMap;
  }
  MessageType getType(String messageType){
    if(messageType==MessageType.text.name){
      return MessageType.text;
    }else if(messageType==MessageType.image.name){
      return MessageType.image;
    }
    else{
      return MessageType.voice;

    }
  }
}
