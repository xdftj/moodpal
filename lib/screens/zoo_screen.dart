import 'package:flutter/material.dart';
import 'package:mood_pal/providers/mood_provider.dart';
import 'package:mood_pal/widgets/creature_card.dart';
import 'package:provider/provider.dart';
import 'package:mood_pal/constants/mood_constants.dart';

class ZooScreen extends StatelessWidget {
  const ZooScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);
    final creatures = moodProvider.creatures.values.toList();
    
    // Sort by evolution level (highest first) and then by discovery date
    creatures.sort((a, b) {
      int levelCompare = b.evolutionLevel.compareTo(a.evolutionLevel);
      if (levelCompare != 0) return levelCompare;
      return b.discoveredAt.compareTo(a.discoveredAt);
    });
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Mood Zoo'),
      ),
      body: creatures.isEmpty 
          ? _buildEmptyState(context)
          : _buildCreatureGrid(context, creatures),
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
              Icons.pets_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Creatures Yet',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Check in with your emotions to discover new mood creatures for your collection!',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
         ElevatedButton(
  onPressed: () {
    // Instead of creating a new screen, navigate to index 0 (Home)
    Navigator.of(context).popUntil((route) => route.isFirst);
  },
  child: const Text('Go to Home'),
),
        ],
      ),
    );
  }

  Widget _buildCreatureGrid(BuildContext context, List<dynamic> creatures) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final creature = creatures[index];
                return CreatureCard(
                  creature: creature,
                  isCompact: true,
                  onTap: () {
                    _showCreatureDetails(context, creature);
                  },
                );
              },
              childCount: creatures.length,
            ),
          ),
        ),
      ],
    );
  }

  void _showCreatureDetails(BuildContext context, dynamic creature) {
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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: CreatureCard(creature: creature),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Evolution Progress',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: _getEvolutionProgress(creature),
                          backgroundColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                          color: MoodConstants.getMood(creature.moodType).color,
                          borderRadius: BorderRadius.circular(8),
                          minHeight: 10,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildEvolutionStage(context, 1, creature.evolutionLevel >= 1),
                            _buildEvolutionStage(context, 2, creature.evolutionLevel >= 2),
                            _buildEvolutionStage(context, 3, creature.evolutionLevel >= 3),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Creature Stats',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildStatRow(
                          context, 
                          'First Discovered', 
                          _formatDate(creature.discoveredAt),
                          Icons.calendar_today_rounded,
                        ),
                        _buildStatRow(
                          context, 
                          'Times Observed', 
                          creature.occurrenceCount.toString(),
                          Icons.visibility_rounded,
                        ),
                        _buildStatRow(
                          context, 
                          'Last Seen', 
                          _formatDate(creature.lastSeen),
                          Icons.access_time_rounded,
                        ),
                        _buildStatRow(
                          context, 
                          'Evolution Level', 
                          'Level ${creature.evolutionLevel} of 3',
                          Icons.star_rounded,
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEvolutionStage(BuildContext context, int stage, bool unlocked) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: unlocked 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              Icons.star_rounded,
              color: unlocked 
                  ? Theme.of(context).colorScheme.onPrimary 
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Level $stage',
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: unlocked ? FontWeight.bold : FontWeight.normal,
            color: unlocked 
                ? Theme.of(context).colorScheme.primary 
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _getEvolutionProgress(dynamic creature) {
    if (creature.evolutionLevel == 3) return 1.0;
    if (creature.evolutionLevel == 2) {
      // Progress between level 2 and 3 (15-30 occurrences)
      return 0.67 + (creature.occurrenceCount - 15) / (30 - 15) * 0.33;
    }
    if (creature.occurrenceCount >= 15) return 0.67; // Just reached level 2
    // Progress between level 1 and 2 (1-15 occurrences)
    return 0.33 + (creature.occurrenceCount - 1) / (15 - 1) * 0.34;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}