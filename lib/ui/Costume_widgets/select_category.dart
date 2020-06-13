import 'package:flutter/material.dart';

class SelectCatigory extends StatefulWidget {
  final String initialValue;
  final Function(String selectedCategory) onSelectedCategory;

  const SelectCatigory({
    this.onSelectedCategory,
    this.initialValue,
  });

  @override
  _SelectCatigoryState createState() => _SelectCatigoryState();
}

class _SelectCatigoryState extends State<SelectCatigory> {
  List<String> categories = [
    '',
    'كتب',
    'الأكل الشرقي',
    'الأكل الغربي',
    'مواد التجميل',
    'العناية بالبشرة',
    'الحلويات',
    'الخياطة',
    'التطريز',
    'تجهيز مناسبات',
    'الأكسسوارات',
    'الكوشات',
    'التصوير',
    'طباعة الصور',
  ];
  int _defaultChoiceIndex;
  @override
  void initState() {
    _defaultChoiceIndex = categories.indexOf(widget.initialValue) ?? 0;
    super.initState();
  }

  Wrap wrapWidget() {
    return Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      textDirection: TextDirection.rtl,
      children: List<Widget>.generate(
        categories.length,
        (i) {
          return i == 0 ? Container() : chip(categories[i], i);
        },
      ),
    );
  }

  Widget chip(String label, int index) {
    return ChoiceChip(
      disabledColor: Colors.white,
      backgroundColor: Colors.white,
      labelPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      selected: _defaultChoiceIndex == index,
      label: Text(
        label,
        style: const TextStyle(
            fontFamily: 'ae_Sindibad', fontSize: 18, color: Color(0xff460053)),
      ),
      onSelected: (selected) {
        widget.onSelectedCategory(label);
        setState(
          () {
            _defaultChoiceIndex = selected ? index : 0;
          },
        );
      },
      selectedColor: const Color(0xffFD85CB),
      elevation: 1.0,
      padding: const EdgeInsets.all(6.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: wrapWidget(),
    );
  }
}
