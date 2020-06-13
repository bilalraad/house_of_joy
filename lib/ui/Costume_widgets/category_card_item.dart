import 'package:flutter/material.dart';

import '../home/showTheGoods.dart';

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
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color.fromRGBO(240, 240, 240, 50),
              boxShadow: [
                BoxShadow(color: Color(0xffE8E8E8), blurRadius: 10),
              ]),
        ),
        Transform.translate(
          offset: const Offset(0, -5),
          child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            height: MediaQuery.of(context).size.height * 0.16,
            decoration: const BoxDecoration(
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
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                            image: AssetImage(pathImage), fit: BoxFit.cover),
                      )),
                  const Expanded(
                    child: SizedBox(width: 10),
                  ),
                  Text(
                    '$category',
                    style: const TextStyle(
                        fontFamily: 'ae_Sindibad',
                        fontSize: 18,
                        color: Color(0xff460053)),
                  ),
                  const Expanded(
                    child: SizedBox(width: 10),
                  ),
                ],
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShowThwGoods(category),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
