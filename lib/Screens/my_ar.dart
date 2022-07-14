import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class my_ar extends StatefulWidget {
  @override
  _my_arState createState() => _my_arState();
}

class _my_arState extends State<my_ar> {
  ArCoreController arCoreController;

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ArCoreView(
        onArCoreViewCreated: _onarcoreviewcreated,
      ),
    );
  }

  void _onarcoreviewcreated(ArCoreController controller) {
    arCoreController=controller;
    _addsphere(arCoreController);

  }

  void _addsphere(ArCoreController controller){
    final material=ArCoreMaterial(color: Colors.yellowAccent);
    final sphere=ArCoreSphere(materials: [material],radius: 0.24);
    final node=ArCoreNode(shape: sphere,position: vector.Vector3(0,0,-1));
    controller.addArCoreNode(node);
  }
}
