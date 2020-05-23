import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_of_joy/ui/alerts.dart';
import 'package:house_of_joy/ui/profileUser.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class PublishAPsost extends StatefulWidget {
  final int id;

  PublishAPsost(this.id);

  @override
  _PublishAPsostState createState() => _PublishAPsostState(id);
}

class _PublishAPsostState extends State<PublishAPsost> {
  int id;
  _PublishAPsostState(this.id);

  File imageFile;
  List<Color> colorButton=new List(13) ;
  int selectedNumber;
  TextEditingController _controllerForDescription = TextEditingController();
  _openGellery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = picture;
    });
    Navigator.of(context).pop();
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
                child:  ListBody(
                    children: <Widget>[
                      GestureDetector(
                        child: Text('المعرض'),
                        onTap: () {
                          _openGellery(context);
                        },
                      ),
                      SizedBox(
                        height: 25,
                      ),
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
        });
  }

  _decideImageView() {
    if (imageFile == null)
      return AssetImage('images/photo.jpg');
    else
      return FileImage(imageFile);
  }

void setColor(int index)
{
  for(int i=0 ; i<colorButton.length;i++)
  {
    if(index==i)
      colorButton[i]=Color(0xffFD85CB);
      else
    colorButton[i]=Colors.white;
  }
}


  @override
  void initState() {
    super.initState();
    setColor(13);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffFAFBFD),
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      FlatButton(
                        child: Text(
                          'Cansel',
                          style: TextStyle(fontFamily: 'Cambo', fontSize: 18),
                        ),
                        onPressed: onPressedCansel,
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 5,
                        ),
                      ),
                      Text(
                        'اضافة مشروع',
                        style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xffE10586),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 5,
                        ),
                      ),
                      FlatButton(
                        child: Text(
                          'Done',
                          style: TextStyle(fontFamily: 'Cambo', fontSize: 18),
                        ),
                        onPressed: onPressedDone,
                      ),
                    ],
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        maxLines: 3,
                        textDirection: TextDirection.rtl,
                        controller: _controllerForDescription,
                        decoration: InputDecoration(
                          hintText: "أكتب هنا ...",
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffE10586))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffE10586))),
                        ),

                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    child: Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width * 0.93,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: _decideImageView(), fit: BoxFit.cover)),
                    ),
                    onTap: () {
                      _showDialog(context);
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buttonContainer(),
                  SizedBox(
                    height: 60,
                  ),

                ],
              ),



            ],
          ),
          Transform.translate(offset: Offset(0,-20),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(

                width: MediaQuery.of(context).size.width / 1.5,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xffFCFCFC),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 5),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.home),
                      color: Color(0xffC5C3E3),
                      iconSize: 30,
                      onPressed: (){
                        Navigator.pop(context);
                      },

                    ),
                    IconButton(
                      icon: Icon(Icons.person_pin),
                      color: Color(0xffC5C3E3),
                      iconSize: 30,
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileUser(null,true)));
                      },

                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      color: Color(0xffFD85CB),
                      iconSize: 30,
                      onPressed: (){

                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications),
                      color: Color(0xffC5C3E3),
                      iconSize: 30,
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Alerts()));
                      },
                    ),
                  ],
                ),
              ),
            ),),
        ],
      ),
    );
  }

 Widget _buttonContainer(){
   return Container(
     color: Color(0xffFAFBFD),
     width: MediaQuery.of(context).size.width *0.93,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: <Widget>[
            Align(alignment: Alignment.topRight,
            child: Text('أختر قسم واحد',
              style: TextStyle(
                  fontFamily: 'ae_Sindibad',
                  fontSize: 18,
                  color: Color(0xff460053)
              ),
            )
            ),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.20 ,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: RaisedButton(

                    color: colorButton[0],


                    onPressed: () {
                      setState(() {
                        setColor(0);
                        selectedNumber=0;
                      });
                    },
                    child: Text(
                      'الكتب',
                      style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xff460053)),
                    ),

                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                Expanded(child: SizedBox(width: 5,),),
                Container(
                  width: MediaQuery.of(context).size.width*0.35 ,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    color: colorButton[1],


                    onPressed: () {
                      setState(() {
                        setColor(1);
                        selectedNumber=1;
                      });
                    },
                    child: Text(
                      'الأكل الشرقي',
                      style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xff460053)),
                    ),

                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                Expanded(child: SizedBox(width: 5,),),
                Container(
                  width: MediaQuery.of(context).size.width*0.35 ,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    color: colorButton[2],


                    onPressed: () {
                      setState(() {
                        setColor(2);
                        selectedNumber=2;
                      });
                    },
                    child: Text(
                      'الأكل المغربي',
                      style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xff460053)),
                    ),

                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.40 ,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    color: colorButton[3],


                    onPressed: () {
                      setState(() {
                        setColor(3);
                        selectedNumber=3;
                      });
                    },
                    child: Text(
                      'مواد التجميل',
                      style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xff460053)),
                    ),

                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                 SizedBox(width: 5,),
                Container(
                  width: MediaQuery.of(context).size.width*0.40 ,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    color: colorButton[4],


                    onPressed: () {
                      setState(() {
                        setColor(4);
                        selectedNumber=4;
                      });
                    },
                    child: Text(
                      'العناية بالبشرة',
                      style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xff460053)),
                    ),

                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                Expanded(child: SizedBox(width: 5,),),

              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.30 ,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    color: colorButton[5],


                    onPressed: () {
                      setState(() {
                        setColor(5);
                        selectedNumber=5;
                      });
                    },
                    child: Text(
                      'الحلويات',
                      style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xff460053)),
                    ),

                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                Expanded(child: SizedBox(width: 5,),),
                Container(
                  width: MediaQuery.of(context).size.width*0.30 ,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    color: colorButton[6],


                    onPressed: () {
                      setState(() {
                        setColor(6);
                        selectedNumber=6;
                      });
                    },
                    child: Text(
                      'الخياطة',
                      style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xff460053)),
                    ),

                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                Expanded(child: SizedBox(width: 5,),),
                Container(
                  width: MediaQuery.of(context).size.width*0.30 ,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    color: colorButton[7],


                    onPressed: () {
                      setState(() {
                        setColor(7);
                        selectedNumber=7;
                      });
                    },
                    child: Text(
                      'التطريز',
                      style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xff460053)),
                    ),

                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.43 ,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    color: colorButton[8],


                    onPressed: () {
                      setState(() {
                        setColor(8);
                        selectedNumber=8;
                      });
                    },
                    child: Text(
                      'تجهيز مناسبات',
                      style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xff460053)),
                    ),

                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Container(
                  width: MediaQuery.of(context).size.width*0.42 ,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    color: colorButton[9],


                    onPressed: () {
                      setState(() {
                        setColor(9);
                        selectedNumber=9;
                      });
                    },
                    child: Text(
                      'الأكسسوارات',
                      style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xff460053)),
                    ),

                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                Expanded(child: SizedBox(width: 5,),),

              ],
            ),
            SizedBox(height: 8,),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width*0.29 ,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    color: colorButton[10],


                    onPressed: () {
                      setState(() {
                        setColor(10);
                        selectedNumber=10;
                      });
                    },
                    child: Text(
                      'الكوشات',
                      style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xff460053)),
                    ),

                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                Expanded(child: SizedBox(width: 5,),),
                Container(
                  width: MediaQuery.of(context).size.width*0.29 ,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    color: colorButton[11],


                    onPressed: () {
                      setState(() {
                        setColor(11);
                        selectedNumber=11;
                      });
                    },
                    child: Text(
                      'التصوير',
                      style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xff460053)),
                    ),

                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                Expanded(child: SizedBox(width: 5,),),
                Container(
                  width: MediaQuery.of(context).size.width*0.32 ,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                  ),
                  child: RaisedButton(
                    color: colorButton[12],


                    onPressed: () {
                      setState(() {
                        setColor(12);
                        selectedNumber=12;
                      });
                    },
                    child: Text(
                      'طباعة الصور',
                      style: TextStyle(
                          fontFamily: 'ae_Sindibad',
                          fontSize: 18,
                          color: Color(0xff460053)),
                    ),

                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),

          ],
        ),
      ),
    );
  }

  void onPressedDone() {
    if(selectedNumber==null)
      {
        showDialogError();
      }else
    {
      Navigator.pop(context);
      print(selectedNumber);
    }

  }

  void onPressedCansel() {
    Navigator.pop(context);
  }
  void showDialogError(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              title: Text('أختر قسم مشروعك'),
              content: SingleChildScrollView(
                child:  ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text('حسنا'),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),

                  ],
                ),

              ),
            ),
          );
        });
  }
}
