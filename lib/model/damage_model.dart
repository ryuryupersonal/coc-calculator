import 'package:equatable/equatable.dart';

class DamageModel extends Equatable {
  final String id;
  final String name;
  final String img;
  final List<int> damage;
  final int max;

  const DamageModel(
      {required this.id,
      required this.name,
      required this.img,
      required this.damage,
      required this.max});

  factory DamageModel.fromJson(Map<String, dynamic> json) {
    return DamageModel(
        id: json["id"] as String,
        name: json["name"] as String,
        img: json["img"] as String,
        damage: (json["damage"] as List<dynamic>).map((e) => e as int).toList(),
        max: json["max"] as int);
  }

  @override
  List<Object> get props => [id, name, img, damage, max];
}
