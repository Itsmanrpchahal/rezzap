import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/CommentModel.dart';
import 'package:rezzap/Repository/ActivityRepo.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class UserComment extends StatefulWidget {
  String id = "";
  String userId = "";

  UserComment(this.id, this.userId);
  @override
  _UserCommentState createState() => _UserCommentState();
}

class _UserCommentState extends State<UserComment> {
  List<Comment> commentList = [];
  TextEditingController commentController;
  var userId = "";
  var profilePic = "";

  @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
    getCommentList(widget.id);
  }

  void getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(KeyConstants.userId) ?? '';
    var pic = prefs.getString(KeyConstants.profilePic);
    profilePic = (pic == '') ? Constant.imageUrl : Constant.imageUrl + pic;
    print(profilePic);
  }

  void getCommentList(String activityId) {
    EasyLoading.show();
    ActivityRepo().getComment(activityId).then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            getUserData();
            commentList = value;
          })
        });
  }

  void addComment(String id, String comment) {
    EasyLoading.show();
    ActivityRepo().addComment(id, comment).then(
        (value) => {commentController.text = "", getCommentList(widget.id)});
  }

  void deleteComment(String id) {
    EasyLoading.show();
    ActivityRepo()
        .deleteComment(id)
        .then((value) => {getCommentList(widget.id)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar("Comments", true),
        body: Container(
            child: Stack(
          children: [
            ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: commentList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              color: Colors.blue,
                              width: 10,
                              height: 4,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  (commentList[index].profilePhoto == null)
                                      ? Constant.placeHolderImage
                                      : Constant.imageUrl +
                                          commentList[index].profilePhoto),
                              radius: 25,
                            ),
                            Container(
                                margin: EdgeInsets.only(left: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      commentList[index].name,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 +
                                          20,
                                      child: Text(
                                        commentList[index].comment,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black45),
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        (userId == widget.userId)
                            ? Container(
                                child: IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    deleteComment(
                                        commentList[index].id.toString());
                                  },
                                ),
                              )
                            : Container()
                      ],
                    ),
                  );
                }),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                  color: Colors.white,
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
                                  controller: commentController,
                                  maxLines: null,
                                  textInputAction: TextInputAction.done,
                                  decoration: InputDecoration(
                                      hintText: "Comment...",
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
                                if (commentController.text.isEmpty) {
                                } else {
                                  addComment(widget.id, commentController.text);
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
            )
          ],
        )));
  }
}
