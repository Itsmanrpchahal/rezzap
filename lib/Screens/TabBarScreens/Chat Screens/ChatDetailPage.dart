import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/ChatMsg.dart';
import 'package:rezzap/Repository/ChatRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
typedef checkUser = bool Function(bool);
// ignore: must_be_immutable
class ChatDetailPage extends StatefulWidget {
  String name = "";
  checkUser callback;
  String supporterId = "";
  ChatDetailPage(this.name, this.supporterId, this.callback);
  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  TextEditingController msgController = new TextEditingController();
  List<ChatMsg> chatInboxList = [];
  ScrollController _scrollController = new ScrollController();
  var profilePic = "";

  @override
  void initState() {
    super.initState();

    msgController = TextEditingController();
    getInboxChat(widget.supporterId);
  }

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    profilePic = Constant.imageUrl + prefs.getString(KeyConstants.profilePic);
  }

  void getInboxChat(String id) {
    EasyLoading.show();
    ChatRepo().getChatInboxList(id).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            getUserData();
            chatInboxList = value;
          })
        });
  }

  void sendMessage(String message) {
    EasyLoading.show();
    ChatRepo().sendMessage(message, widget.supporterId).then((value) => {
          msgController.text = "",
          _scrollController.animateTo(
            0.0,
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 100),
          ),
          FocusScope.of(context).requestFocus(FocusNode()),
          getInboxChat(widget.supporterId)
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text(
          widget.name,
          style: TextStyle(color: Colors.black),
        ),
        elevation: 2,
        leading: IconButton(
            icon: (Platform.isIOS)
                ? Icon(Icons.arrow_back_ios)
                : Icon(Icons.arrow_back),
            onPressed: () {
              widget.callback(true);
              Navigator.of(context).pop();
            }),
      ),
      body: Container(
        color: Colors.grey[200],
        child: Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: chatInboxList.length,
              shrinkWrap: true,
              reverse: true,
              controller: _scrollController,
              padding: EdgeInsets.only(top: 10, bottom: 70),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                    alignment: (chatInboxList[index].messageType == "reciever"
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Column(
                      crossAxisAlignment:
                          !(chatInboxList[index].messageType == "reciever")
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color:
                                (chatInboxList[index].messageType == "reciever"
                                    ? Colors.white
                                    : Color(0xff3B546F)),
                          ),
                          padding: EdgeInsets.all(16),
                          child: Text(
                            chatInboxList[index].message,
                            style: GoogleFonts.lato(
                                fontSize: 16,
                                color: (chatInboxList[index].messageType ==
                                        "reciever")
                                    ? Colors.black
                                    : Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                  color: Colors.transparent,
                  child: Container(
                    margin: EdgeInsets.only(left: 10, bottom: 2, right: 10),
                    width: double.infinity,
                    child: Card(
                      color: Colors.grey[250],
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(35))),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 2,
                          ),
                          CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            backgroundImage: NetworkImage(profilePic),
                            radius: 20,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: 100.0,
                                ),
                                child: TextField(
                                  controller: msgController,
                                  maxLines: null,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      hintText: "Write message...",
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                      border: InputBorder.none),
                                )),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 5),
                            child: FloatingActionButton(
                              onPressed: () {
                                if (msgController.text != "") {
                                  sendMessage(msgController.text);
                                }
                              },
                              child: Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 18,
                              ),
                              backgroundColor: Color(0xff3B546F),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
