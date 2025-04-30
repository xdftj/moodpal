class MoodCreature {
  final String moodType;
  final DateTime discoveredAt;
  int occurrenceCount;
  DateTime lastSeen;
  int evolutionLevel;

  MoodCreature({
    required this.moodType,
    required this.discoveredAt,
    required this.occurrenceCount,
    required this.lastSeen,
    required this.evolutionLevel,
  });

  String get name {
    switch (moodType) {
      case 'happy':
        return 'BeamBlob';
      case 'sad':
        return 'DroopDuck';
      case 'angry':
        return 'FuryFox';
      case 'anxious':
        return 'JitterJelly';
      case 'calm':
        return 'SereneSeal';
      case 'excited':
        return 'BounceBean';
      case 'tired':
        return 'SleepySloth';
      default:
        return 'MysteryMood';
    }
  }
  
  String get imageAsset {
    return 'assets/creatures/${moodType}_lvl$evolutionLevel.png';
  }

  Map<String, dynamic> toJson() {
    return {
      'moodType': moodType,
      'discoveredAt': discoveredAt.toIso8601String(),
      'occurrenceCount': occurrenceCount,
      'lastSeen': lastSeen.toIso8601String(),
      'evolutionLevel': evolutionLevel,
    };
  }

  factory MoodCreature.fromJson(Map<String, dynamic> json) {
    return MoodCreature(
      moodType: json['moodType'],
      discoveredAt: DateTime.parse(json['discoveredAt']),
      occurrenceCount: json['occurrenceCount'],
      lastSeen: DateTime.parse(json['lastSeen']),
      evolutionLevel: json['evolutionLevel'],
    );
  }
}