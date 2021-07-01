import 'package:rezzap/Models/ChatMsg.dart';
import 'package:rezzap/Models/ChatUser.dart';
import 'package:rezzap/Network%20Calls/ApiBaseHelper.dart';

class ChatRepo {
  ApiBaseHelper _helper = ApiBaseHelper();
  static final getchatUserUrl = "message/supporter-list";
  static final getInboxListUrl = "message/chat-list?supporter_id=";
  static final sendMessageUrl = "message/send-message";
  static final searchChatUserUrl = "message/search-supporter?keyword=";

  //GET ALL CHAT USER
  Future<List<ChatUser>> getChatUserList() async {
    final response = await _helper.get(getchatUserUrl);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => ChatUser.fromJson(d)).toList();
  }

  //SEARCH CHAT USER
  Future<List<ChatUser>> searchChatUserList(String keyword) async {
    final response = await _helper.get(searchChatUserUrl + keyword);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => ChatUser.fromJson(d)).toList();
  }

  //GET ALL CHAT INBOX
  Future<List<ChatMsg>> getChatInboxList(String supporterId) async {
    final response = await _helper.get(getInboxListUrl + supporterId);
    var responseData = response["data"];
    var list = responseData as List;
    return list.map((d) => ChatMsg.fromJson(d)).toList();
  }

  //POST CHAT
  Future<bool> sendMessage(String message, String supporterId) async {
    final response = await _helper.post(sendMessageUrl, {
      "supporter_id": supporterId,
      "message": message,
    });
    print(response);
    return true;
  }
}
