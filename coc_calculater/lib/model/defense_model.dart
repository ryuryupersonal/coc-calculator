import 'package:equatable/equatable.dart';

class DefenseModel extends Equatable {
  final int id;
  final String defense;
  final int level;
  final List<int> th;
  final int hp;

  final int supercharge;

  const DefenseModel({
    required this.id,
    required this.defense,
    required this.level,
    required this.th,
    required this.hp,
    this.supercharge = 0
  });

  factory DefenseModel.fromJson(Map<String, dynamic> json) {
    return DefenseModel(
      id: json['id'] as int,
      defense: json['defense'] as String,
      level: json['level'] as int,
      th: (json['th'] as List<dynamic>).map((e) => e as int).toList(),
      hp: json['hp'] as int,
      supercharge: json['supercharge'] != null ? json['supercharge'] as int : 0
    );
  }

  @override
  List<Object?> get props => [id];
}