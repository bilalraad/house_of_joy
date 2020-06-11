import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:house_of_joy/functions/lunch_whatsApp.dart';
import 'package:house_of_joy/functions/validations.dart';

class Order extends StatefulWidget {
  final String userNumber;

  const Order({@required this.userNumber});
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFBFD),
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                          'images/backgroundImage.png',
                        ),
                        fit: BoxFit.fitWidth)),
                child: Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  color: Color.fromRGBO(250, 251, 253, 75),
                  child: Transform.translate(
                    offset: Offset(0, -5),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        Expanded(child: SizedBox(height: 75)),
                        Text(
                          'ارسال طلب',
                          style: TextStyle(
                            color: Color(0xffE10586),
                            fontSize: 26,
                            fontFamily: 'ae_Sindibad',
                          ),
                        ),
                        Expanded(child: SizedBox(height: 75)),
                        // IconButton(
                        //     icon: Icon(Icons.home),
                        //     iconSize: 30,
                        //     onPressed: () {

                        //     }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'أحجز طلبيتك عبر الواتساب',
                  style: TextStyle(
                    color: Color(0xFFCA39E3),
                    fontSize: 18,
                    fontFamily: 'ae_Sindibad',
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: 45,
                  decoration: BoxDecoration(
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
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/whatsApp.png'),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'WhatsApp',
                          style: TextStyle(
                            color: Color(0xFF68EC68),
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                    padding: const EdgeInsets.all(5.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                widget.userNumber.isEmpty
                        ? Text('لم يضع صاحب المنشور رقم هاتفه، يمكنك طلب ذلك من خلال التعليقات')
                        :Container()
              ],
            ),
          )
        ],
      ),
    );
  }
}
