// models/elder.dart
class Elder {
  final String id;
  final String name;
  final int age;
  final String roomNumber;
  final String photoUrl;

  Elder({
    required this.id,
    required this.name,
    required this.age,
    required this.roomNumber,
    required this.photoUrl,
  });

  factory Elder.fromMap(Map<String, dynamic> data, String documentId) {
    return Elder(
      id: documentId,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      roomNumber: data['roomNumber'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'age': age,
    'roomNumber': roomNumber,
    'photoUrl': photoUrl,
  };
}
