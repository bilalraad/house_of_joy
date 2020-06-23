import 'package:flutter/material.dart';

import '../../functions/lunch_whatsApp.dart';
import '../../functions/validations.dart';

class Order extends StatefulWidget {
  final String userNumber;

  const Order({@required this.userNumber});
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
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
        extendBodyBehindAppBar: true,
        backgroundColor: const Color.fromRGBO(250, 251, 253, 75),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios,color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: const Text(
            'ارسال طلب',
            style: TextStyle(
              color: Color(0xffE10586),
              fontSize: 26,
              fontFamily: 'ae_Sindibad',
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'أحجز طلبيتك عبر الواتساب',
              style: TextStyle(
                color: Color(0xFFCA39E3),
                fontSize: 18,
                fontFamily: 'ae_Sindibad',
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: MediaQuery.of(context).size.width / 1.8,
              height: 45,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.white,
              ),
              child: RaisedButton(
                color: Colors.white,
                onPressed: widget.userNumber.isEmpty
                    ? null
                    : () async {
                        try {
                          await launchWhatsApp(phone: widget.userNumber);
                        } catch (e) {
                          showFlushSnackBar(context, e);
                        }
                      },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 30,
                      width: 30,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/whatsApp.png'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'WhatsApp',
                      style: TextStyle(
                        color: Color(0xFF68EC68),
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
                padding: const EdgeInsets.all(5.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            widget.userNumber.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Text(
                      'لم يضع صاحب المنشور رقم هاتفه، يمكنك طلب ذلك من خلال التعليقات',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
