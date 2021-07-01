import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Repository/ActivityRepo.dart';
import 'package:rezzap/Repository/CategoryRepo.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';
import 'package:video_player/video_player.dart';

// ignore: camel_case_types
typedef checkUser = bool Function(bool);

// ignore: must_be_immutable
class AddActivity extends StatefulWidget {
  checkUser callback;
  AddActivity(this.callback);
  @override
  _AddActivityState createState() => _AddActivityState();
}

class _AddActivityState extends State<AddActivity> {
  bool isImage = false;
  bool isText = true;
  bool isVedio = false;
  bool isAudio = false;
  bool isWord = false;
  bool isPdf = false;
  bool isLink = false;
  bool isYouTubeVideo = false;
  var selectedType = "";
  var mediaType = "0";
  var categoryId = "0";
  List<String> categoryList = [];
  List<String> categoryIds = [];
  static var selectedDate = DateTime.now();
  var customDate =
      "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}";

  TextEditingController titleController;
  TextEditingController categoryController;
  TextEditingController eventDateController;
  TextEditingController descController;
  VideoPlayerController _videoPlayerController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PickedFile _image;
  File _video;
  File _audio;
  File word;
  File pdf;
  String audioFileName = "";
  String wordFileName = "";
  String pdfFileName = "";

  void initState() {
    super.initState();
    titleController = TextEditingController();
    categoryController = TextEditingController();
    eventDateController = TextEditingController();
    descController = TextEditingController();
    showCategoryList();
  }

  void showCategoryList() {
    EasyLoading.show();
    CategoryRepo().showCategoryData().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
           for (var index = 0; index < value.length; index++) {
              categoryList.add(value[index].title);
            }
          })
        });
  }

  void validateAndSave() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      if (isText) {
        mediaType = "4";
        addActivityText(titleController.text, categoryController.text,
            descController.text, mediaType, eventDateController.text);
      } else if (isImage) {
        mediaType = "1";
        if (_image != null) {
          addActivityFiles(titleController.text, categoryController.text,
              _image, mediaType, eventDateController.text);
        } else {
          EasyLoading.showError("Please select image");
        }
      } else if (isVedio && !isYouTubeVideo) {
        mediaType = "2";
        if (_video != null) {
          addActivityFiles(titleController.text, categoryController.text,
              PickedFile(_video.path), mediaType, eventDateController.text);
        } else {
          EasyLoading.showError("Please select video");
        }
      } else if (isVedio && isYouTubeVideo) {
        mediaType = "6";
        addActivityText(titleController.text, categoryController.text,
            descController.text, mediaType, eventDateController.text);
      } else if (isAudio) {
        mediaType = "3";
        if (_audio != null) {
          if (_audio.path.contains(".mp3")) {
            addActivityFiles(titleController.text, categoryController.text,
                PickedFile(_audio.path), mediaType, eventDateController.text);
          } else {
            EasyLoading.showError("Selected file is not .mp3");
          }
        } else {
          EasyLoading.showError("Please select mp3 file from device");
        }
      } else if (isPdf) {
        mediaType = "5";
        if (pdf != null) {
          if (pdf.path.contains(".pdf")) {
            addActivityFiles(titleController.text, categoryController.text,
                PickedFile(pdf.path), mediaType, eventDateController.text);
          } else {
            EasyLoading.showError("Selected file is not .pdf");
          }
        } else {
          EasyLoading.showError("Please select pdf file from device");
        }
      } else if (isWord) {
        mediaType = "7";
        if (word != null) {
          if (pdf.path.contains(".doc")) {
            addActivityFiles(titleController.text, categoryController.text,
                PickedFile(word.path), mediaType, eventDateController.text);
          } else {
            EasyLoading.showError("Selected file is not .doc");
          }
        } else {
          EasyLoading.showError("Please select doc file from device");
        }
      }
    }
  }

  void addActivityFiles(String title, String category, PickedFile content,
      String mediaType, String eventDate) {
    EasyLoading.show();
    ActivityRepo()
        .addActivity(
            title, categoryController.text, content, mediaType, eventDate)
        .then((value) => {
              EasyLoading.showInfo("Activity added successfully..."),
              widget.callback(true),
              Navigator.of(context).pop()
            });
  }

  void addActivityText(String title, String category, String content,
      String mediaType, String eventDate) {
    EasyLoading.show();
    ActivityRepo()
        .addActivityText(
            title, categoryController.text, content, mediaType, eventDate)
        .then((value) => {
              EasyLoading.showInfo("Activity added successfully..."),
              widget.callback(true),
              Navigator.of(context).pop()
            });
  }

  _imgFromCamera() async {
    PickedFile _selectedImageCamera = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = _selectedImageCamera;
    });
  }

  _imgFromGallery() async {
    PickedFile _selectedImageGallary = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = _selectedImageGallary;
    });
  }

  Future _pickAudio() async {
    FilePickerResult file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['.mp3'],
    );
    if (file != null) {
      setState(() {
        _audio = File(file.files.single.path);
        audioFileName = file.files.single.name;
      });
    } else {}
  }

  Future _pickWordFile() async {
    FilePickerResult file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['.doc'],
    );
    if (file != null) {
      setState(() {
        word = File(file.files.single.path);
        wordFileName = file.files.single.name;
      });
    } else {}
  }

  Future _pickPdfFile() async {
    FilePickerResult file = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['.pdf'],
    );
    if (file != null) {
      setState(() {
        pdf = File(file.files.single.path);
        pdfFileName = file.files.single.name;
      });
    } else {}
  }

  _pickVideo() async {
    PickedFile pickedFile =
        await ImagePicker().getVideo(source: ImageSource.gallery);

    _video = File(pickedFile.path);

    _videoPlayerController = VideoPlayerController.file(_video)
      ..initialize().then((_) {
        setState(() {});
        _videoPlayerController.play();
      });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar("ADD ACTIVITY", true),
      body: SingleChildScrollView(
          child: Container(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: TextFormField(
                      controller: titleController,
                      decoration: new InputDecoration(
                        labelText: "Title",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Title cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    )),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: TextFormField(
                      readOnly: true,
                      controller: categoryController,
                      decoration: new InputDecoration(
                        suffixIcon: PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                            size: 30,
                          ),
                          onSelected: (String value) {
                            categoryController.text = value;
                          },
                          itemBuilder: (BuildContext context) {
                            return categoryList
                                .map<PopupMenuItem<String>>((String value) {
                              return new PopupMenuItem(
                                  child: new Text(value), value: value);
                            }).toList();
                          },
                        ),
                        labelText: "Select Category",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Category cannot be empty";
                        } else {
                          return null;
                        }
                      },
                    )),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: TextFormField(
                      readOnly: true,
                      onTap: () {
                        showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(1970, 1),
                            lastDate: DateTime(2100),
                            builder: (BuildContext context, Widget picker) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: Colors.blue,
                                    onPrimary: Colors.white,
                                    surface: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                  dialogBackgroundColor: Colors.white,
                                ),
                                child: picker,
                              );
                            }).then((selectedDate) {
                          if (selectedDate != null) {
                            customDate =
                                "${selectedDate.year.toString().padLeft(2, '0')}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString()}";

                            eventDateController.text = customDate;
                          }
                        });
                      },
                      controller: eventDateController,
                      decoration: new InputDecoration(
                        labelText: "Event Date",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Date cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.phone,
                    )),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    isImage = !isImage;
                                    isText = false;
                                    isAudio = false;
                                    isVedio = false;
                                    isLink = false;
                                    isPdf = false;
                                    isWord = false;
                                    isYouTubeVideo = false;
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: (isImage)
                                          ? AppColors.greenColor
                                          : Colors.white,
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey[400]),
                                    ))),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Image",
                              style: GoogleFonts.lato(fontSize: 18),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    isText = !isText;
                                    isImage = false;
                                    isAudio = false;
                                    isVedio = false;
                                    isLink = false;
                                    isPdf = false;
                                    isWord = false;
                                    isYouTubeVideo = false;
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: (isText)
                                          ? AppColors.greenColor
                                          : Colors.white,
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey[400]),
                                    ))),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Text",
                              style: GoogleFonts.lato(fontSize: 18),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    isAudio = !isAudio;
                                    isImage = false;
                                    isText = false;
                                    isVedio = false;
                                    isLink = false;
                                    isPdf = false;
                                    isWord = false;
                                    isYouTubeVideo = false;
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: (isAudio)
                                          ? AppColors.greenColor
                                          : Colors.white,
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey[400]),
                                    ))),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Audio",
                              style: GoogleFonts.lato(fontSize: 18),
                            )
                          ],
                        )
                      ],
                    )),
                Container(
                    margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    isVedio = !isVedio;
                                    isImage = false;
                                    isAudio = false;
                                    isText = false;
                                    isPdf = false;
                                    isWord = false;
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: (isVedio)
                                          ? AppColors.greenColor
                                          : Colors.white,
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey[400]),
                                    ))),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Video",
                              style: GoogleFonts.lato(fontSize: 18),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    isPdf = !isPdf;
                                    isVedio = false;
                                    isImage = false;
                                    isAudio = false;
                                    isText = false;
                                    isWord = false;
                                    isYouTubeVideo = false;
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: (isPdf)
                                          ? AppColors.greenColor
                                          : Colors.white,
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey[400]),
                                    ))),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "PDF",
                              style: GoogleFonts.lato(fontSize: 18),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    isWord = !isWord;
                                    isPdf = false;
                                    isVedio = false;
                                    isImage = false;
                                    isAudio = false;
                                    isText = false;
                                    isYouTubeVideo = false;
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 10),
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: (isWord)
                                          ? AppColors.greenColor
                                          : Colors.white,
                                      border: Border.all(
                                          width: 1.0, color: Colors.grey[400]),
                                    ))),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Word",
                              style: GoogleFonts.lato(fontSize: 18),
                            )
                          ],
                        ),
                      ],
                    )),
                Visibility(
                    visible: isVedio,
                    child: Container(
                      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      isVedio = true;
                                      isLink = false;
                                      isYouTubeVideo = false;
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            new BorderRadius.circular(15.0),
                                        color: (!isYouTubeVideo)
                                            ? AppColors.greenColor
                                            : Colors.white,
                                        border: Border.all(
                                            width: 1.0,
                                            color: Colors.grey[300]),
                                      ))),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Upload Video",
                                style: GoogleFonts.lato(fontSize: 18),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      isLink = !isLink;
                                      isYouTubeVideo = true;
                                      isVedio = true;
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            new BorderRadius.circular(15.0),
                                        color: (isLink)
                                            ? AppColors.greenColor
                                            : Colors.white,
                                        border: Border.all(
                                            width: 1.0,
                                            color: Colors.grey[300]),
                                      ))),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "You tube link",
                                style: GoogleFonts.lato(fontSize: 18),
                              )
                            ],
                          ),
                        ],
                      ),
                    )),
                ((isImage || isAudio || isVedio || isPdf || isWord) && !isLink)
                    ? Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.grey),
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                        margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                        child: InkWell(
                            onTap: () {
                              (isWord)
                                  ? _pickWordFile()
                                  : (isPdf)
                                      ? _pickPdfFile()
                                      : (isAudio)
                                          ? _pickAudio()
                                          : (isVedio)
                                              ? _pickVideo()
                                              : _showPicker(context);
                            },
                            child: (isWord)
                                ? Container(
                                    color: Colors.grey[200],
                                    margin: EdgeInsets.all(10),
                                    child: (word != null)
                                        ? Center(child: Text(wordFileName))
                                        : Container(
                                            color: Colors.grey[200],
                                            margin: EdgeInsets.all(10),
                                            child: Center(
                                                child: Text(
                                              "Drop your word file here",
                                              style: GoogleFonts.lato(
                                                  fontSize: 18),
                                            )),
                                          ))
                                : (isPdf)
                                    ? Container(
                                        color: Colors.grey[200],
                                        margin: EdgeInsets.all(10),
                                        child: (pdf != null)
                                            ? Center(child: Text(pdfFileName))
                                            : Container(
                                                color: Colors.grey[200],
                                                margin: EdgeInsets.all(10),
                                                child: Center(
                                                    child: Text(
                                                  "Drop your pdf file here",
                                                  style: GoogleFonts.lato(
                                                      fontSize: 18),
                                                )),
                                              ))
                                    : (isAudio)
                                        ? Container(
                                            color: Colors.grey[200],
                                            margin: EdgeInsets.all(10),
                                            child: (_audio != null)
                                                ? Center(
                                                    child: Text(audioFileName))
                                                : Container(
                                                    color: Colors.grey[200],
                                                    margin: EdgeInsets.all(10),
                                                    child: Center(
                                                        child: Text(
                                                      "Drop your audio file here",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 18),
                                                    )),
                                                  ))
                                        : (isVedio)
                                            ? (_video != null)
                                                ? AspectRatio(
                                                    aspectRatio:
                                                        _videoPlayerController
                                                            .value.aspectRatio,
                                                    child: VideoPlayer(
                                                        _videoPlayerController),
                                                  )
                                                : Container(
                                                    color: Colors.grey[200],
                                                    margin: EdgeInsets.all(10),
                                                    child: Center(
                                                        child: Text(
                                                      "Drop your video file here",
                                                      style: GoogleFonts.lato(
                                                          fontSize: 18),
                                                    )))
                                            : Container(
                                                margin: EdgeInsets.all(10),
                                                child: _image == null
                                                    ? Container(
                                                        color: Colors.grey[200],
                                                        margin:
                                                            EdgeInsets.all(10),
                                                        child: Center(
                                                            child: Text(
                                                          isVedio ||
                                                                  isAudio ||
                                                                  isPdf ||
                                                                  isWord
                                                              ? "Drop your file here"
                                                              : "Add Image",
                                                          style:
                                                              GoogleFonts.lato(
                                                                  fontSize: 18),
                                                        )),
                                                      )
                                                    : Image.file(
                                                        (File(_image.path)),
                                                      ),
                                              )),
                      )
                    : Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: new ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 200.0,
                            ),
                            child: TextFormField(
                              controller: descController,
                              maxLength: (isLink) ? null : 140,
                              maxLines: null,
                              textInputAction: TextInputAction.done,
                              decoration: new InputDecoration(
                                labelText: isLink
                                    ? "Enter your youtube link here"
                                    : "Enter your description here",
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(5.0),
                                  borderSide: new BorderSide(),
                                ),
                              ),
                              validator: (!isYouTubeVideo)
                                  ? (val) {
                                      if (val.length == 0) {
                                        return "Field cannot be empty";
                                      } else {
                                        return null;
                                      }
                                    }
                                  : (value) =>
                                      ValidConstants.isYouTubeUrl(value)
                                          ? null
                                          : "Please enter vaild url.",
                            ))),
                Container(
                  margin: EdgeInsets.only(left: 40, right: 40, top: 20),
                  child: buttonMenu("Post Activity", () {
                    validateAndSave();
                  }, context, Colors.black, double.infinity),
                )
              ],
            )),
      )),
    );
  }
}
