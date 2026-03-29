import 'package:flutter/cupertino.dart';

class ImageZoomController {
  final TickerProvider vsync;
  final TransformationController transformationController =
      TransformationController();
  final ValueNotifier<bool> isAppBarVisible = ValueNotifier<bool>(true);

  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  TapDownDetails? tapDownDetails;

  double get minScale => 1;

  double get maxScale => 4;

  ImageZoomController({required this.vsync}) {
    _animationController =
        AnimationController(
          vsync: vsync,
          duration: const Duration(milliseconds: 200),
        )..addListener(() {
          transformationController.value = _animation!.value;
        });
  }

  void toggleInterface() {
    isAppBarVisible.value = !isAppBarVisible.value;
  }

  void handleDoubleTap() {
    if (transformationController.value != Matrix4.identity()) {
      _resetAnimation();
    } else {
      _zoomToPosition();
    }
  }

  void _zoomToPosition() {
    if (tapDownDetails == null) return;

    final position = tapDownDetails!.localPosition;
    const double scale = 3.0;

    final x = -position.dx * (scale - 1);
    final y = -position.dy * (scale - 1);

    final zoomedMatrix = Matrix4.identity()
      ..translate(x, y)
      ..scale(scale);

    _runAnimation(zoomedMatrix);
  }

  void _resetAnimation() {
    _runAnimation(Matrix4.identity());
  }

  void _runAnimation(Matrix4 targetMatrix) {
    _animation =
        Matrix4Tween(
          begin: transformationController.value,
          end: targetMatrix,
        ).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward(from: 0);
  }

  void dispose() {
    transformationController.dispose();
    isAppBarVisible.dispose();
    _animationController.dispose();
  }
}
