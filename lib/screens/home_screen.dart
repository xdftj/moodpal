import 'package:flutter/material.dart';
import 'package:mood_pal/constants/mood_constants.dart';
import 'package:mood_pal/providers/mood_provider.dart';
import 'package:mood_pal/widgets/blob_companion.dart';
import 'package:mood_pal/widgets/mood_selector.dart';
import 'package:mood_pal/widgets/streak_counter.dart';
import 'package:mood_pal/widgets/voice_journal.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String? _selectedMood;
  bool _showJournal = false;
  bool _isProcessing = false;
  String? _blobResponse;
  late AnimationController _animationController;
  late Animation<double> _backgroundOpacityAnimation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _backgroundOpacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
    
    _animationController.forward();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Sample responses for the blob - in a real app, this would come from an AI service
  final Map<String, List<String>> _sampleResponses = {
    'happy': [
      "Your happiness is contagious! What's bringing you joy today?",
      "I'm so glad you're feeling happy! It's a beautiful energy to carry.",
      "Happiness looks good on you! Let's celebrate this moment!"
    ],
    'sad': [
      "I'm here for you during these sad moments. What's weighing on your heart?",
      "It's okay to feel sad sometimes. Would you like to talk about it?",
      "I'm sending you gentle comfort. Remember that all feelings eventually pass."
    ],
    'angry': [
      "I see you're feeling angry. Would taking a few deep breaths help?",
      "Anger is often protecting something important to you. What matters are you defending?",
      "I'm here to listen if you want to vent about what triggered this feeling."
    ],
    'anxious': [
      "Feeling anxious is challenging. Is there something specific on your mind?",
      "I notice you're anxious today. Let's take things one small step at a time.",
      "Anxiety is like a weather system passing through you - it will change and shift."
    ],
    'calm': [
      "What a peaceful state to be in! How did you find this calm?",
      "I love when you're feeling calm. It's like a quiet lake reflecting the sky.",
      "Calmness is such a gift. What will you do with this peaceful energy?"
    ],
    'excited': [
      "Your excitement is bubbling over! What's got you so thrilled?",
      "I can feel your excitement! What wonderful possibilities are you seeing?",
      "Excitement is such an energizing feeling! What are you looking forward to?"
    ],
    'tired': [
      "Feeling tired is your body's way of asking for rest. Can you honor that today?",
      "I notice you're tired. Remember it's okay to slow down and recharge.",
      "Tiredness reminds us we're human. What kind of rest might feel good right now?"
    ],
  };
  
  String _getRandomResponse(String mood) {
    final responses = _sampleResponses[mood] ?? _sampleResponses['happy']!;
    return responses[DateTime.now().millisecondsSinceEpoch % responses.length];
  }

  @override
  Widget build(BuildContext context) {
    final moodProvider = Provider.of<MoodProvider>(context);
    final currentDayEntry = moodProvider.currentDayEntry;
    final currentMood = currentDayEntry?.moodType ?? 'neutral';
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: StreakCounter(streakCount: moodProvider.streakCount),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Theme.of(context).colorScheme.primary.withOpacity(0.1),
                ],
              ),
            ),
            child: Opacity(
              opacity: _backgroundOpacityAnimation.value,
              child: child,
            ),
          );
        },
        child: SafeArea(
          child: Stack(
            children: [
              // Background decorative elements
              _buildBackgroundElements(),
              
              // Main content
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      
                      // Greeting text
                      Text(
                        currentDayEntry != null
                            ? 'Welcome back!'
                            : 'How are you feeling today?',
                        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Blob companion
                      BlobCompanion(
                        currentMood: currentMood,
                        responseText: _blobResponse,
                        isListening: _showJournal && !_isProcessing,
                        isThinking: _isProcessing,
                        onTap: () {
                          // Easter egg: tap the blob to get a random message
                          if (currentDayEntry != null && _blobResponse == null) {
                            setState(() {
                              _blobResponse = _getRandomResponse(currentDayEntry.moodType);
                            });
                          }
                        },
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Show mood selector if no entry for today
                      if (currentDayEntry == null && !_showJournal) ...[
                        // Mood selector
                        MoodSelector(
                          onMoodSelected: (moodType) {
                            setState(() {
                              _selectedMood = moodType;
                              _showJournal = true;
                            });
                          },
                        ),
                      ],
                      
                  // Show journal if mood is selected
                      if (_showJournal && _selectedMood != null) ...[
                        const SizedBox(height: 20),
                        VoiceJournal(
                          onJournalComplete: (journalText, audioUrl) async {
                            // Show thinking animation
                            setState(() {
                              _isProcessing = true;
                            });
                            
                            // Simulate AI processing delay
                            await Future.delayed(const Duration(seconds: 2));
                            
                            // Get a response from the blob
                            final response = _getRandomResponse(_selectedMood!);
                            
                            // Add mood entry and show response
                            moodProvider.addMoodEntry(_selectedMood!, journalText.isEmpty ? null : journalText, audioUrl);
                            
                            setState(() {
                              _isProcessing = false;
                              _showJournal = false;
                              _blobResponse = response;
                            });
                          },
                        ),
                      ],
                      
                      // Show current mood if already logged today
                      if (currentDayEntry != null && !_showJournal) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Today's Mood",
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    MoodConstants.getMood(currentDayEntry.moodType).emoji,
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    MoodConstants.getMood(currentDayEntry.moodType).label,
                                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                      color: MoodConstants.getMood(currentDayEntry.moodType).color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              if (currentDayEntry.journalText != null) ...[
                                const SizedBox(height: 12),
                                Text(
                                  currentDayEntry.journalText!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                              const SizedBox(height: 16),
                              OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    _selectedMood = currentDayEntry.moodType;
                                    _showJournal = true;
                                    _blobResponse = null;
                                  });
                                },
                                child: const Text('Update Journal'),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildBackgroundElements() {
    return Stack(
      children: [
        // Top left decoration
        Positioned(
          top: 40,
          left: -30,
          child: Opacity(
            opacity: 0.2,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        
        // Bottom right decoration
        Positioned(
          bottom: 60,
          right: -20,
          child: Opacity(
            opacity: 0.15,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        
        // Middle decoration
        Positioned(
          top: MediaQuery.of(context).size.height * 0.4,
          left: MediaQuery.of(context).size.width * 0.7,
          child: Opacity(
            opacity: 0.1,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}