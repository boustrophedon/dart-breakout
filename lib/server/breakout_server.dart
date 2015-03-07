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
part 'src/systems/PaddleMoveSystem.dart';
part 'src/systems/BallMoveSystem.dart';
part 'src/systems/CollisionSystem.dart';
part 'src/systems/ServerNetworkSystem.dart';

ServerWorld create_server_world() {
    ServerWorld world = new ServerWorld(component_types);

    // register systems
    world.register_system(new ServerNetworkSystem(world));
    world.register_system(new PlayerManagementSystem(world));
    world.register_system(new BallManagementSystem(world));
    world.register_system(new BrickManagementSystem(world));
    world.register_system(new PaddleMoveSystem(world));
    world.register_system(new BallMoveSystem(world));
    world.register_system(new CollisionSystem(world));

    return world;
}
