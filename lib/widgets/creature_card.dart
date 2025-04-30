import 'package:flutter/material.dart';
import 'package:mood_pal/models/mood_creature.dart';
import 'package:mood_pal/constants/mood_constants.dart';

class CreatureCard extends StatelessWidget {
  final MoodCreature creature;
  final VoidCallback? onTap;
  final bool isCompact;
  
  const CreatureCard({
    Key? key,
    required this.creature,
    this.onTap,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moodData = MoodConstants.getMood(creature.moodType);
    
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: moodData.color.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 8 : 16),
          child: isCompact ? _buildCompactContent(context, moodData) : _buildFullContent(context, moodData),
        ),
      ),
    );
  }

  Widget _buildCompactContent(BuildContext context, MoodData moodData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // This would be the actual creature image when available
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: moodData.color.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              moodData.emoji,
              style: const TextStyle(fontSize: 30),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          creature.name,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          'Level ${creature.evolutionLevel}',
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFullContent(BuildContext context, MoodData moodData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // This would be the actual creature image when available
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: moodData.color.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  moodData.emoji,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    creature.name,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Level ${creature.evolutionLevel}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Discovered ${_formatDate(creature.discoveredAt)}',
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          moodData.creatureDescription,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: moodData.color.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                moodData.emoji,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 4),
              Text(
                'Observed ${creature.occurrenceCount} times',
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}