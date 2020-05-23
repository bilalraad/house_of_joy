import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:house_of_joy/ui/aboutCodeForIraq.dart';
import 'package:house_of_joy/ui/aboutTheApplication.dart';
import 'package:house_of_joy/ui/editProfile.dart';
import 'package:house_of_joy/ui/logout.dart';
import 'package:house_of_joy/ui/staff.dart';


class Comments extends StatefulWidget {


  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  List <dynamic>  getinfo ;
  TextEditingController _controllercomment ;
bool enable=false;
  @override
  void initState() {
    super.initState();
    getinfo =[{"name":"منى محمد",'comment':"حلوووو"},
      {"name":"ندى علي",'comment':"كلش حلو"},
      {"name":"شهد قاسم",'comment':"عاشت ايدج"},
      {"name":"شهد قاسم",'comment':"عاشت ايدج"},
      {"name":"شهد قاسم",'comment':"عاشت ايدج"},
      {"name":"شهد قاسم",'comment':"عاشت ايدج"},
      {"name":"شهد قاسم",'comment':"عاشت ايدج"},
      {"name":"رنا وليد",'comment':"جميل "}];
    _controllercomment = TextEditingController();
  }
  Future<void> _showDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: AlertDialog(

              content: SingleChildScrollView(
                child:  Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListBody(
                    children: <Widget>[
                      GestureDetector(
                        child: Text('تعديل الملف الشخصي'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text('تسجيل الخروج'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Logout()));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text('حول التطبيق'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutTheApp()));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text('حول المبادرة'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutCodeForIraq()));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text('فريق العمل'),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Staff()));
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),

              ),
            ),
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffFAFBFD),
        body: Container(

          child: Transform.translate(offset: Offset(0,24),
            child: Stack(
              children: <Widget>[

                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                            'images/backgroundImage.jpg',
                          ),
                          fit: BoxFit.cover)),
                  child: Container(
                    color: Color.fromRGBO(250, 251, 253, 75),

                    alignment: Alignment.topLeft,

                  ),
                ),
                Transform.translate(offset: Offset(0,120),
                  child:Container(
                    height: MediaQuery.of(context).size.height*0.7,
                    child:  ListView.builder(
                          itemCount: getinfo.length,

                          itemBuilder: (context,position){

                            return  container(getinfo,position);

                          },
                     dragStartBehavior: DragStartBehavior.down,
                    ),

                  ),
                ),



                Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Expanded(
                      child: SizedBox(
                        width: 3,
                      ),
                    ),
                    Text(
                      'التعليقات',
                      style: TextStyle(
                          color: Color(0xffE10586),
                          fontSize: 26,
                          fontFamily: 'ae_Sindibad'),
                    ),
                    Expanded(
                      child: SizedBox(
                        width: 3,
                      ),
                    ),
                    IconButton(icon: Icon(Icons.home),
                        iconSize: 30,
                        onPressed: (){
                          _showDialog(context);

                        }),
                  ],
                ),
                Transform.translate(offset: Offset(0,-23),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    color: Color(0xffFFAADC),
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 3,),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: AssetImage("images/personalPhoto.jpg")),
                          ),
                        ),
                        SizedBox(width: 3,),
                        Expanded(
                          child:  Container(


                            height: 35,
                            padding: EdgeInsets.only(
                                top: 13, left: 25, right: 16, bottom:0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(color: Colors.black12, blurRadius: 5),
                                ]),
                            child: TextField(
                              textDirection: TextDirection.rtl,
                              controller: _controllercomment,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'أضف تعليق',
                                hintStyle: TextStyle(
                                    fontFamily: 'Cambo', color: Color(0xffA2A2A2)),
                              ),
                              onChanged: (input){
                                if(input.length==1){
                                  setState(() {
                                    enable=true;
                                  }
                                  );
                                }
                                if(input.length==0){
                                  setState(() {
                                    enable=false;
                                  }
                                  );
                                }

                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 3,),
                        Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                          ),
                          child: Transform.translate(
                            offset: Offset(-5,-5),
                            child: IconButton(icon: Icon(Icons.arrow_upward),
                                color:  Color(0xffFFAADC),
                                enableFeedback: true,
                                onPressed: (){
                              if(enable)
                             setState(() {
                               getinfo.add({'name':'ali','comment':'${_controllercomment.text}'});
                               _controllercomment.text="";
                             });
                            }),
                          )
                        ),
                        SizedBox(width: 3,),
                      ],
                    ),
                  ),
                ),)
              ],
            ),),

        ));
  }

  Widget container(List<dynamic> info,int index) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      width: MediaQuery.of(context).size.width / 1.1,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  width: 10,
                ),
              ),
              Text(
                '${info[index]["name"]}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'ae_Sindibad'),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'images/personalPhoto.jpg',
                        ),
                        fit: BoxFit.cover),
                    shape: BoxShape.circle),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width / 1.2,
            child: Text(
              '${info[index]["comment"]}',
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  color: Colors.black, fontSize: 14, ),
            ),
          ),
          SizedBox(
            height: 10,
          ),

        ],
      ),

    );
  }

}
