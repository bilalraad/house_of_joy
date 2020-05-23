import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Staff extends StatefulWidget {
  @override
  _StaffState createState() => _StaffState();
}

class _StaffState extends State<Staff> {
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
                                'فريق العمل',
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

            _createNewEmloyee(context, 'Muhammed Essa', 'Manager code for Iraq', 'Kirkuk','images/MuhammedEssa.jpg'),
              SizedBox(height: 10,),
              _createNewEmloyee(context, 'Zahraa Ali', 'Project manager', 'Wasit','images/ZahraAli.jpg'),
              SizedBox(height: 10,),
              _createNewEmloyee(context, 'Noor Al-huda Lateef', 'ui/ux design', 'Wasit','images/NoorAlhuda.jpg'),
              SizedBox(height: 10,),
              _createNewEmloyee(context, 'Ahmed Yaseen', 'Programmer', 'Salah Al-din','images/AhmedYaseen.jpg'),
              SizedBox(height: 10,),
              _createNewEmloyee(context, 'Murtada Hamid', 'Logc designer', 'Baghdad','images/MurtadaHamid.jpg'),
              SizedBox(height: 10,),
            ],
          ),
        ],
      ),
    );
  }

  Widget _createNewEmloyee(BuildContext context,String name,String position,String city,String pathImage){
    return Container(
      width: MediaQuery.of(context).size.width/1.1,
      height: 100,
      child: Row(
        children: <Widget>[
          Container(

            width:100,
            height:100,
            decoration: BoxDecoration(
                color: Color(0xffFFAADC),
                image: DecorationImage(
                    image: AssetImage(pathImage),
                    fit: BoxFit.cover
                ),
                borderRadius: BorderRadius.circular(10),
            ),
          ),

          SizedBox(width: 5,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 12,),
              Text('$name',style: TextStyle(color: Color(0xFFCA39E3),fontSize: 18,fontFamily: 'ae_Sindibad',fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),),
              Text('$position',style: TextStyle(color: Color(0xFFCA39E3),fontSize: 14,fontFamily: 'ae_Sindibad',fontStyle: FontStyle.italic),),
              Text('$city',style: TextStyle(color: Color(0xFFCA39E3),fontSize: 14,fontFamily: 'ae_Sindibad',fontStyle: FontStyle.italic),),
            ],
          )

        ],
      ),
    );
  }
}
