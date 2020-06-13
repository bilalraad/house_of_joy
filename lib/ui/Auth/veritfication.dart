import 'package:flutter/material.dart';

class Veritfication extends StatelessWidget {
  final _colorpink = const Color(0xffFFAADC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'images/backgroundImage.png',
                              ),
                              fit: BoxFit.cover)),
                      child: Container(
                        color: const Color.fromRGBO(250, 251, 253, 75),
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
                            Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'تاكيد الحساب',
                                  style: TextStyle(
                                      color: _colorpink,
                                      fontSize: 30,
                                      fontFamily: 'ae_Sindibad'),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(left: 25, right: 20),
                  child: Text(
                    // ' We just sent veritfication link to your email address.Please verify your email and login',
                    'لقد ثمنا بارسال رابط تاكيد الحساب الى بريدك الالكتروني. رجاءا قم بتاكيد حسابك وسجل دخول مرة اخرى.',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 20, fontFamily: 'ae_Sindibad'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
