library breakout;

import 'dart:html';
import 'dart:math' as math;

import 'package:entity_component/entity_component.dart';

part 'src/components.dart';

part 'src/systems/TestSystem.dart';


World create_world() {
    World world = new World();

    // register systems
    world.register_system(new TestSystem(world));

    return world;
}
