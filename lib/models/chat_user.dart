class ChatUser {
  late String id;
  late String name;
  late String email;
  // late bool call;
  late List<String> blockedUsers = [];

  ChatUser();

  ChatUser.fromMap(Map<String, dynamic> documentMap) {
    id = documentMap['id'];
    name = documentMap['name'];
    email = documentMap['email'];
    // call = documentMap['call'];

    if(documentMap.containsKey('blocked_users')){
      List blockedUsers = documentMap['blocked_users'];
      for (String blockedUser in blockedUsers) {
        this.blockedUsers.add(blockedUser);
      }
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    // map['call'] = call;
    return map;
  }
}
