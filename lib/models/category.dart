enum CategoryTabType {
  books,
  craftworks,
  photography,
  sewing,
  cooking,
  cosmetic,
}

class Category {
  final String name;
  final String image;
  final CategoryTabType type;

  const Category({this.type, this.name, this.image});
}

final List<Category> categories = [
  const Category(
    name: 'الأكل الشرقي',
    image: 'images/easternEating.jpg',
    type: CategoryTabType.cooking,
  ),
  const Category(
    name: 'الأكل الغربي',
    image: 'images/westernEting.jpg',
    type: CategoryTabType.cooking,
  ),
  const Category(
    name: 'الحلويات',
    image: 'images/candy.jpg',
    type: CategoryTabType.cooking,
  ),
  const Category(
    name: 'تجهيز مناسبات',
    image: 'images/occasions.jpg',
    type: CategoryTabType.cooking,
  ),
  const Category(
    name: 'كتب',
    image: 'images/book.jpg',
    type: CategoryTabType.books,
  ),
  const Category(
    name: 'مواد التجميل',
    image: 'images/cosmeticMateral.jpg',
    type: CategoryTabType.cosmetic,
  ),
  const Category(
    name: 'العناية بالبشرة',
    image: 'images/skinCare.jpg',
    type: CategoryTabType.cosmetic,
  ),
  const Category(
    name: 'الأكسسوارات',
    image: 'images/accessories.jpg',
    type: CategoryTabType.craftworks,
  ),
  const Category(
    name: 'الكوشات',
    image: 'images/handWork.jpg',
    type: CategoryTabType.craftworks,
  ),
  const Category(
    name: 'التصوير',
    image: 'images/photogrphy.jpg',
    type: CategoryTabType.photography,
  ),
  const Category(
    name: 'طباعة الصور',
    image: 'images/printPhoto.jpg',
    type: CategoryTabType.photography,
  ),
  const Category(
    name: 'الخياطة',
    image: 'images/sewing.jpg',
    type: CategoryTabType.sewing,
  ),
  const Category(
    name: 'التطريز',
    image: 'images/handWork.jpg',
    type: CategoryTabType.sewing,
  ),
];
