class Character {
  final int id;
   String name;
  final String image;
  final String status;

  Character(
      {required this.id,
      required this.name,
      required this.image,
      required this.status});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      status: json['status'],
    );
  }
}
