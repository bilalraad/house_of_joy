import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:house_of_joy/functions/creat_route.dart';
import 'package:house_of_joy/functions/show_overlay.dart';
import 'package:house_of_joy/services/data_base.dart';
import 'package:house_of_joy/ui/Auth/changePassword.dart';
import 'package:image_picker/image_picker.dart';

import 'package:house_of_joy/models/user.dart';

class EditProfile extends StatefulWidget {
  final User user;
  const EditProfile({
    Key key,
    @required this.user,
  }) : assert(user != null, 'user data should be provided');

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  var fullNameController = TextEditingController();
  var userNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneNoController = TextEditingController();
  File imageFile;
  final picker = ImagePicker();
  NetworkImage profilepic;
  bool dataLoaded = false;
  bool loading = false;

  @override
  void didChangeDependencies() {
    if (!dataLoaded) {
      if (widget.user.imageUrl.isNotEmpty)
        profilepic = NetworkImage(widget.user.imageUrl);
      fullNameController = TextEditingController(text: widget.user.fullName);
      userNameController = TextEditingController(text: widget.user.userName);
      emailController = TextEditingController(text: widget.user.email);
      phoneNoController = TextEditingController(
          text: widget.user.phoneNo.replaceAll('+964', '0'));
    }
    dataLoaded = true;
    super.didChangeDependencies();
  }

  _openGellery(BuildContext context) async {
    var pickedFile = await picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      if (pickedFile.path.isNotEmpty) {
        imageFile = File(pickedFile.path);
        profilepic = null;
      }
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var pickedFile = await picker.getImage(source: ImageSource.camera);
    this.setState(() {
      if (pickedFile.path.isNotEmpty) {
        imageFile = File(pickedFile.path);
        profilepic = null;
      }
    });
    Navigator.of(context).pop();
  }

  _decideImageView() {
    if (imageFile == null)
      return AssetImage('images/personal.png');
    else
      return FileImage(imageFile);
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text('اختر صورة'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text('المعرض'),
                    onTap: () {
                      _openGellery(context);
                    },
                  ),
                  SizedBox(height: 25),
                  GestureDetector(
                    child: Text('الكاميرا'),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var inputDecoration = InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffFFAADC),
        ),
      ),
      hintStyle: TextStyle(
        fontFamily: 'ae_Sindibad',
        color: Color(0xffA2A2A2),
      ),
    );
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/backgroundImage.png',
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(250, 251, 253, 75),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: SafeArea(
                          child: Row(
                            children: <Widget>[
                              FlatButton(
                                onPressed: _onPressedDone,
                                child: Text(
                                  'تعديل',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'ae_Sindibad'),
                                ),
                              ),
                              Expanded(child: SizedBox(width: 5)),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'الغاء',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'ae_Sindibad'),
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: 75),
                    Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'تعديل الملف الشخصي',
                          style: TextStyle(
                              color: Color(0xFFCA39E3),
                              fontSize: 24,
                              fontFamily: 'ae_Sindibad'),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
                SizedBox(height: 15),
                Stack(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          color: Color(0xffFFAADC),
                          image: DecorationImage(
                              image: profilepic ?? _decideImageView(),
                              fit: BoxFit.cover),
                          shape: BoxShape.circle),
                    ),
                    Transform.translate(
                      offset: Offset(-72, 0),
                      child: GestureDetector(
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/camera.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                        onTap: () {
                          _showDialog(context);
                        },
                      ),
                    )
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: fullNameController,
                          decoration: inputDecoration.copyWith(
                              hintText: 'الاسم االكامل'),
                          readOnly: loading,
                          validator: (fullName) {
                            if (fullName == null || fullName.isEmpty) {
                              return "الرجاء ادخال الاسم";
                            } else if (fullName.length < 8) {
                              return "رجاءا ادخل الاسم الكامل";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: userNameController,
                          decoration: inputDecoration.copyWith(
                              hintText: 'اسم المستخدم'),
                          readOnly: loading,
                          validator: (userName) {
                            var userNrexEx = RegExp(
                                r"^(?=.{4,20}$)(?:[a-zA-Z\d]+(?:(?:\.|-|_)[a-zA-Z\d])*)+$");
                            if (userName.isNotEmpty) if (userName.length <= 4) {
                              return "اسم المستخدم قصير جدا";
                            } else if (!userNrexEx.hasMatch(userName)) {
                              return "يجب ان  لا يحتوي على نقط او فراغات";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration.copyWith(
                              hintText: 'البريد الالكتروني'),
                          enabled: false,
                          readOnly: true,
                        ),
                        Text(
                          'لا تستطيع تغيير البريد الالكتروني في الوقت الحالي',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextFormField(
                          controller: phoneNoController,
                          keyboardType: TextInputType.phone,
                          decoration:
                              inputDecoration.copyWith(hintText: 'رقم الهاتف'),
                          readOnly: loading,
                          validator: (phoneNo) {
                            var phoneRegEx = RegExp(r"07[3-9][0-9]{8}");
                            if (phoneNo.isNotEmpty &&
                                    !phoneRegEx.hasMatch(phoneNo) ||
                                phoneNo.length > 11) {
                              return "الرقم غير صحيح";
                            }
                            return null;
                          },
                        ),
                        widget.user.phoneNo.isEmpty
                            ? Text(
                                'يجب ان يكون الرقم مربوط بالواتساب الخاص بك ليتمكن المشترون من مراسلتك',
                                style: TextStyle(color: Colors.grey),
                              )
                            : Container(height: 10),
                        GestureDetector(
                          child: Stack(
                            children: <Widget>[
                              TextField(
                                decoration: inputDecoration.copyWith(
                                  hintText: 'تغيير كلمة السر',
                                ),
                                readOnly: true,
                              ),
                              Transform.translate(
                                offset: Offset(0, 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(Icons.arrow_forward_ios),
                                ),
                              ),
                            ],
                          ),
                          onTap: () async {
                            setState(() {
                              loading = true;
                            });

                            Navigator.push(
                              context,
                              createRoute(ChangePassword()),
                            );
                            setState(() {
                              loading = false;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        loading ? CircularProgressIndicator() : Container(),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onPressedDone() async {
    setState(() {
      loading = true;
    });
    bool isUserNameExcist = false;
    var newUsername = userNameController.text;
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      if (widget.user.userName != newUsername)
        isUserNameExcist =
            await DatabaseService('').checkUserNameExcist(newUsername);

      if (!isUserNameExcist) {
        final number = phoneNoController.text.isNotEmpty
            ? '+964${phoneNoController.text.substring(1)}'
            : '';
        String newImageUrl = profilepic == null
            ? await DatabaseService(widget.user.uid).uploadPic(imageFile)
            : widget.user.imageUrl;
        await DatabaseService(widget.user.uid).updateUserData(
          widget.user.copyWith(
            fullName: fullNameController.text,
            imageUrl: newImageUrl ?? "",
            phoneNo: number,
            userName: userNameController.text,
          ),
        );
        showOverlay(context: context, text: 'تم تعديل المعلومات');
        Navigator.pop(context);
      } else {
        showOverlay(
          context: context,
          text: 'اسم المستخدم تم اختيارة سابقا',
        );
        // showFlushSnackBar(context, 'اسم المستخدم تم اختيارة سابقا');
      }
    }
    setState(() {
      loading = false;
    });
  }
}
