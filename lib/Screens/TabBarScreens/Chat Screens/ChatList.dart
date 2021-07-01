import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/SideMenu.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/ChatUser.dart';
import 'package:rezzap/Repository/ChatRepo.dart';
import 'package:rezzap/Screens/TabBarScreens/Chat%20Screens/ChatDetailPage.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool isSearchOn = false;
  TextEditingController searchController;
  List<ChatUser> chatUsersList = [];

  @override
  void initState() {
    super.initState();
    getAllUserChat();
    searchController = TextEditingController();
  }

  void getAllUserChat() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      EasyLoading.show();
      ChatRepo().getChatUserList().then((value) => {
            EasyLoading.dismiss(),
            setState(() {
              chatUsersList = value;
            })
          });
    } else {
      EasyLoading.showError("No internet connection");
    }
  }

  void searchAllUserChat(String keyword) {
    EasyLoading.show();
    ChatRepo().searchChatUserList(keyword).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            chatUsersList = value;
          })
        });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 2,
          backgroundColor: Colors.white,
          title: (isSearchOn)
              ? Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Row(children: [
                    Expanded(
                        child: Container(
                            height: 20,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: TextFormField(
                              controller: searchController,
                              style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                  hintText: 'search',
                                  focusedBorder: new UnderlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black))),
                            ))),
                    InkWell(
                        onTap: () {
                          setState(() {
                            searchAllUserChat(searchController.text);
                          });
                        },
                        child: Container(
                          color: AppColors.greenColor,
                          height: 30,
                          width: 60,
                          child: Center(
                            child: Text('search',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ))
                  ]))
              : Text(
                  "CHATS",
                  style: TextStyle(color: Colors.black),
                ),
          actions: [
            (!isSearchOn)
                ? IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        isSearchOn = !isSearchOn;
                      });
                    })
                : IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        isSearchOn = !isSearchOn;
                        getAllUserChat();
                      });
                    })
          ]),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(top: 1, left: 16, right: 16),
        child: (chatUsersList.length != 0)
            ? ListView.builder(
                itemCount: chatUsersList.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 16),
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: AppColors.primaryColor,
                                    backgroundImage: NetworkImage(
                                        (chatUsersList[index].profilePhoto ==
                                                null)
                                            ? Constant.placeHolderImage
                                            : Constant.imageUrl +
                                                chatUsersList[index]
                                                    .profilePhoto),
                                    maxRadius: 30,
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ChatDetailPage(
                                                    chatUsersList[index].name,
                                                    chatUsersList[index].id,
                                                    (value) {
                                                  if (value == true) {
                                                    getAllUserChat();
                                                  }
                                                  return true;
                                                })),
                                      );
                                    },
                                    child: Container(
                                      color: Colors.transparent,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            chatUsersList[index].name,
                                            style: GoogleFonts.lato(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            (chatUsersList[index].message ==
                                                    null)
                                                ? "No Message Found"
                                                : chatUsersList[index].message,
                                            style: GoogleFonts.lato(
                                              
                                                fontSize: (chatUsersList[index]
                                                            .seen ==
                                                        "0")
                                                    ? 14
                                                    : 12,
                                                color: (chatUsersList[index]
                                                            .seen ==
                                                        "0")
                                                    ? AppColors.greenColor
                                                    : Colors.grey),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 0.6,
                        width: double.infinity,
                        color: Colors.grey[200],
                      )
                    ],
                  );
                },
              )
            : Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2 - 100),
                child: Text(
                  "No Chat Found",
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Colors.black),
                )),
      )),
    );
  }
}
