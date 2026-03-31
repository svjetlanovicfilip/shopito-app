import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shopito_app/main.dart';
import 'package:shopito_app/presentation/widgets/M/loader.dart';
import 'package:video_player/video_player.dart';

class ProductVideoSection extends StatefulWidget {
  final String videoUrl;
  const ProductVideoSection({super.key, required this.videoUrl});

  @override
  State<ProductVideoSection> createState() => _ProductVideoSectionState();
}

class _ProductVideoSectionState extends State<ProductVideoSection> {
  late VideoPlayerController _controller;
  bool _isMuted = false;
  bool _isPlaying = false;
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          widget.videoUrl.contains('http')
              ? widget.videoUrl
              : '$baseImageUrl${widget.videoUrl}',
        ),
      )
      ..initialize().then((_) {
        setState(() {});
      });

    _controller.addListener(() {
      final playing = _controller.value.isPlaying;
      if (playing != _isPlaying) {
        setState(() {
          _isPlaying = playing;
        });
      }
    });
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_isPlaying && _showControls) {
      _startHideControlsTimer();
    } else {
      _cancelHideControlsTimer();
    }
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() {
        _showControls = true;
      });
      _cancelHideControlsTimer();
    } else {
      _controller.play();
      setState(() {
        _showControls = false; // hide immediately when playback starts
      });
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _showControls = false;
      });
    });
  }

  void _cancelHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Video',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        if (_controller.value.isInitialized) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: <Widget>[
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _toggleControlsVisibility,
                    child: const SizedBox.shrink(),
                  ),
                ),
                if (_showControls)
                  Positioned.fill(child: Container(color: Colors.black26)),
                // Center play/pause button (only when controls are visible)
                if (_showControls)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Color(0x99000000),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          iconSize: 60,
                          color: Colors.white,
                          icon: Icon(
                            _controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                          onPressed: _togglePlayPause,
                        ),
                      ),
                    ),
                  ),
                // Mute button (top-right), only when controls visible
                if (_showControls)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color(0x99000000),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _isMuted = !_isMuted;
                            _controller.setVolume(_isMuted ? 0 : 1);
                          });
                        },
                        icon: Icon(
                          _isMuted ? Icons.volume_off : Icons.volume_up,
                        ),
                      ),
                    ),
                  ),
                // Progress indicator (bottom), only when controls visible
                if (_showControls)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 6,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ] else ...[
          const Center(child: Loader()),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }
}

// Removed old _ControlsOverlay to simplify inline controls.
