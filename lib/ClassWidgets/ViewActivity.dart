import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rezzap/Common+Store/Colors.dart';

// ignore: must_be_immutable
class ViewActivity extends StatefulWidget {
  String url;
  ViewActivity(this.url);
  @override
  _ViewState createState() => _ViewState();
}

class _ViewState extends State<ViewActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white.withOpacity(0.85),
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0.85),
          leading: IconButton(
            icon: Icon(Icons.cancel_rounded),
            color: AppColors.primaryColor,
            iconSize: 30,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(20),
          child: PhotoView(
            imageProvider: NetworkImage(widget.url),
            backgroundDecoration: BoxDecoration(color: Colors.transparent),
          ),
        ));
  }
}
