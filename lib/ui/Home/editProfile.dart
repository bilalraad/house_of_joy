import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user.dart';
import '../../services/data_base.dart';
import '../../functions/show_overlay.dart';

class EditProfile extends StatefulWidget {
  final UserModel user;
  const EditProfile({
    @required this.user,
  }) : assert(user != null, 'user data should be provided');

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  var _fullNameController = TextEditingController();
  var _userNameController = TextEditingController();
  var _emailController = TextEditingController();
  var _phoneNoController = TextEditingController();
  File imageFile;
  final _picker = ImagePicker();
  NetworkImage profilepic;
  bool dataLoaded = false;
  bool loading = false;

  @override
  void didChangeDependencies() {
    if (!dataLoaded) {
      if (widget.user.imageUrl.isNotEmpty) {
        profilepic = NetworkImage(widget.user.imageUrl);
      }
      _fullNameController = TextEditingController(text: widget.user.fullName);
      _userNameController = TextEditingController(text: widget.user.userName);
      _emailController = TextEditingController(text: widget.user.email);
      _phoneNoController = TextEditingController(
          text: widget.user.phoneNo.replaceAll('+964', '0'));
    }
    dataLoaded = true;
    super.didChangeDependencies();
  }

  _openGellery(BuildContext context) async {
    var pickedFile = await _picker.getImage(source: ImageSource.gallery);
    this.setState(() {
      if (pickedFile.path.isNotEmpty) {
        imageFile = File(pickedFile.path);
        profilepic = null;
      }
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var pickedFile = await _picker.getImage(source: ImageSource.camera);
    this.setState(() {
      if (pickedFile.path.isNotEmpty) {
        imageFile = File(pickedFile.path);
        profilepic = null;
      }
    });
    Navigator.of(context).pop();
  }

  _decideImageView() {
    if (imageFile == null) {
      return const AssetImage('images/personal.png');
    } else {
      return FileImage(imageFile);
    }
  }

  Future<void> _showDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('اختر صورة'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: const Text('المعرض'),
                    onTap: () {
                      _openGellery(context);
                    },
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    child: const Text('الكاميرا'),
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
    var inputDecoration = const InputDecoration(
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
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/backgroundImage.png',
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          title: TextButton(
            style: TextButton.styleFrom(primary: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'الغاء',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'ae_Sindibad'),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: _onPressedDone,
              style: TextButton.styleFrom(primary: Colors.black),
              child: const Text(
                'تعديل',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ae_Sindibad'),
              ),
            ),
          ],
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 150),
                    const Padding(
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
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: () => _showDialog(context),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            color: const Color(0xffFFAADC),
                            image: DecorationImage(
                                image: profilepic ?? _decideImageView(),
                                fit: BoxFit.cover),
                            shape: BoxShape.circle),
                      ),
                      Transform.translate(
                        offset: const Offset(0, 0),
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('images/camera.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _fullNameController,
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
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _userNameController,
                          decoration: inputDecoration.copyWith(
                              hintText: 'اسم المستخدم'),
                          readOnly: loading,
                          validator: (userName) {
                            var userNrexEx = RegExp(
                                r"^(?=.{4,20}$)(?:[a-zA-Z\d]+(?:(?:\.|-|_)[a-zA-Z\d])*)+$");
                            if (userName.isNotEmpty) {
                              if (userName.length <= 4) {
                                return "اسم المستخدم قصير جدا";
                              } else {
                                if (!userNrexEx.hasMatch(userName)) {
                                  return "يجب ان  لا يحتوي على نقط او فراغات";
                                }
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration.copyWith(
                              hintText: 'البريد الالكتروني'),
                          enabled: false,
                          readOnly: true,
                        ),
                        const Text(
                          'لا تستطيع تغيير البريد الالكتروني في الوقت الحالي',
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextFormField(
                          controller: _phoneNoController,
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
                            ? const Text(
                                'يجب ان يكون الرقم مربوط بالواتساب الخاص بك ليتمكن المشترون من مراسلتك',
                                style: TextStyle(color: Colors.grey),
                              )
                            : Container(height: 10),
                        const SizedBox(height: 20),
                        loading
                            ? const CircularProgressIndicator()
                            : Container(),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
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
    var isUserNameExcist = false;
    var newUsername = _userNameController.text;
    FocusScope.of(context).unfocus();
    if (_formKey.currentState.validate()) {
      if (widget.user.userName != newUsername) {
        isUserNameExcist =
            await DatabaseService('').checkUserNameExcist(newUsername);
      }

      if (!isUserNameExcist) {
        final number = _phoneNoController.text.isNotEmpty
            ? '+964${_phoneNoController.text.substring(1)}'
            : '';
        var newImageUrl = profilepic == null
            ? await DatabaseService(widget.user.uid).uploadPic(imageFile)
            : widget.user.imageUrl;
        await DatabaseService(widget.user.uid).updateUserData(
          widget.user.copyWith(
            fullName: _fullNameController.text,
            imageUrl: newImageUrl ?? "",
            phoneNo: number,
            userName: _userNameController.text,
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
