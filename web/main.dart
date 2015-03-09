import 'package:dart_breakout/client/breakout_client.dart';
import 'package:entity_component/entity_component_client.dart';

import 'dart:html';

void main() {
  BreakoutClientWorld w = create_client_world();

  CanvasElement canvas = querySelector('#area');
  // make the canvas the full size of the window
  canvas.height = 720;
  canvas.width = 720;

  w.canvas = canvas;

  w.start();
}
