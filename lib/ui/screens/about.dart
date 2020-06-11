import 'package:flutter/material.dart';

class About extends StatelessWidget {
  final bool isAboutApp;

  const About({this.isAboutApp = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/backgroundImage.png',
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(250, 251, 253, 75),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                    SizedBox(height: 75),
                    Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          isAboutApp ? 'حول التطبيق' : 'حول المبادرة',
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
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: 220,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('images/codeForIraq.jpg'),
                          fit: BoxFit.cover)),
                ),
                SizedBox(height: 15),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Column(
                      children: <Widget>[
                        isAboutApp
                            ? Text(
                                'عمل تطبيق خاص للمشاريع الصغيرة المنزلية بكل انواعها للنساء '
                                'يتكون التطبيق من اقسام مثلا قسم خاص للأكلات والحلويات'
                                ' وقسم خاص للاعمال اليدوية وقسم خاص للخياطة وغيرها.'
                                '\nيمكن لأي ربة بيت او بنت متخرجة ولا تمتلك عمل وتمتلك مشروعها الخاص '
                                'وتحتاج الى ترويج وعرض مشروعها يمكن رفع المشروع على هذا التطبيق '
                                'وعند الدخول الى التطبيق يستطيع المتصفح مشاهدة الأقسام واختيار القسم الذي يحتاج '
                                'الطلب منه يضغط على القسم ويتصفح وعند الطلب يتم المراسله '
                                'والطلب عن طريق رقم الموبايل أو الواتساب أو الفايبر '
                                'وكذلك أعطاء رأيه وترك تعليق على الذي طلبه مسبقا ليسهل للبقية معرفة اراء الزائرين.',
                                style: TextStyle(fontSize: 18),
                              )
                            : Text(
                                'وهي مبادرة انسانية غير ربحية تهدف الى خدمة المجتمع عن طريق البرمجة (Programming). '
                                'تعتبر "Code for Iraq" مبادرة تعليمية حقيقية ترعى المهتمين بتعلم تصميم وبرمجة تطبيقات الهاتف الجوال ومواقع الانترنت وبرامج الحاسوب والشبكات والاتصالات ونظم تشغيل الحاسوب '
                                'بأستخدام التقنيات مفتوحة المصدر Open source  , كما توفر لهم جميع الدروس التعليمية اللازمة وبشكل مجاني تماما .',
                                style: TextStyle(fontSize: 18),
                              ),
                        SizedBox(height: 30)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Staff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/backgroundImage.png',
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(250, 251, 253, 75),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SafeArea(
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
                    SizedBox(height: 75),
                    Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'فريق العمل',
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
              ),
              _createNewEmloyee(context, 'Muhammed Essa',
                  'Manager code for Iraq', 'Kirkuk', 'images/MuhammedEssa.jpg'),
              SizedBox(height: 10),
              _createNewEmloyee(context, 'Zahraa Ali', 'Project manager',
                  'Wasit', 'images/ZahraAli.jpg'),
              SizedBox(height: 10),
              _createNewEmloyee(context, 'Noor Al-huda Lateef', 'ui/ux design',
                  'Wasit', 'images/NoorAlhuda.jpg'),
              SizedBox(height: 10),
              _createNewEmloyee(context, 'Ahmed Yaseen', 'Programmer',
                  'Salah Al-din', 'images/AhmedYaseen.jpg'),
              SizedBox(height: 10),
              _createNewEmloyee(context, 'Murtada Hamid', 'Logc designer',
                  'Baghdad', 'images/MurtadaHamid.jpg'),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createNewEmloyee(BuildContext context, String name, String position,
      String city, String pathImage) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      height: 100,
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Color(0xffFFAADC),
              image: DecorationImage(
                  image: AssetImage(pathImage), fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 12),
              Text(
                '$name',
                style: TextStyle(
                    color: Color(0xFFCA39E3),
                    fontSize: 18,
                    fontFamily: 'ae_Sindibad',
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '$position',
                style: TextStyle(
                    color: Color(0xFFCA39E3),
                    fontSize: 14,
                    fontFamily: 'ae_Sindibad',
                    fontStyle: FontStyle.italic),
              ),
              Text(
                '$city',
                style: TextStyle(
                    color: Color(0xFFCA39E3),
                    fontSize: 14,
                    fontFamily: 'ae_Sindibad',
                    fontStyle: FontStyle.italic),
              ),
            ],
          )
        ],
      ),
    );
  }
}
