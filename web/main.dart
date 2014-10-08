import 'package:dart_breakout/breakout.dart';
import 'package:entity_component/entity_component.dart';

import 'dart:html';

void main() {
  World w = create_world();

  CanvasElement canvas = querySelector('#area');
  // make the canvas the full size of the window
  canvas.height = 720;
  canvas.width = 1280;

  w.globaldata['canvas'] = canvas;

  w.run();
}
