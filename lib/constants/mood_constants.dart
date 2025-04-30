import 'package:flutter/material.dart';

class MoodData {
  final String type;
  final String label;
  final String emoji;
  final Color color;
  final String creatureDescription;

  const MoodData({
    required this.type,
    required this.label,
    required this.emoji,
    required this.color,
    required this.creatureDescription,
  });
}

class MoodConstants {
  static const Map<String, MoodData> moods = {
    'happy': MoodData(
      type: 'happy',
      label: 'Happy',
      emoji: '😊',
      color: Color(0xFFFFD700), // Gold
      creatureDescription: 'BeamBlob is a sunny little creature that radiates positive energy.',
    ),
    'sad': MoodData(
      type: 'sad',
      label: 'Sad',
      emoji: '😢',
      color: Color(0xFF6699CC), // Blue
      creatureDescription: 'DroopDuck carries your sadness with gentle understanding.',
    ),
    'angry': MoodData(
      type: 'angry',
      label: 'Angry',
      emoji: '😠',
      color: Color(0xFFFF6B6B), // Red
      creatureDescription: 'FuryFox helps you manage your frustration and righteous anger.',
    ),
    'anxious': MoodData(
      type: 'anxious',
      label: 'Anxious',
      emoji: '😰',
      color: Color(0xFFFF9F45), // Orange
      creatureDescription: 'JitterJelly vibrates with nervous energy just like you do sometimes.',
    ),
    'calm': MoodData(
      type: 'calm',
      label: 'Calm',
      emoji: '😌',
      color: Color(0xFF88D8B0), // Mint Green
      creatureDescription: 'SereneSeal floats peacefully in tranquil waters of mindfulness.',
    ),
    'excited': MoodData(
      type: 'excited',
      label: 'Excited',
      emoji: '🤩',
      color: Color(0xFFFF85A2), // Pink
      creatureDescription: 'BounceBean can\'t contain its enthusiasm, just like you!',
    ),
    'tired': MoodData(
      type: 'tired',
      label: 'Tired',
      emoji: '😴',
      color: Color(0xFF9D8DF1), // Lavender
      creatureDescription: 'SleepySloth understands when you need to rest and recharge.',
    ),
  };

  static List<MoodData> get moodList => moods.values.toList();

  static MoodData getMood(String type) {
    return moods[type] ?? moods['happy']!;
  }
}