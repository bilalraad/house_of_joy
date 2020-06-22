import 'package:flutter/material.dart';

class About extends StatelessWidget {
  final bool isAboutApp;

  const About({this.isAboutApp = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/backgroundImage.png',
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                    const SizedBox(height: 75),
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          isAboutApp ? 'حول التطبيق' : 'حول المبادرة',
                          style: const TextStyle(
                              color: Color(0xffFD85CB),
                              fontSize: 24,
                              fontFamily: 'ae_Sindibad'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 220,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage(
                      isAboutApp
                          ? 'images/logo.png'
                          : 'images/code_for_iraq.png',
                    ),
                    fit: BoxFit.contain,
                  )),
                ),
                const SizedBox(height: 15),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        isAboutApp
                            ? const Text(
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
                                textAlign: TextAlign.center,
                              )
                            : const Text(
                                'وهي مبادرة انسانية غير ربحية تهدف الى خدمة المجتمع عن طريق البرمجة (Programming). '
                                'تعتبر "Code for Iraq" مبادرة تعليمية حقيقية ترعى المهتمين بتعلم تصميم وبرمجة تطبيقات الهاتف الجوال ومواقع الانترنت وبرامج الحاسوب والشبكات والاتصالات ونظم تشغيل الحاسوب '
                                'بأستخدام التقنيات مفتوحة المصدر Open source  , كما توفر لهم جميع الدروس التعليمية اللازمة وبشكل مجاني تماما .',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center,
                              ),
                        const SizedBox(height: 30)
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

final List<Map<String, String>> teamData = [
  {
    'name': 'مُحمد عيسى',
    'position': 'صاحب مبادرة البرمجة من اجل العراق',
    'city': 'كركوك',
    'email': 'muhammed.essa@codeforiraq.org',
  },
  {
    'name': 'زهراء عليّ',
    'position': 'ادارة المشروع',
    'city': 'واسط',
    'email': 'zahraa.ali@codeforiraq.org',
  },
  {
    'name': 'نور الهُدى لطيّف',
    'position': 'تصميم التطبيق',
    'city': 'واسط',
    'email': 'noor.alhuda@codeforiraq.org',
  },
  {
    'name': 'بِلال رعد',
    'position': 'برمجة التطبيق',
    'city': 'بغداد',
    'email': 'bilal.raad@codeforiraq.org',
  },
  {
    'name': 'أحمد ياسين',
    'position': 'برمجة التطبيق',
    'city': 'صلاح االدين',
    'email': '',
  },
  {
    'name': 'مُرتضى حامد',
    'position': 'تصميم الشعار',
    'city': 'بغداد',
    'email': '',
  },
];

class Staff extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'images/backgroundImage.png',
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              SafeArea(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                    const SizedBox(height: 75),
                    const Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          'فريق العمل',
                          style: TextStyle(
                              color: Color(0xffFD85CB),
                              fontSize: 24,
                              fontFamily: 'ae_Sindibad'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              for (var member in teamData)
                _createNewEmloyee(
                    name: member['name'],
                    city: member['city'],
                    email: member['email'],
                    position: member['position'])
            ],
          ),
        ),
      ),
    );
  }

  Widget _createNewEmloyee(
      {String name, String position, String city, String email}) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                style: const TextStyle(
                    color: Color(0xffFD85CB),
                    fontSize: 23,
                    fontFamily: 'ae_Sindibad',
                    fontWeight: FontWeight.bold),
              ),
              Text(
                city,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                position,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                email,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
