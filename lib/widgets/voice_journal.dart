import 'package:flutter/material.dart';
import 'dart:async';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_sound/flutter_sound.dart';

class VoiceJournal extends StatefulWidget {
  final Function(String, String?) onJournalComplete;
  
  const VoiceJournal({
    Key? key,
    required this.onJournalComplete,
  }) : super(key: key);

  @override
  State<VoiceJournal> createState() => _VoiceJournalState();
}

class _VoiceJournalState extends State<VoiceJournal> with SingleTickerProviderStateMixin {
  final _audioRecorder = Record();
  final _textController = TextEditingController();
  final _player = FlutterSoundPlayer();
  
  bool _isRecording = false;
  bool _hasRecording = false;
  String? _recordingPath;
  int _recordingDuration = 0;
  Timer? _timer;
  
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _player.openPlayer();
    
    // Initialize pulse animation for recording
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _textController.dispose();
    _audioRecorder.dispose();
    _player.closePlayer();
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        _recordingPath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(
          path: _recordingPath,
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          samplingRate: 44100,
        );

        setState(() {
          _isRecording = true;
          _recordingDuration = 0;
          _hasRecording = false;
        });

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordingDuration++;
          });
        });
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      await _audioRecorder.stop();
      _timer?.cancel();
      
      setState(() {
        _isRecording = false;
        _hasRecording = true;
      });
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  Future<void> _playRecording() async {
    if (_recordingPath != null && File(_recordingPath!).existsSync()) {
      await _player.startPlayer(
        fromURI: _recordingPath,
        whenFinished: () {
          setState(() {});
        },
      );
    }
  }

  Future<void> _stopPlayback() async {
    await _player.stopPlayer();
    setState(() {});
  }

  void _submitJournal() {
    widget.onJournalComplete(_textController.text, _recordingPath);
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  
  @override
  Widget build(BuildContext context) {
    final isPlayerActive = _player.isPlaying;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What\'s on your mind?',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          
          // Text input field
          TextField(
            controller: _textController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Share your thoughts here...',
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.background,
            ),
          ),
          
          const SizedBox(height: 20),
          Text(
            'Or leave a voice note:',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          
          // Voice recording UI
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                if (_isRecording)
                  Expanded(
                    child: Row(
                      children: [
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _pulseAnimation.value,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Recording... ${_formatDuration(_recordingDuration)}',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_hasRecording)
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          isPlayerActive ? Icons.pause : Icons.play_arrow,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isPlayerActive 
                              ? 'Playing...' 
                              : 'Voice note (${_formatDuration(_recordingDuration)})',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Expanded(
                    child: Text(
                      'Tap the mic icon to start recording',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                
                const SizedBox(width: 8),
                
                // Recording controls
                if (_isRecording)
                  _buildControlButton(
                    onPressed: _stopRecording,
                    icon: Icons.stop_rounded,
                    color: Theme.of(context).colorScheme.error,
                  )
                else if (_hasRecording && !isPlayerActive)
                  _buildControlButton(
                    onPressed: _playRecording,
                    icon: Icons.play_arrow_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  )
                else if (isPlayerActive)
                  _buildControlButton(
                    onPressed: _stopPlayback,
                    icon: Icons.pause_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  )
                else
                  _buildControlButton(
                    onPressed: _startRecording,
                    icon: Icons.mic_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Submit button
          SizedBox(
            width: double.infinity,
            height: 56, // Make button taller and more visible
            child: ElevatedButton(
              onPressed: _submitJournal, // Allow submission regardless of content
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send_rounded, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'Share with MoodPal',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildControlButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
      ),
    );
  }
}