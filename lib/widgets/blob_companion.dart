import 'package:flutter/material.dart';
import 'dart:math' as math;

class BlobCompanion extends StatefulWidget {
  final String currentMood;
  final String? responseText;
  final bool isListening;
  final bool isThinking;
  final VoidCallback? onTap;
  
  const BlobCompanion({
    Key? key,
    this.currentMood = 'neutral',
    this.responseText,
    this.isListening = false,
    this.isThinking = false,
    this.onTap,
  }) : super(key: key);

  @override
  State<BlobCompanion> createState() => _BlobCompanionState();
}

class _BlobCompanionState extends State<BlobCompanion> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _scaleAnimation;
  bool _isBlinking = false;
  
  @override
  void initState() {
    super.initState();
    
    // Setup animations
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    // Start blinking randomly
    _setupBlinking();
  }
  
  void _setupBlinking() {
    Future.delayed(Duration(milliseconds: math.Random().nextInt(3000) + 1000), () {
      if (mounted) {
        setState(() {
          _isBlinking = true;
        });
        
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) {
            setState(() {
              _isBlinking = false;
            });
            _setupBlinking();
          }
        });
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Response bubble (if any)
          if (widget.responseText != null) ...[
            _buildResponseBubble(context),
            const SizedBox(height: 8),
          ],
          
          // The animated blob
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _floatAnimation.value),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Main blob body
                _buildBlobBody(),
                
                // Eyes
                Positioned(
                  top: 50,
                  left: 45,
                  child: _buildEye(left: true),
                ),
                Positioned(
                  top: 50,
                  right: 45,
                  child: _buildEye(left: false),
                ),
                
                // Mouth
                Positioned(
                  bottom: 55,
                  child: _buildMouth(),
                ),
                
                // Listening indicator
                if (widget.isListening)
                  Positioned(
                    right: 30,
                    top: 30,
                    child: _buildListeningIndicator(),
                  ),
                
                // Thinking animation
                if (widget.isThinking)
                  Positioned(
                    top: 20,
                    child: _buildThinkingAnimation(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildBlobBody() {
    // Color based on mood
    Color blobColor;
    switch (widget.currentMood) {
      case 'happy':
        blobColor = const Color(0xFFFFD700);
        break;
      case 'sad':
        blobColor = const Color(0xFF6699CC);
        break;
      case 'angry':
        blobColor = const Color(0xFFFF6B6B);
        break;
      case 'anxious':
        blobColor = const Color(0xFFFF9F45);
        break;
      case 'calm':
        blobColor = const Color(0xFF88D8B0);
        break;
      case 'excited':
        blobColor = const Color(0xFFFF85A2);
        break;
      case 'tired':
        blobColor = const Color(0xFF9D8DF1);
        break;
      default:
        blobColor = const Color(0xFF9370DB); // Default purple
    }
    
    return Stack(
      alignment: Alignment.center,
      children: [
        // Blob body with more character-like shape
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: blobColor,
            borderRadius: BorderRadius.circular(90),
            boxShadow: [
              BoxShadow(
                color: blobColor.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        
        // Character details - little stubby arms
        Positioned(
          left: 30,
          child: Container(
            width: 40,
            height: 20,
            decoration: BoxDecoration(
              color: blobColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                topRight: Radius.circular(5),
                bottomRight: Radius.circular(5),
              ),
            ),
          ),
        ),
        
        Positioned(
          right: 30,
          child: Container(
            width: 40,
            height: 20,
            decoration: BoxDecoration(
              color: blobColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
            ),
          ),
        ),
        
        // Little feet/base
        Positioned(
          bottom: 10,
          left: 60,
          child: Container(
            width: 25,
            height: 15,
            decoration: BoxDecoration(
              color: blobColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
        ),
        
        Positioned(
          bottom: 10,
          right: 60,
          child: Container(
            width: 25,
            height: 15,
            decoration: BoxDecoration(
              color: blobColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            ),
          ),
        ),
        
        // Small details to make character more unique
        if (widget.currentMood == 'happy' || widget.currentMood == 'excited')
          Positioned(
            top: 15,
            child: Container(
              width: 40,
              height: 20,
              decoration: BoxDecoration(
                color: blobColor.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          
        if (widget.currentMood == 'sad' || widget.currentMood == 'tired')
          Positioned(
            top: 30,
            left: 30,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 30,
                height: 15,
                decoration: BoxDecoration(
                  color: blobColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
          ),
          
        if (widget.currentMood == 'angry')
          Positioned(
            top: 20,
            child: Transform.rotate(
              angle: 0.2,
              child: Container(
                width: 50,
                height: 15,
                decoration: BoxDecoration(
                  color: blobColor.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ),
          ),
          
        // Cute little blush when excited or happy
        if (widget.currentMood == 'excited' || widget.currentMood == 'happy')
          Positioned(
            bottom: 70,
            left: 40,
            child: Container(
              width: 20,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.3),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          
        if (widget.currentMood == 'excited' || widget.currentMood == 'happy')
          Positioned(
            bottom: 70,
            right: 40,
            child: Container(
              width: 20,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.pink.withOpacity(0.3),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
      ],
    );
  }
  
  Widget _buildEye({required bool left}) {
    final eyeSize = _isBlinking ? 3.0 : 30.0;
    
    // Different eye styles based on mood
    if (widget.currentMood == 'happy' || widget.currentMood == 'excited') {
      // Happy eyes - slightly squinted when not blinking
      return Container(
        width: 30,
        height: _isBlinking ? 3 : 25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: !_isBlinking ? Center(
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ) : null,
      );
    } else if (widget.currentMood == 'sad' || widget.currentMood == 'tired') {
      // Droopy sad eyes
      return Container(
        width: 30,
        height: _isBlinking ? 3 : 25,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(left ? 5 : 15),
            bottomRight: Radius.circular(left ? 15 : 5),
          ),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: !_isBlinking ? Center(
          child: Transform.translate(
            offset: Offset(left ? -3 : 3, 2),
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ) : null,
      );
    } else if (widget.currentMood == 'angry') {
      // Angry eyes - angled brows
      return Stack(
        children: [
          Container(
            width: 30,
            height: _isBlinking ? 3 : 25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: !_isBlinking ? Center(
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
              ),
            ) : null,
          ),
          // Angry eyebrow
          if (!_isBlinking)
            Positioned(
              top: -8,
              left: left ? -5 : 5,
              child: Transform.rotate(
                angle: left ? -0.5 : 0.5,
                child: Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
        ],
      );
    } else if (widget.currentMood == 'anxious') {
      // Anxious eyes - wide and worried
      return Container(
        width: 35,
        height: _isBlinking ? 3 : 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17.5),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: !_isBlinking ? Center(
          child: Transform.translate(
            offset: const Offset(0, -2),
            child: Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ) : null,
      );
    } else {
      // Default calm eyes
      return Container(
        width: 30,
        height: _isBlinking ? 3 : 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: !_isBlinking ? Center(
          child: Container(
            width: 15,
            height: 15,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        ) : null,
      );
    }
  }
  
  Widget _buildMouth() {
    if (widget.currentMood == 'happy' || widget.currentMood == 'excited') {
      // Happy smile with cute cartoon style
      return Container(
        width: 60,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ),
      );
    } else if (widget.currentMood == 'sad' || widget.currentMood == 'tired') {
      // Sad frown, more pronounced
      return Transform.rotate(
        angle: 3.14, // 180 degrees in radians
        child: Container(
          width: 60,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
        ),
      );
    } else if (widget.currentMood == 'angry') {
      // Angry zigzag mouth
      return SizedBox(
        width: 60,
        height: 20,
        child: CustomPaint(
          painter: AngryMouthPainter(),
        ),
      );
    } else if (widget.currentMood == 'anxious') {
      // Anxious wavy mouth
      return SizedBox(
        width: 50,
        height: 15,
        child: CustomPaint(
          painter: AnxiousMouthPainter(),
        ),
      );
    } else {
      // Neutral or calm mouth - small smile
      return Container(
        width: 40,
        height: 5,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }
  }
  
  Widget _buildListeningIndicator() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: const Icon(
        Icons.mic,
        size: 18,
        color: Colors.red,
      ),
    );
  }
  
  Widget _buildThinkingAnimation() {
    return SizedBox(
      width: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildThinkingDot(0),
          _buildThinkingDot(1),
          _buildThinkingDot(2),
        ],
      ),
    );
  }
  
  Widget _buildThinkingDot(int index) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = index / 3;
        final value = (((_controller.value - delay) % 1.0) < 0.5) ? 
                     ((_controller.value - delay) % 0.5) * 2 : 
                     1.0 - (((_controller.value - delay) % 0.5) * 2);
        
        return Transform.scale(
          scale: 0.5 + value * 0.5,
          child: Opacity(
            opacity: 0.5 + value * 0.5,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildResponseBubble(BuildContext context) {
    // Choose bubble style based on mood
    Color bubbleColor;
    BorderRadius bubbleRadius;
    
    switch (widget.currentMood) {
      case 'happy':
      case 'excited':
        bubbleColor = const Color(0xFFFFE082); // Light yellow
        bubbleRadius = BorderRadius.circular(20);
        break;
      case 'sad':
      case 'tired':
        bubbleColor = const Color(0xFFBBDEFB); // Light blue
        bubbleRadius = BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(20),
        );
        break;
      case 'angry':
        bubbleColor = const Color(0xFFFFCCBC); // Light orange
        bubbleRadius = BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        );
        break;
      case 'anxious':
        bubbleColor = const Color(0xFFFFE0B2); // Light orange
        bubbleRadius = BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        );
        break;
      default:
        bubbleColor = Colors.white;
        bubbleRadius = BorderRadius.circular(20);
    }
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: bubbleRadius,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(
          color: widget.currentMood == 'angry' 
              ? const Color(0xFFFF6B6B).withOpacity(0.3)
              : bubbleColor.withOpacity(0.8),
          width: widget.currentMood == 'angry' ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add emoji based on mood
          if (widget.currentMood == 'happy' || widget.currentMood == 'excited')
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '✨',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            
          if (widget.currentMood == 'sad' || widget.currentMood == 'tired')
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '💙',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            
          if (widget.currentMood == 'angry')
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '💪',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            
          if (widget.currentMood == 'anxious')
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '🌱',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            
          if (widget.currentMood == 'calm')
            Align(
              alignment: Alignment.topRight,
              child: Text(
                '✌️',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          
          // Main response text
          Text(
            widget.responseText!,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: widget.currentMood == 'excited' ? FontWeight.bold : FontWeight.normal,
              fontStyle: widget.currentMood == 'sad' ? FontStyle.italic : FontStyle.normal,
            ),
            textAlign: TextAlign.left,
          ),
          
          // Triangle pointing down to the blob
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                width: 20,
                height: 15,
                color: bubbleColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the angry zigzag mouth
class AngryMouthPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
      
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width * 0.25, 0);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(size.width * 0.75, 0);
    path.lineTo(size.width, size.height / 2);
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for anxious wavy mouth
class AnxiousMouthPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
      
    final path = Path();
    path.moveTo(0, size.height / 2);
    
    // Draw a wavy line
    for (int i = 0; i < 5; i++) {
      if (i % 2 == 0) {
        path.quadraticBezierTo(
          size.width * (i + 0.5) / 5, 
          0, 
          size.width * (i + 1) / 5, 
          size.height / 2
        );
      } else {
        path.quadraticBezierTo(
          size.width * (i + 0.5) / 5, 
          size.height, 
          size.width * (i + 1) / 5, 
          size.height / 2
        );
      }
    }
    
    canvas.drawPath(path, paint);
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom clipper for the triangle pointer
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}