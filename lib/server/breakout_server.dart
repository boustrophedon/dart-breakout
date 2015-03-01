library breakout_server;

import 'dart:io';
import 'dart:math';
import 'dart:collection';

import 'dart:convert';

import 'package:entity_component/entity_component_server.dart';
import 'package:entity_component/entity_component_common.dart';

part 'src/components.dart';

part 'src/systems/PlayerManagementSystem.dart';
part 'src/systems/PaddleMoveSystem.dart';
part 'src/systems/ServerNetworkSystem.dart';

ServerWorld create_server_world() {
    ServerWorld world = new ServerWorld(component_types);

    // register systems
    world.register_system(new ServerNetworkSystem(world));
    world.register_system(new PlayerManagementSystem(world));
    world.register_system(new PaddleMoveSystem(world));

    return world;
}
