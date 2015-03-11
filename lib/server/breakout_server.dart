library breakout_server;

import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:collection';

import 'dart:convert';

import 'package:entity_component/entity_component_server.dart';
import 'package:entity_component/entity_component_common.dart';

import 'package:dart_breakout/common/breakout_common.dart';

part 'src/systems/PlayerManagementSystem.dart';
part 'src/systems/BallManagementSystem.dart';
part 'src/systems/BrickManagementSystem.dart';
part 'src/systems/PowerUpManagementSystem.dart';
part 'src/systems/PaddleMoveSystem.dart';
part 'src/systems/VelocityMoveSystem.dart';
part 'src/systems/CollisionSystem.dart';
part 'src/systems/ServerNetworkSystem.dart';

class BreakoutServerWorld extends ServerWorld {
  Map<int, WebSocket> clients;
  BreakoutServerWorld() : super(component_types) {}
}

ServerWorld create_server_world() {
    ServerWorld world = new BreakoutServerWorld();

    // register systems
    world.register_system(new ServerNetworkSystem(world));
    world.register_system(new PlayerManagementSystem(world));
    world.register_system(new BallManagementSystem(world));
    world.register_system(new BrickManagementSystem(world));
    world.register_system(new PowerUpManagementSystem(world));
    world.register_system(new PaddleMoveSystem(world));
    world.register_system(new VelocityMoveSystem(world));
    world.register_system(new CollisionSystem(world));

    return world;
}
