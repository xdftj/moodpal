import 'package:flutter/material.dart';
import 'package:mood_pal/models/mood_entry.dart';
import 'package:mood_pal/models/mood_creature.dart';
import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MoodProvider with ChangeNotifier {
  final List<MoodEntry> _entries = [];
  Map<String, MoodCreature> _creatures = {};
  int _streakCount = 0;
  DateTime? _lastEntryDate;
  MoodEntry? _currentDayEntry;

  UnmodifiableListView<MoodEntry> get entries => UnmodifiableListView(_entries);
  UnmodifiableMapView<String, MoodCreature> get creatures => UnmodifiableMapView(_creatures);
  int get streakCount => _streakCount;
  MoodEntry? get currentDayEntry => _currentDayEntry;

  MoodProvider() {
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load entries
    final entriesJson = prefs.getStringList('mood_entries') ?? [];
    _entries.clear();
    for (final entryJson in entriesJson) {
      _entries.add(MoodEntry.fromJson(jsonDecode(entryJson)));
    }
    _entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    // Load creatures
    final creaturesJson = prefs.getStringList('mood_creatures') ?? [];
    _creatures = {};
    for (final creatureJson in creaturesJson) {
      final creature = MoodCreature.fromJson(jsonDecode(creatureJson));
      _creatures[creature.moodType] = creature;
    }

    // Load streak
    _streakCount = prefs.getInt('streak_count') ?? 0;
    final lastEntryStr = prefs.getString('last_entry_date');
    if (lastEntryStr != null) {
      _lastEntryDate = DateTime.parse(lastEntryStr);
    }

    // Check if there's an entry for today
    _checkForTodayEntry();
    
    notifyListeners();
  }

  Future<void> _saveMoodData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save entries
    final entriesJson = _entries.map((entry) => jsonEncode(entry.toJson())).toList();
    await prefs.setStringList('mood_entries', entriesJson);

    // Save creatures
    final creaturesJson = _creatures.values.map((creature) => jsonEncode(creature.toJson())).toList();
    await prefs.setStringList('mood_creatures', creaturesJson);

    // Save streak
    await prefs.setInt('streak_count', _streakCount);
    if (_lastEntryDate != null) {
      await prefs.setString('last_entry_date', _lastEntryDate!.toIso8601String());
    }
  }

  void _checkForTodayEntry() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    _currentDayEntry = _entries.firstWhere(
      (entry) {
        final entryDate = DateTime(
          entry.timestamp.year, 
          entry.timestamp.month, 
          entry.timestamp.day
        );
        return entryDate == today;
      },
      orElse: () => MoodEntry.empty(),
    );
    
    if (_currentDayEntry!.isEmpty) {
      _currentDayEntry = null;
    }
  }

  void _updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    if (_lastEntryDate == null) {
      // First entry ever
      _streakCount = 1;
    } else {
      final yesterday = today.subtract(const Duration(days: 1));
      final lastEntryDay = DateTime(
        _lastEntryDate!.year,
        _lastEntryDate!.month,
        _lastEntryDate!.day,
      );
      
      if (lastEntryDay == yesterday) {
        // Consecutive day
        _streakCount++;
      } else if (lastEntryDay != today) {
        // Missed a day
        _streakCount = 1;
      }
      // If same day, streak remains unchanged
    }
    
    _lastEntryDate = now;
  }

  Future<void> addMoodEntry(String moodType, String? journalText, String? audioUrl) async {
    final entry = MoodEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      moodType: moodType,
      timestamp: DateTime.now(),
      journalText: journalText,
      audioUrl: audioUrl,
    );
    
    _entries.insert(0, entry);
    _currentDayEntry = entry;
    _updateStreak();
    
    // Update or create creature
    if (_creatures.containsKey(moodType)) {
      _creatures[moodType]!.occurrenceCount++;
      _creatures[moodType]!.lastSeen = DateTime.now();
    } else {
      _creatures[moodType] = MoodCreature(
        moodType: moodType,
        discoveredAt: DateTime.now(),
        occurrenceCount: 1,
        lastSeen: DateTime.now(),
        evolutionLevel: 1,
      );
    }
    
    // Check for evolution
    _checkCreatureEvolution(moodType);
    
    await _saveMoodData();
    notifyListeners();
  }

  void _checkCreatureEvolution(String moodType) {
    final creature = _creatures[moodType]!;
    
    if (creature.occurrenceCount >= 30 && creature.evolutionLevel < 3) {
      creature.evolutionLevel = 3;
    } else if (creature.occurrenceCount >= 15 && creature.evolutionLevel < 2) {
      creature.evolutionLevel = 2;
    }
  }

  List<MoodEntry> getEntriesByMood(String moodType) {
    return _entries.where((entry) => entry.moodType == moodType).toList();
  }

  List<MoodEntry> getEntriesByDateRange(DateTime start, DateTime end) {
    return _entries.where((entry) => 
      entry.timestamp.isAfter(start) && 
      entry.timestamp.isBefore(end)
    ).toList();
  }

  String getMostFrequentMood() {
    if (_entries.isEmpty) return 'unknown';
    
    final moodCounts = <String, int>{};
    for (final entry in _entries) {
      moodCounts[entry.moodType] = (moodCounts[entry.moodType] ?? 0) + 1;
    }
    
    String mostFrequent = _entries.first.moodType;
    int highestCount = 0;
    
    moodCounts.forEach((mood, count) {
      if (count > highestCount) {
        mostFrequent = mood;
        highestCount = count;
      }
    });
    
    return mostFrequent;
  }

  MoodCreature? getMostEvolvedCreature() {
    if (_creatures.isEmpty) return null;
    
    MoodCreature? mostEvolved;
    int highestLevel = 0;
    
    for (final creature in _creatures.values) {
      if (creature.evolutionLevel > highestLevel) {
        mostEvolved = creature;
        highestLevel = creature.evolutionLevel;
      }
    }
    
    return mostEvolved;
  }
}