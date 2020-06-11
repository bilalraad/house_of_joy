import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_of_joy/functions/validations.dart';
import 'package:house_of_joy/models/post.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/services/data_base.dart';
import 'package:house_of_joy/services/post_services.dart';
import 'package:house_of_joy/ui/Costume_widgets/loading_dialog.dart';
import 'package:house_of_joy/ui/Costume_widgets/select_category.dart';
import 'package:house_of_joy/ui/Costume_widgets/view_images.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';


class PublishAPsost extends StatefulWidget {
  final Post oldPost;

  const PublishAPsost({Key key, this.oldPost}) : super(key: key);
  @override
  _PublishAPsostState createState() => _PublishAPsostState();
}

class _PublishAPsostState extends State<PublishAPsost> {
  final _key = GlobalKey<FormState>();
  var _controllerForDescription = TextEditingController();
  List<String> imagesUrl = [];
  List<Asset> images = [];
  String _selectedCategory = '';
  bool _autoValidate = false;
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

  getImageList() async {
    setState(() {
      images = [];
    });

    images = await MultiImagePicker.pickImages(
          maxImages: 5,
          enableCamera: true,
        ).catchError((err) {
          print(err);
        }) ??
        [];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context, listen: false);

    return Scaffold(
      body: ModalProgress(
        costumeIndicator: LoadingDialog(),
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
                        FlatButton(
                            child: Text(
                              'الغاء',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'ae_Sindibad'),
                            ),
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/');
                            }),
                        Expanded(child: SizedBox(width: 5)),
                        Text(
                          'اضافة مشروع',
                          style: TextStyle(
                            fontFamily: 'ae_Sindibad',
                            fontSize: 18,
                            color: Color(0xffE10586),
                          ),
                        ),
                        Expanded(child: SizedBox(width: 5)),
                        FlatButton(
                          child: Text(
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
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Form(
                          key: _key,
                          child: TextFormField(
                            autovalidate: _autoValidate,
                            maxLines: 3,
                            textDirection: TextDirection.rtl,
                            controller: _controllerForDescription,
                            decoration: InputDecoration(
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
                              if (value.isEmpty)
                                return 'الرجاء ادخال وصف للمشروع';
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      child: Container(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.93,
                        decoration: BoxDecoration(
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
                      onTap: imagesUrl.isNotEmpty
                          ? null
                          : () {
                              getImageList();
                            },
                    ),
                    SizedBox(height: 10),
                    SelectCatigory(
                      initialValue: _selectedCategory,
                      onSelectedCategory: (selectedCategory) {
                        _selectedCategory = selectedCategory;
                      },
                    ),
                    SizedBox(height: 60),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onPressedDone(User user) async {
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
      await Future.delayed(Duration(seconds: 1));
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
        postId: widget.oldPost?.postId ?? Uuid().v4(),
        imagesUrl: imagesUrl,
        comments: widget.oldPost?.comments ?? [],
        description: _controllerForDescription.text,
        likes: widget.oldPost?.likes ?? [],
        category: _selectedCategory,
      );
      var err = await PostServices(newPost.postId).updatePostData(newPost);

      BotToast.showSimpleNotification(
          title: err == null ? 'تم نشر المنشور الخاص بك' : err,
          align: Alignment.centerRight,
          hideCloseButton: true);
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }
}
