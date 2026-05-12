import 'dart:io';

import 'package:flutter/material.dart';
import 'package:super_diploma/application/controllers/image_zoom_controller.dart';

class ImageMessageWidget extends StatelessWidget {
  final File imageFile;

  const ImageMessageWidget({super.key, required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => FullScreenImage(imageFile: imageFile),
          ),
        );
      },
      child: Hero(tag: imageFile.path, child: Image.file(imageFile)),
    );
  }
}

class FullScreenImage extends StatefulWidget {
  final File imageFile;

  const FullScreenImage({super.key, required this.imageFile});

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage>
    with SingleTickerProviderStateMixin {
  late ImageZoomController _controller;

  @override
  void initState() {
    _controller = ImageZoomController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: ValueListenableBuilder<bool>(
          valueListenable: _controller.isAppBarVisible,
          builder: (_, isVisible, _) {
            return AnimatedOpacity(
              opacity: isVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: !isVisible,
                child: AppBar(elevation: 0, backgroundColor: Colors.black45),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: GestureDetector(
          onTap: _controller.toggleInterface,
          onDoubleTapDown: (details) => _controller.tapDownDetails = details,
          onDoubleTap: _controller.handleDoubleTap,
          child: InteractiveViewer(
            transformationController: _controller.transformationController,
            clipBehavior: .none,
            minScale: _controller.minScale,
            maxScale: _controller.maxScale,
            child: Hero(
              tag: widget.imageFile.path,
              child: Image.file(widget.imageFile),
            ),
          ),
        ),
      ),
    );
  }
}
