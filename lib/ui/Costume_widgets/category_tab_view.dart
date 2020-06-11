import 'package:flutter/material.dart';
import 'package:house_of_joy/models/category.dart';
import 'package:house_of_joy/ui/Costume_widgets/category_card_item.dart';

class CategoryTabView extends StatelessWidget {
  final CategoryTabType type;
  final String category;

  const CategoryTabView({this.type, this.category});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          color: Color(0xffFAFBFD),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              Column(
                children: List<Widget>.generate(
                  categories.length,
                  (i) {
                    if (categories[i].type == type)
                      return Container(
                        margin: EdgeInsets.only(bottom: 30),
                        child: CategoryCardItem(
                          category: categories[i].name,
                          pathImage: categories[i].image,
                        ),
                      );
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
