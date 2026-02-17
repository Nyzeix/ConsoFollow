class Home {
  final int? id;
  final String name;

  Home({this.id, required this.name});

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Home.fromMap(Map<String, dynamic> map) {
    return Home(
      id: map['id'],
      name: map['name'],
    );
  }
}