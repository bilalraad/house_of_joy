
import 'package:flutter/material.dart';


class AboutCodeForIraq extends StatefulWidget{
  @override
  _AboutCodeForIraqState createState() {
    return _AboutCodeForIraqState();
  }



}
class _AboutCodeForIraqState extends State<AboutCodeForIraq>{
  @override

  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Color(0xffFAFBFD),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'images/backgroundImage.jpg',
                            ),
                            fit: BoxFit.fitWidth)),
                    child:  Container(
                      color: Color.fromRGBO(250, 251, 253, 75),
                      child: Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ),
                          SizedBox(
                            height: 75,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 30),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Text(
                                'حول المبادرة',
                                style: TextStyle(
                                    color: Color(0xFFCA39E3),
                                    fontSize: 24,
                                    fontFamily: 'ae_Sindibad'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),

                  ),
                ],
              ),

              Container(
                width: MediaQuery.of(context).size.width/1.4,
                height: 220,
                decoration: BoxDecoration(
                    image: DecorationImage(image:AssetImage('images/codeForIraq.jpg'),fit: BoxFit.cover)
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  width:MediaQuery.of(context).size.width/1.1,
                  child:Column(
                    children: <Widget>[
                      Text('وهي مبادرة انسانية غير ربحية تهدف الى خدمة المجتمع عن طريق البرمجة (Programming). '
                          'تعتبر "Code for Iraq" مبادرة تعليمية حقيقية ترعى المهتمين بتعلم تصميم وبرمجة تطبيقات الهاتف الجوال ومواقع الانترنت وبرامج الحاسوب والشبكات والاتصالات ونظم تشغيل الحاسوب '
                          'بأستخدام التقنيات مفتوحة المصدر Open source  , كما توفر لهم جميع الدروس التعليمية اللازمة وبشكل مجاني تماما .',
                        style: TextStyle(fontSize: 18),),

                      SizedBox(height: 30,)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}