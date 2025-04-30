import 'package:flutter/material.dart';
import 'package:mood_pal/models/mood_entry.dart';
import 'package:mood_pal/constants/mood_constants.dart';
import 'package:intl/intl.dart';

class MoodHistoryCard extends StatelessWidget {
  final MoodEntry entry;
  final VoidCallback? onTap;
  
  const MoodHistoryCard({
    Key? key,
    required this.entry,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moodData = MoodConstants.getMood(entry.moodType);
    final dateFormat = DateFormat('E, MMM d, yyyy • h:mm a');
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: moodData.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      moodData.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          moodData.label,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: moodData.color,
                          ),
                        ),
                        Text(
                          dateFormat.format(entry.timestamp),
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: onTap,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ],
              ),
              if (entry.journalText != null && entry.journalText!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  entry.journalText!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (entry.audioUrl != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.mic,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Voice Note',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
              if (entry.aiEmotionCaption != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    entry.aiEmotionCaption!,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontStyle: FontStyle.italic,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}