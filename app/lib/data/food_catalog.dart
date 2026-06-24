// Oddiy mahalliy ovqatlar bazasi (lug'at). 100 g uchun kaloriya (kkal).
class FoodItem {
  final String name;
  final double kcalPer100g;
  const FoodItem(this.name, this.kcalPer100g);
}

const List<FoodItem> kFoodCatalog = [
  FoodItem('Non (oddiy)', 265),
  FoodItem('Palov', 210),
  FoodItem('Guruch (pishgan)', 130),
  FoodItem('Makaron (pishgan)', 158),
  FoodItem('Kartoshka (qaynatilgan)', 86),
  FoodItem('Mol go\'shti', 250),
  FoodItem('Tovuq go\'shti', 165),
  FoodItem('Baliq', 206),
  FoodItem('Tuxum', 155),
  FoodItem('Sut', 60),
  FoodItem('Qatiq', 60),
  FoodItem('Suzma', 98),
  FoodItem('Pishloq', 350),
  FoodItem('Sabzi', 41),
  FoodItem('Piyoz', 40),
  FoodItem('Pomidor', 18),
  FoodItem('Bodring', 15),
  FoodItem('Olma', 52),
  FoodItem('Banan', 89),
  FoodItem('Uzum', 69),
  FoodItem('Tarvuz', 30),
  FoodItem('Qovun', 34),
  FoodItem('Yong\'oq', 654),
  FoodItem('Asal', 304),
  FoodItem('Shakar', 387),
  FoodItem('Choy (shakarsiz)', 1),
  FoodItem('Kofe (shakarsiz)', 2),
  FoodItem('Sho\'rva', 56),
  FoodItem('Manti', 200),
  FoodItem('Somsa', 280),
];
