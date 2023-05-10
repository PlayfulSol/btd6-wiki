import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModelPopup extends StatelessWidget {
  final String modelUrl;

  final String? modelName;

  const ModelPopup({super.key, required this.modelUrl, this.modelName});

  @override
  Widget build(BuildContext context) {
    return ModelViewer(
      src: 'modelUrl',
      alt: modelName ?? 'Model',
      ar: true,
      autoRotate: true,
      cameraControls: true,
    );
  }
}
