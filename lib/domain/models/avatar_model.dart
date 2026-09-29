import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class MonsterAvatar {
  final String id;
  final String name;
  final String tagline;
  final IconData icon;
  final Color accentColor;
  final Color backgroundColor;

  const MonsterAvatar({
    required this.id,
    required this.name,
    required this.tagline,
    required this.icon,
    required this.accentColor,
    required this.backgroundColor,
  });

  static const List<MonsterAvatar> all = [
    MonsterAvatar(
      id: 'monster_spark',
      name: 'Spark',
      tagline: 'The Friendly Lab Companion',
      icon: Icons.smart_toy,
      accentColor: AppColors.primaryViolet,
      backgroundColor: Color(0xFFEDE7F6),
    ),
    MonsterAvatar(
      id: 'monster_volt',
      name: 'Volt',
      tagline: 'High-Energy Electric Pioneer',
      icon: Icons.bolt,
      accentColor: AppColors.energyAmber,
      backgroundColor: Color(0xFFFFF8E1),
    ),
    MonsterAvatar(
      id: 'monster_gear',
      name: 'Gear',
      tagline: 'Master of Moving Machines',
      icon: Icons.settings,
      accentColor: Color(0xFFFF6D00),
      backgroundColor: Color(0xFFFBE9E7),
    ),
    MonsterAvatar(
      id: 'monster_circuit',
      name: 'Circuit',
      tagline: 'Logic & Sensor Specialist',
      icon: Icons.memory,
      accentColor: AppColors.accentCyan,
      backgroundColor: Color(0xFFE0F7FA),
    ),
    MonsterAvatar(
      id: 'monster_pixel',
      name: 'Pixel',
      tagline: 'Creative Light & Display Artist',
      icon: Icons.palette,
      accentColor: Color(0xFFE91E63),
      backgroundColor: Color(0xFFFCE4EC),
    ),
    MonsterAvatar(
      id: 'monster_byte',
      name: 'Byte',
      tagline: 'Digital Code Explorer',
      icon: Icons.terminal,
      accentColor: AppColors.success,
      backgroundColor: Color(0xFFE8F5E9),
    ),
  ];

  static MonsterAvatar findById(String? id) {
    if (id == null) return all.first;
    return all.firstWhere(
      (a) => a.id == id,
      orElse: () => all.first,
    );
  }
}
