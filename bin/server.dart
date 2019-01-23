import 'package:dart_breakout/server/breakout_server.dart';
import 'package:entity_component/entity_component_common.dart';


void main() {
  World w = create_server_world();

  w.start();
}
