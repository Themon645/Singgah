import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 3)
class User extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String email;
  
  @HiveField(3)
  final String? profilePicture;
  
  @HiveField(4)
  final String password; // Hanya untuk simulasi database lokal

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'profilePicture': profilePicture,
    'password': password,
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    password: json['password'] ?? '',
    profilePicture: json['profilePicture'],
  );
}
