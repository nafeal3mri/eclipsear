import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Tap-to-play/pause overlay with a styled play button that matches
/// the app's deep-space identity.
///
/// Uses [ValueListenableBuilder] so the play/pause icon always reflects
/// the current playback state without needing a StatefulWidget.
class ControlsOverlay extends StatelessWidget {
  const ControlsOverlay({
    super.key,
    required this.controller,
    this.accentColor = const Color(0xFFC49A6C),
  });

  final VideoPlayerController controller;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        return Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () =>
                  value.isPlaying ? controller.pause() : controller.play(),
              child: const SizedBox.expand(),
            ),

            // ── Play button — only shown when paused
            if (!value.isPlaying)
              Center(
                child: GestureDetector(
                  onTap: controller.play,
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withOpacity(0.88),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.55),
                          blurRadius: 22,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
              ),

            // ── Buffering spinner
            if (value.isBuffering)
              Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    color: accentColor,
                    strokeWidth: 2,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
