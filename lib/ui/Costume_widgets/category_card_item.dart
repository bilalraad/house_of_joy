import 'package:flutter/material.dart';
import 'package:house_of_joy/models/user.dart';
import 'package:house_of_joy/services/shered_Preference.dart';
import 'package:provider/provider.dart';

import '../showTheGoods.dart';

// Widget categoryCardItem({
//   String category,
//   String pathImage,
//   BuildContext context,
// }) {
//   return
// }

class CategoryCardItem extends StatelessWidget {
  final String category;
  final String pathImage;
  const CategoryCardItem({
    this.category,
    this.pathImage,
  });

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 1.1,
          height: MediaQuery.of(context).size.height * 0.16,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromRGBO(240, 240, 240, 50),
              boxShadow: [
                BoxShadow(color: Color(0xffE8E8E8), blurRadius: 10),
              ]),
          
        ),
        Transform.translate(
          offset: Offset(0, -5),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            height: MediaQuery.of(context).size.height * 0.16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xffF3E4F7),
            ),
            child: FlatButton(
              child: Row(
                children: <Widget>[
                  Container(
                      height: MediaQuery.of(context).size.height * 0.14,
                      width: MediaQuery.of(context).size.height * 0.14,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                            image: AssetImage(pathImage), fit: BoxFit.cover),
                      )),
                  Expanded(
                    child: SizedBox(
                      width: 10,
                    ),
                  ),
                  Text(
                    '$category',
                    style: TextStyle(
                        fontFamily: 'ae_Sindibad',
                        fontSize: 18,
                        color: Color(0xff460053)),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 10,
                    ),
                  ),
                ],
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FutureProvider<User>.value(
                    value: SharedPrefs().getUser(),
                    child: ShowThwGoods(category),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
