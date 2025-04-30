class MoodEntry {
  final String id;
  final String moodType;
  final DateTime timestamp;
  final String? journalText;
  final String? audioUrl;
  final String? aiTranscription;
  final String? aiEmotionCaption;
  final String? aiResponse;

  const MoodEntry({
    required this.id,
    required this.moodType,
    required this.timestamp,
    this.journalText,
    this.audioUrl,
    this.aiTranscription,
    this.aiEmotionCaption,
    this.aiResponse,
  });

  // Empty constructor to use with orElse in firstWhere
  factory MoodEntry.empty() {
    // Using a non-const DateTime constructor but in a factory method
    // which doesn't require const values
    return MoodEntry(
      id: '',
      moodType: '',
      timestamp: DateTime(0),
    );
  }

  bool get isEmpty => id.isEmpty;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moodType': moodType,
      'timestamp': timestamp.toIso8601String(),
      'journalText': journalText,
      'audioUrl': audioUrl,
      'aiTranscription': aiTranscription,
      'aiEmotionCaption': aiEmotionCaption,
      'aiResponse': aiResponse,
    };
  }

  factory MoodEntry.fromJson(Map<String, dynamic> json) {
    return MoodEntry(
      id: json['id'] as String,
      moodType: json['moodType'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      journalText: json['journalText'] as String?,
      audioUrl: json['audioUrl'] as String?,
      aiTranscription: json['aiTranscription'] as String?,
      aiEmotionCaption: json['aiEmotionCaption'] as String?,
      aiResponse: json['aiResponse'] as String?,
    );
  }
}