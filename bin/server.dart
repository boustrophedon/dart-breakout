import 'package:dart_breakout/server/breakout_server.dart';
import 'package:entity_component/entity_component_server.dart';
import 'package:entity_component/entity_component_common.dart';

import 'dart:io';

void main() {
  World w = create_server_world();

  w.start();
}
