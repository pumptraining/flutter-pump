import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_flow/flutter_flow_animations.dart';
import 'package:go_router/go_router.dart';
import '../flutter_flow_video_player.dart';

class Utils {
  static final defaultaAnimation = AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 0.ms,
        duration: 600.ms,
        begin: 0.0,
        end: 1.0,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 0.ms,
        duration: 600.ms,
        begin: Offset(0.0, 50.0),
        end: Offset(0.0, 0.0),
      ),
    ],
  );

  static double getTopSafeArea(BuildContext context) {
    EdgeInsets safePadding = MediaQuery.of(context).padding;
    bool hasSafeArea = safePadding.top > 0;
    return hasSafeArea ? safePadding.top : 0.0;
  }

  static double getBottomSafeArea(BuildContext context) {
    EdgeInsets safePadding = MediaQuery.of(context).padding;
    bool hasSafeArea = safePadding.bottom > 0;
    return hasSafeArea ? safePadding.bottom : 0.0;
  }

  static void showExerciseVideo(BuildContext context, String videoUrl) {
    showModalBottomSheet(
        useSafeArea: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (bottomSheetContext) {
          return Padding(
              padding: MediaQuery.of(bottomSheetContext).viewInsets,
              child: GestureDetector(
                  onHorizontalDragDown: (details) {
                    context.pop();
                  },
                  child: FlutterFlowVideoPlayer(
                    height: MediaQuery.of(context).size.height,
                    path: videoUrl,
                    videoType: VideoType.network,
                    autoPlay: true,
                    looping: true,
                    showControls: false,
                    allowFullScreen: true,
                    allowPlaybackSpeedMenu: false,
                  )));
        });
  }
}
