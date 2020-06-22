import 'package:flutter/material.dart';

import '../Auth/login.dart';

class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
              'images/backgroundImageStart.png',
            ),
            fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
        body: ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(width: double.infinity),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 50),
                  ),
                  const Text(
                    'Welcome To',
                    style: TextStyle(
                        color: Color.fromARGB(200, 255, 170, 220),
                        fontSize: 26,
                        fontFamily: 'Sonsie One'),
                  ),
                  // const SizedBox(height: 20),
                  Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Row(
                          children: <Widget>[
                            const Expanded(
                              child: SizedBox(height: 0.0),
                            ),
                            const Text(
                              'H',
                              style: TextStyle(
                                  color: Color.fromARGB(200, 202, 57, 227),
                                  fontSize: 72,
                                  fontFamily: 'French Script MT'),
                            ),
                            const Text(
                              'ouse of joy',
                              style: TextStyle(
                                  color: Color.fromARGB(250, 255, 170, 220),
                                  fontSize: 36,
                                  fontFamily: 'Teko'),
                            ),
                            const Expanded(
                              child: SizedBox(height: 0.0),
                            ),
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0, 50),
                        child: Container(
                            child: Row(children: <Widget>[
                          const Expanded(
                            child: SizedBox(height: 0.0),
                          ),
                          const Text(
                            'الفرح',
                            style: TextStyle(
                                color: Color.fromARGB(200, 255, 170, 220),
                                fontSize: 36,
                                fontFamily: 'ae_Sindibad'),
                          ),
                          const Text(
                            'بيت',
                            style: TextStyle(
                                color: Color.fromARGB(200, 202, 57, 227),
                                fontSize: 36,
                                fontFamily: 'ae_Sindibad'),
                          ),
                          const Expanded(
                            child: SizedBox(height: 0.0),
                          ),
                        ])),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'An application to support small projects for women',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 120),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 45,
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      color: const Color(0xffFFAADC),
                      child: const Text(
                        'ابدا',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontFamily: 'ae_Sindibad'),
                      ),
                      padding: const EdgeInsets.all(5.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
