library breakout_client;

import 'dart:html';
import 'dart:math';
import 'dart:collection';

import 'dart:convert';

import 'package:entity_component/entity_component_client.dart';
import 'package:entity_component/entity_component_common.dart';

part 'src/components.dart';

part 'src/systems/TestSystem.dart';
part 'src/systems/RenderSystem.dart';
part 'src/systems/InputSystem.dart';
part 'src/systems/EntitySpawnSystem.dart';
part 'src/systems/PlayerManagementSystem.dart';
part 'src/systems/BallManagementSystem.dart';
part 'src/systems/BrickManagementSystem.dart';
part 'src/systems/PaddleMoveSystem.dart';
part 'src/systems/BallMoveSystem.dart';
part 'src/systems/ClientNetworkSystem.dart';

part 'src/renderers/Renderer.dart';
part 'src/renderers/PaddleRenderer.dart';
part 'src/renderers/BallRenderer.dart';
part 'src/renderers/BrickRenderer.dart';

ClientWorld create_client_world() {
    ClientWorld world = new ClientWorld(component_types);

    // register systems
    //world.register_system(new EntitySpawnSystem(world));
    world.register_system(new ClientNetworkSystem(world));
    world.register_system(new RenderSystem(world));
    world.register_system(new InputSystem(world));
    world.register_system(new PaddleMoveSystem(world));
    world.register_system(new BallMoveSystem(world));
    world.register_system(new PlayerManagementSystem(world));
    world.register_system(new BallManagementSystem(world));
    world.register_system(new BrickManagementSystem(world));
    //world.register_system(new TestSystem(world));

    return world;
}
