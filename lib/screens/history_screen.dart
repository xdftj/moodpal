import 'package:flutter/material.dart';
import 'package:mood_pal/providers/mood_provider.dart';
import 'package:mood_pal/widgets/mood_history_card.dart';
import 'package:provider/provider.dart';
import 'package:mood_pal/models/mood_entry.dart';
import 'package:mood_pal/constants/mood_constants.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _filterMoodType;
  
  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);
    final entries = moodProvider.entries;
    
    List<MoodEntry> filteredEntries = entries;
    if (_filterMoodType != null) {
      filteredEntries = entries.where((entry) => entry.moodType == _filterMoodType).toList();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: filteredEntries.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: filteredEntries.length,
              itemBuilder: (context, index) {
                final entry = filteredEntries[index];
                return MoodHistoryCard(
                  entry: entry,
                  onTap: () {
                    _showEntryDetails(context, entry);
                  },
                );
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.history_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _filterMoodType != null
                ? 'No ${MoodConstants.getMood(_filterMoodType!).label} Entries'
                : 'No Mood Entries Yet',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _filterMoodType != null
                  ? 'You haven\'t logged any ${MoodConstants.getMood(_filterMoodType!).label.toLowerCase()} moods yet. Try a different filter!'
                  : 'Start logging your moods to build a history and track your emotional patterns.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          if (_filterMoodType != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _filterMoodType = null;
                });
              },
              child: const Text('Clear Filter'),
            ),
          ],
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter by Mood',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterChip(context, null, 'All Moods'),
                  ...MoodConstants.moodList.map((mood) {
                    return _buildFilterChip(context, mood.type, mood.label, emoji: mood.emoji);
                  }).toList(),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(BuildContext context, String? moodType, String label, {String? emoji}) {
    final isSelected = _filterMoodType == moodType;
    final mood = moodType != null ? MoodConstants.getMood(moodType) : null;
    
    return FilterChip(
      selected: isSelected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (emoji != null) ...[
            Text(emoji),
            const SizedBox(width: 8),
          ],
          Text(label),
        ],
      ),
      backgroundColor: mood != null 
          ? mood.color.withOpacity(0.1) 
          : Theme.of(context).colorScheme.surface,
      selectedColor: mood != null 
          ? mood.color.withOpacity(0.3) 
          : Theme.of(context).colorScheme.primaryContainer,
      onSelected: (selected) {
        setState(() {
          _filterMoodType = selected ? moodType : null;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showEntryDetails(BuildContext context, MoodEntry entry) {
    final moodData = MoodConstants.getMood(entry.moodType);
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: moodData.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          moodData.emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              moodData.label,
                              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: moodData.color,
                              ),
                            ),
                            Text(
                              dateFormat.format(entry.timestamp),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              timeFormat.format(entry.timestamp),
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  if (entry.journalText != null && entry.journalText!.isNotEmpty) ...[
                    Text(
                      'Journal Entry',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                        ),
                      ),
                      child: Text(
                        entry.journalText!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (entry.audioUrl != null) ...[
                    Text(
                      'Voice Note',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.play_circle_filled_rounded,
                            size: 36,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tap to play',
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Voice recording from ${timeFormat.format(entry.timestamp)}',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (entry.aiEmotionCaption != null) ...[
                    Text(
                      'AI Analysis',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emotion Caption:',
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            entry.aiEmotionCaption!,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          if (entry.aiResponse != null) ...[
                            const SizedBox(height: 16),
                            Text(
                              'MoodPal\'s Response:',
                              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              entry.aiResponse!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}