import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rezzap/ClassWidgets/PopUps/tokenPopUp.dart';
import 'package:rezzap/Common+Store/Colors.dart';
import 'package:rezzap/Common+Store/Contants.dart';
import 'package:rezzap/Models/CategoryModel.dart';
import 'package:rezzap/Repository/CategoryRepo.dart';
import 'package:rezzap/Repository/UserRepo.dart';
import 'package:rezzap/Screens/TabBarScreens/HomeTabBar.dart';
import 'package:rezzap/Widgets+Common/CommonWidget.dart';
import 'package:braintree_payment/braintree_payment.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: camel_case_types
typedef checkSpin = bool Function(bool);

// ignore: must_be_immutable
class CategoryDialogBox extends StatefulWidget {
  checkSpin callback;
  CategoryDialogBox(this.callback);
  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CategoryDialogBox> {
  TextEditingController titleController;
  String subscription = "";
  List<Category> categoryList = [];
  List _selectedIndexs = [];
  List<String> categoryIds = [];
  List<String> defaultIds = [];
  List<String> defaultIdsSelected = [];
  List<TextEditingController> _controllers = [];

  proceedPayNow() async {
    BraintreePayment braintreePayment = new BraintreePayment();
    var data = await braintreePayment.showDropIn(
        nonce: Constant.braintreeNonce, amount: "5.0", enableGooglePay: false);
    print("responsce $data");
    if (Platform.isAndroid) {
      makePayment(data["paymentNonce"].toString());
    } else {
      makePayment(data.toString());
    }
  }

  void getSubscriptionInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      subscription = prefs.getString(KeyConstants.subscriptions) ?? '';
    });
  }

  void makePayment(String nonce) {
    if (nonce.length < 10) {
      EasyLoading.showError("Payment error");
    } else {
      EasyLoading.show();
      UserRepo().sendPaymentNonce(nonce).then((value) => {
            EasyLoading.showInfo("Payment done successfully"),
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeTabBar(0)),
            )
          });
    }
  }

  @override
  void initState() {
    super.initState();
    getSubscriptionInfo();
    titleController = TextEditingController();
    showCategoryList();
  }

  void showCategoryList() {
    EasyLoading.show();
    CategoryRepo().getCategoryData().then((value) => {
          EasyLoading.dismiss(),
          setState(() {
            categoryList = value;
            for (var index = 0; index < categoryList.length; index++)
              if (categoryList[index].isDefault == 1) {
                defaultIds.add(categoryList[index].id.toString());
              }
          })
        });
  }

  void addCategoryList(String title) {
    EasyLoading.show(status: "Adding new Category...");
    CategoryRepo().addCategoryData(title).then((value) =>
        {titleController.text = "", EasyLoading.dismiss(), showCategoryList()});
  }

  void updateCategoryList(String title, String id) {
    EasyLoading.show(status: "Updating Category...");
    CategoryRepo()
        .editCategoryData(title, id)
        .then((value) => {showCategoryList()});
  }

  void addAllCategoryList(String ids) {
    EasyLoading.show();
    CategoryRepo().storesCategoryData(ids).then((value) =>
        {EasyLoading.dismiss(), widget.callback(true), Navigator.pop(context)});
  }

  void deleteCategoryList(String id) {
    EasyLoading.show(status: "deleting Category...");
    CategoryRepo().deleteCategoryData(id).then((value) => {showCategoryList()});
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ValidConstants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 20, left: 10, right: 10),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white.withOpacity(0.95),
              borderRadius: BorderRadius.circular(ValidConstants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, offset: Offset(0, 2), blurRadius: 5),
              ]),
          child: SingleChildScrollView(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text("ADD CATEGORY", style: GoogleFonts.lato(fontSize: 18)),
              Container(
                height: 1,
                color: AppColors.greyColor,
                margin: EdgeInsets.only(top: 10),
              ),
              SizedBox(
                height: 30,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: categoryList.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  final _isSelected = _selectedIndexs.contains(index);
                  _controllers.add(new TextEditingController());
                  _controllers[index].text = categoryList[index].title;
                  var select = _isSelected ? 0 : 1;
                  return Container(
                      margin: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      if (_isSelected) {
                                        _selectedIndexs.remove(index);
                                        if (categoryList[index].isDefault ==
                                            1) {
                                          defaultIds.add(categoryList[index]
                                              .id
                                              .toString());
                                        }
                                        categoryIds.removeWhere((item) =>
                                            item ==
                                            categoryList[index].id.toString());
                                      } else {
                                        _selectedIndexs.add(index);
                                        if (categoryList[index].isDefault ==
                                            1) {
                                          defaultIds.remove(categoryList[index]
                                              .id
                                              .toString());
                                        } else {
                                          categoryIds.add(categoryList[index]
                                              .id
                                              .toString());
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                      margin: EdgeInsets.only(left: 10),
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          border: Border.all(width: 1.0),
                                          color:
                                              (categoryList[index].isDefault ==
                                                      select)
                                                  ? AppColors.greenColor
                                                  : Colors.white))),
                              SizedBox(
                                width: 5,
                              ),
                              Flexible(
                                  child: TextFormField(
                                readOnly: (categoryList[index].createdBy == "1")
                                    ? true
                                    : false,
                                controller: _controllers[index],
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: categoryList[index].title,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              ))
                            ],
                          )),
                          (categoryList[index].createdBy == "1")
                              ? Container()
                              : Row(
                                  children: [
                                    IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () {
                                          if (_controllers[index]
                                              .text
                                              .isEmpty) {
                                            EasyLoading.showError(
                                                "Please fill title field");
                                          } else {
                                            updateCategoryList(
                                                _controllers[index].text,
                                                categoryList[index]
                                                    .id
                                                    .toString());
                                          }
                                        }),
                                    IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          categoryIds.removeWhere((item) =>
                                              item ==
                                              categoryList[index]
                                                  .id
                                                  .toString());
                                          defaultIds.removeWhere((item) =>
                                              item ==
                                              categoryList[index]
                                                  .id
                                                  .toString());
                                          deleteCategoryList(categoryList[index]
                                              .id
                                              .toString());
                                        }),
                                  ],
                                )
                        ],
                      ));
                },
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 40,
                      color: Colors.grey[200],
                      margin: EdgeInsets.only(left: 10, right: 10),
                      width: MediaQuery.of(context).size.width / 2,
                      child: TextFormField(
                        controller: titleController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                      )),
                  InkWell(
                      onTap: () {
                        if (titleController.text.isEmpty) {
                          EasyLoading.showError("Please fill title field");
                        } else {
                          addCategoryList(titleController.text);
                        }
                      },
                      child: Container(
                        color: Colors.black,
                        height: 30,
                        width: 30,
                        child: Center(
                          child: Text('+',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              buttonMenu("Done", () {
                var newIdList = categoryIds + defaultIds;
                if (newIdList.length == 0) {
                  EasyLoading.showError("Please slected atleat one Category");
                } else {
                  var ids = newIdList.join(',');
                  addAllCategoryList(ids);
                }
              }, context, AppColors.greenColor, 100),
              SizedBox(
                height: 10,
              ),
              (subscription != "subscribed")
                  ? Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: Column(
                        children: [
                          Center(
                              child: Text(
                                  "If you would like to add more categories you can do so by purchasing an unlimited categories.",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500))),
                          InkWell(
                              onTap: () {
                                proceedPayNow();
                              },
                              child: Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 40,
                                  width: 150,
                                  child: Image.asset(
                                    'assets/images/paypal.png',
                                  ))),
                          Container(
                            width: double.infinity,
                            child: Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                    icon: Icon(Icons.settings),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return TokenPopUp(false);
                                          });
                                    })),
                          )
                        ],
                      ),
                    )
                  : Text("Unlimited Custom Category Unlocked",
                      style: GoogleFonts.lato(fontSize: 14)),
              SizedBox(
                height: 10,
              ),
            ],
          )),
        ),
      ],
    );
  }
}
