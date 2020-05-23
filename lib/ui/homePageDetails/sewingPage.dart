import 'package:flutter/material.dart';
import 'package:house_of_joy/ui/showTheGoods.dart';

class SewingPage extends StatefulWidget{



  @override
  State<StatefulWidget> createState() {
    return _SewingPageState();
  }
}

class _SewingPageState extends State<SewingPage>{
  @override
  Widget build(BuildContext context) {

    return ListView(

      children: <Widget>[
        Container(
            color: Color(0xffFAFBFD),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 30,),
                _createItem('الخياطة','images/sewing.jpg'),
                SizedBox(height: 20,),
                _createItem('التطريز', 'images/handWork.jpg'),
                SizedBox(height: 80,),
                SizedBox(height: 80,),
                SizedBox(height: 80,),
              ],
            )
        ),

      ],
    );
  }
  Widget _createItem(String title,String pathImage){
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width/1.1,
          height: MediaQuery.of(context).size.height*0.16,

          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromRGBO(240, 240, 240, 50),
              boxShadow: [
                BoxShadow(color: Color(0xffE8E8E8), blurRadius:10),
              ]),
        ),
        Transform.translate(offset: Offset(0, -5),
          child:Container(
            width: MediaQuery.of(context).size.width/1.1,
            height: MediaQuery.of(context).size.height*0.16,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xffF3E4F7),

            ),
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height*0.14,
                      width: MediaQuery.of(context).size.height*0.14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),

                        image: DecorationImage(image: AssetImage(pathImage),fit: BoxFit.cover),
                      )),
                  Expanded(child: SizedBox(width: 10,),),
                  Text('$title', style: TextStyle(fontFamily: 'ae_Sindibad',fontSize: 18,color: Color(0xff460053)),),
                  Expanded(child: SizedBox(width: 10,),),
                ],
              ),
              onPressed:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>ShowThwGoods(title))),

            ),


          ) ,
        )
      ],
    );
  }

}