class Expense {
  Expense({
    this.id,
    this.name,
    this.category,
    this.date,
    this.nominal,
  });

  int id;
  String name;
  String category;
  String date;
  int nominal;

  factory Expense.fromMap(Map<String, dynamic> json) => Expense(
    id: json["id"],
    name: json["name"],
    category: json["category"],
    date: json["date"],
    nominal: json["nominal"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "category": category,
    "date": date,
    "nominal": nominal,
  };
}