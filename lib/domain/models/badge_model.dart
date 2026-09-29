import 'lesson_model.dart';

class BadgeModel {
  final String id;
  final String name;
  final String description;
  final String iconAsset;
  final String category;
  final DifficultyTier tier;
  final int xpBonus;

  const BadgeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
    required this.category,
    required this.tier,
    required this.xpBonus,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    return BadgeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      iconAsset: json['iconAsset'] as String,
      category: json['category'] as String,
      tier: DifficultyTier.values.byName(json['tier'] as String),
      xpBonus: json['xpBonus'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'iconAsset': iconAsset,
        'category': category,
        'tier': tier.name,
        'xpBonus': xpBonus,
      };
}
