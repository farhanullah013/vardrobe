import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class arviewscreen extends StatefulWidget {
  const arviewscreen({this.image});

  @override
  _arviewscreenState createState() => _arviewscreenState();
  final String image;
}

class _arviewscreenState extends State<arviewscreen> {
  ArCoreController arCoreController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableTapRecognizer: true,
        ),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController.onPlaneTap = _handleOnPlaneTap;
  }

  Future _addImage(ArCoreHitTestResult hit) async {
    final bytes =
        (await rootBundle.load('Assets/images/${widget.image}')).buffer.asUint8List();

    final earth =ArCoreNode(
      image: ArCoreImage(bytes: bytes, width: widget.image!="cap.png"?300:250, height:widget.image!="cap.png"?300:250),
      position: hit.pose.translation + vector.Vector3(0.0, 0.0, 0.0),
      rotation: hit.pose.rotation + vector.Vector4(0.0, 0.0, 0.0, 0.0),
    );

    arCoreController.addArCoreNodeWithAnchor(earth);
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) {
    final hit = hits.first;
    _addImage(hit);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
}
