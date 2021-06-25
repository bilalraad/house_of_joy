import 'dart:io';

import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bot_toast/bot_toast.dart';

import '../../models/post.dart';
import '../../models/user.dart';
import '../../services/data_base.dart';
import '../../functions/validations.dart';
import '../../functions/show_overlay.dart';
import '../../services/post_services.dart';
import '../Costume_widgets/view_images.dart';
import '../Costume_widgets/loading_dialog.dart';
import '../Costume_widgets/select_category.dart';

class PublishAPsostTab extends StatefulWidget {
  final UserModel currentUser; //optional
  final Post oldPost; //optional

  const PublishAPsostTab({Key key, this.oldPost, this.currentUser});
  @override
  _PublishAPsostTabState createState() => _PublishAPsostTabState();
}

class _PublishAPsostTabState extends State<PublishAPsostTab> {
  final _key = GlobalKey<FormState>();
  var _controllerForDescription = TextEditingController();
  List<String> imagesUrl = [];
  List<Asset> images = [];
  String _selectedCategory = '';
  // bool _autoValidate = false;
  bool _loading = false;

  File imageFile;

  @override
  void dispose() {
    _controllerForDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.oldPost != null) {
      imagesUrl = widget.oldPost.imagesUrl;
      _controllerForDescription =
          TextEditingController(text: widget.oldPost.description);
      _selectedCategory = widget.oldPost.category;
    }
    super.initState();
  }

  void getImageList() async {
    setState(() {
      images = [];
    });

    images = await MultiImagePicker.pickImages(
          maxImages: 1,
          enableCamera: true,
        ).catchError((err) {}) ??
        [];
    setState(() {
      //DO NOT delete it because its nessesary
      //to updated the viewed images in the widget
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.currentUser ?? Provider.of<UserModel>(context);
    return Scaffold(
      body: ModalProgress(
        costumeIndicator: const LoadingDialog(),
        inAsyncCall: _loading,
        opacity: 0,
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        TextButton(
                            style: TextButton.styleFrom(
                                primary: const Color(0xffE10586)),
                            child: const Text(
                              'الغاء',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ae_Sindibad'),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/');
                            }),
                        const Expanded(child: SizedBox(width: 5)),
                        const Text(
                          'اضافة مشروع',
                          style: TextStyle(
                            fontFamily: 'ae_Sindibad',
                            fontSize: 18,
                            color: Color(0xffE10586),
                          ),
                        ),
                        const Expanded(child: SizedBox(width: 5)),
                        TextButton(
                          style: TextButton.styleFrom(
                              primary: const Color(0xffE10586)),
                          child: const Text(
                            'تم',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ae_Sindibad'),
                          ),
                          //TOFO: show loading
                          onPressed: () => onPressedDone(user),
                        ),
                      ],
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Form(
                          key: _key,
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            maxLines: 3,
                            textDirection: TextDirection.rtl,
                            controller: _controllerForDescription,
                            decoration: const InputDecoration(
                              hintText: "وصف المشروع ...",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffE10586),
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xffE10586),
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'الرجاء ادخال وصف للمشروع';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.93,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/photo.jpg'),
                              fit: BoxFit.cover),
                        ),
                        child: widget.oldPost != null
                            ? ViewImages(imagesUrl: widget.oldPost.imagesUrl)
                            : images.isEmpty
                                ? null
                                : ViewImages(assetImages: images),
                      ),
                      onTap: imagesUrl.isNotEmpty ? null : getImageList,
                    ),
                    const SizedBox(height: 10),
                    SelectCatigory(
                      initialValue: _selectedCategory,
                      onSelectedCategory: (selectedCategory) {
                        _selectedCategory = selectedCategory;
                      },
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onPressedDone(UserModel user) async {
    FocusScope.of(context).unfocus();

    if (_selectedCategory.isEmpty) {
      showFlushSnackBar(context, 'رجاءا قم باختيار القسم الخاص بمشروعك');
      return;
    }

    if (images.isEmpty && imagesUrl.isEmpty) {
      showFlushSnackBar(context, 'رجاءا اختيار صور للمنتج الذي تعرضة');
      return;
    }

    if (_key.currentState.validate()) {
      setState(() => _loading = true);
      await Future.delayed(const Duration(seconds: 3));
      showOverlay(
          context: context, text: 'سوف يتم ابلاغك عند اكتمال رفع المنشور');
      Navigator.of(context).pushReplacementNamed('/');

      for (var imageFile in images) {
        await DatabaseService(user.uid)
            .postImageToFireBase(imageFile)
            .then((downloadUrl) {
          // Get the download URL
          imagesUrl.add(downloadUrl);
        });
      }
      var newPost = Post(
        userId: user.uid,
        postId: widget.oldPost?.postId ?? const Uuid().v4(),
        imagesUrl: imagesUrl,
        comments: widget.oldPost?.comments ?? [],
        description: _controllerForDescription.text,
        likes: widget.oldPost?.likes ?? [],
        category: _selectedCategory,
      );
      var err = await PostServices(newPost.postId).updatePostData(newPost);

      BotToast.showNotification(
        title: (_) => Text(
          err == null ? 'تم نشر المنشور الخاص بك' : err,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        align: Alignment.topCenter,
      );
    }
  }
}
