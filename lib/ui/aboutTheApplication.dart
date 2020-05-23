
import 'package:flutter/material.dart';


class AboutTheApp extends StatefulWidget{
  @override
  _AboutTheAppState createState() {
    return _AboutTheAppState();
  }



}
class _AboutTheAppState extends State<AboutTheApp>{
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
                                  'حول التطبيق',
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
                      Text('عمل تطبيق خاص للمشاريع الصغيرة المنزلية بكل انواعها للنساء يتكون التطبيق من اقسام مثلا قسم خاص للأكلات والحلويات وقسم خاص للهاندمد وقسم خاص للخياطة وغيرها.',
                        style: TextStyle(fontSize: 18),),
                      Text('يمكن لأي ربة بيت او بنت متخرجة ولا تمتلك عمل وتمتلك مشروعها الخاص وتحتاج الى ترويج وعرض مشروعها يمكن رفع المشروع على هذا التطبيق وعند الدخول الى التطبيق يستطيع المتصفح مشاهدة الأقسام واختيار القسم الذي يحتاج الطلب منه يضغط على القسم ويتصفح وعند الطلب يتم المراسله والطلب عن طريق رقم الموبايل أو الواتساب أو الفايبر وكذلك أعطاء رأيه وترك تعليق على الذي طلبه مسبقا ليسهل للبقية معرفة اراء الزائرين.',
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