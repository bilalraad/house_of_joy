import 'package:flutter/material.dart';
import 'package:house_of_joy/ui/veritfication.dart';

class ForgetPassword extends StatefulWidget{
  @override
  _ForgetPassword createState() {
    return _ForgetPassword();
  }
  
  
}
class _ForgetPassword extends State<ForgetPassword>{
  Color _colorpink= Color(0xffFFAADC);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(
        
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                'images/backgroundImage.jpg',
                              ),
                              fit: BoxFit.cover)),
                      child: Container(
                        color: Color.fromRGBO(250, 251, 253, 75),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topLeft,
                              child: IconButton(
                                  icon: Icon(Icons.arrow_back),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                            ),
                            SizedBox(
                              height: 75,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 30),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: _colorpink,
                                      fontSize: 24,
                                      fontFamily: 'Cambo'),
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

                SizedBox(
                  height: 15,
                ),
                Padding(padding:EdgeInsets.only(left: 25,right: 20),
                child: Text('Enter the email address associated with your acoount.',style: TextStyle(fontSize: 16),
                ),
                ),
                SizedBox(
                  height: 5,
                ),
                Padding(padding:EdgeInsets.only(left: 25,right: 20),
                  child: Text('We will email you a link to reset your password.',style: TextStyle(fontSize: 16,
                  color: Colors.grey),
                  ),
                ),

                SizedBox(
                  height: 15,
                ),
                Container(
                  width: MediaQuery.of(context).size.width/1.2,
                  child: TextField(
                    decoration: InputDecoration(

                      hintText: 'Email or Mobile Number',
                      hintStyle: TextStyle(
                          fontFamily: 'Cambo', color: Color(0xffA2A2A2)),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: 45,

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ]),
                  child: RaisedButton(
                    onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Veritfication(),));
                    },
                    color: _colorpink,
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.white, fontSize: 24,),
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
    );
  }
  
  
}