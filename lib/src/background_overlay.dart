library flutter_speed_dial;

import 'dart:ui';

import 'package:flutter/material.dart';
import 'global_key_extension.dart';

class BackgroundOverlay extends AnimatedWidget {
  final GlobalKey dialKey;
  final LayerLink layerLink;
  final ShapeBorder shape;
  final VoidCallback? onTap;
  final bool closeManually;
  final Widget child;

  const BackgroundOverlay({
    Key? key,
    this.onTap,
    required this.shape,
    required Animation<double> animation,
    required this.dialKey,
    required this.layerLink,
    required this.closeManually,
    required this.child,
  }) : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: () {
        return Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: closeManually ? null : onTap,
              child: BackdropFilter(
                blendMode: BlendMode.srcATop,
                filter: ImageFilter.blur(
                  sigmaX: 5 * animation.value,
                  sigmaY: 5 * animation.value,
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.white.withOpacity(0.36),
                    Colors.white.withOpacity(0.4),
                  ])),
                ),
              ),
            ),
            Positioned(
              width: dialKey.globalPaintBounds?.size.width,
              child: CompositedTransformFollower(
                link: layerLink,
                showWhenUnlinked: false,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: dialKey.globalPaintBounds?.size.width,
                    height: dialKey.globalPaintBounds?.size.height,
                    decoration: const ShapeDecoration(
                      shape: StadiumBorder(),
                      color: Colors.white,
                    ),
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        );
      }(),
    );
  }
}
