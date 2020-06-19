import 'package:flutter/material.dart';

import './category_card_item.dart';
import '../../models/category.dart';

class CategoryTabView extends StatelessWidget {
  final CategoryTabType type;
  final String category;

  const CategoryTabView({this.type, this.category});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          color: const Color(0xffFAFBFD),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              Column(
                children: List<Widget>.generate(
                  categories.length,
                  (i) {
                    return Column(
                      children: <Widget>[
                        categories[i].type == type
                            ? Container(
                                margin: const EdgeInsets.only(bottom: 30),
                                child: CategoryCardItem(
                                  category: categories[i].name,
                                  pathImage: categories[i].image,
                                ),
                              )
                            : Container(),
                        i == categories.length-1
                            ? const SizedBox(height: 100)
                            : Container(),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 80)
            ],
          ),
        ),
      ],
    );
  }
}
