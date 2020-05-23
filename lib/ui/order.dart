import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFAFBFD),
      body:ListView(
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
                          'images/backgroundImage.jpg',
                        ),
                        fit: BoxFit.fitWidth)),
                child: Container(
                  alignment: Alignment.topLeft,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                  color: Color.fromRGBO(250, 251, 253, 75),
                  child: Transform.translate( offset: Offset(0,-5),
                    child: Row(
                      children: <Widget>[


                        IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              Navigator.pop(context);
                            }
                        ),

                        Expanded(child: SizedBox(
                          height: 75,
                        ),),
                        Text(
                          'الطلبيات',
                          style: TextStyle(
                              color: Color(0xffE10586),
                              fontSize: 26,
                              fontFamily: 'ae_Sindibad'),
                        ),
                        Expanded(child: SizedBox(
                          height: 75,
                        ),),


                        IconButton(
                            icon: Icon(Icons.home),
                            iconSize: 30,
                            onPressed: () {

                            }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              Text(
                'أحجز طلبيتك عبر الفايبر أو الواتساب',
                style: TextStyle(
                    color: Color(0xFFCA39E3),
                    fontSize: 18,
                    fontFamily: 'ae_Sindibad'),
              ),
              SizedBox(height: 30,),
              Container(
                width: MediaQuery.of(context).size.width / 1.8,
                height: 45,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),

                    color: Colors.white,
                   ),
                child: RaisedButton(
                  color: Colors.white,
                  onPressed: () => {
                    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>signUp()),),
                  },

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('images/viber.png'),),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Text(
                        'Viber',
                        style: TextStyle(color: Color(0xFF8E24AA), fontSize: 24,),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),

                  padding: const EdgeInsets.all(5.0),

                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width / 1.8,
                height: 45,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    ),
                child: RaisedButton(
                  color: Colors.white,
                  onPressed: () => {
                    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>signUp()),),
                  },

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: AssetImage('images/whatsApp.png'),),
                        ),
                      ),
                      SizedBox(width: 5,),
                      Text(
                        'WhatsApp',
                        style: TextStyle(color: Color(0xFF68EC68), fontSize: 24,),
                      ),
                      SizedBox(width: 20,),
                    ],
                  ),

                  padding: const EdgeInsets.all(5.0),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ),)
        ],
      )

    );
  }
}
