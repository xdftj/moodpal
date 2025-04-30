import 'package:flutter/material.dart';
import 'package:mood_pal/constants/mood_constants.dart';

class MoodSelector extends StatelessWidget {
  final Function(String) onMoodSelected;
  
  const MoodSelector({
    Key? key,
    required this.onMoodSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'How are you feeling today?',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tap on a mood below',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          
          // Emoji mood grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
              childAspectRatio: 0.9,
            ),
            itemCount: MoodConstants.moodList.length,
            itemBuilder: (context, index) {
              final mood = MoodConstants.moodList[index];
              return AnimatedMoodButton(
                mood: mood,
                onPressed: () => onMoodSelected(mood.type),
              );
            },
          ),
        ],
      ),
    );
  }
}

class AnimatedMoodButton extends StatefulWidget {
  final MoodData mood;
  final VoidCallback onPressed;
  
  const AnimatedMoodButton({
    Key? key,
    required this.mood,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<AnimatedMoodButton> createState() => _AnimatedMoodButtonState();
}

class _AnimatedMoodButtonState extends State<AnimatedMoodButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
        _controller.forward();
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: _isHovered 
                  ? widget.mood.color.withOpacity(0.5)
                  : widget.mood.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              boxShadow: _isHovered ? [
                BoxShadow(
                  color: widget.mood.color.withOpacity(0.6),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ] : [],
              border: Border.all(
                color: widget.mood.color.withOpacity(_isHovered ? 0.8 : 0.3),
                width: _isHovered ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Emoji with a small shimmer effect when hovered
                Stack(
                  alignment: Alignment.center,
                  children: [
                    if (_isHovered)
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: widget.mood.color.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      widget.mood.emoji,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Label with styling
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? widget.mood.color.withOpacity(0.3)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.mood.label,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _isHovered
                          ? Colors.black87
                          : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}