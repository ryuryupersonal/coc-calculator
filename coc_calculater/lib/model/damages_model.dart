import 'package:equatable/equatable.dart';

class DamagesModel extends Equatable {
  final String id;
  final String name;
  final String img;
  final List<int> damage;
  final int max;

  const DamagesModel(
      {required this.id,
      required this.name,
      required this.img,
      required this.damage,
      required this.max});

  factory DamagesModel.fromJson(Map<String, dynamic> json) {
    return DamagesModel(
        id: json["id"] as String,
        name: json["name"] as String,
        img: json["img"] as String,
        damage: (json["damage"] as List<dynamic>).map((e) => e as int).toList(),
        max: json["max"] as int);
  }

  @override
  List<Object> get props => [id, name, img, damage, max];
}
