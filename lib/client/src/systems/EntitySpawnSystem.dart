part of breakout_client;

class EntitySpawnSystem extends System {
  Map <String, Function> spawn_map;
  EntitySpawnSystem(World world) : super(world) {
    components_wanted = null;

    spawn_map = new Map<String,Function>();
    spawn_map["paddle"] = spawn_paddle;

  }

  void initialize() {
    world.subscribe_event("SpawnEntity", handle_spawn);
  }

  void handle_spawn(Map event) {
    Function spawn_function = spawn_map[event['type']];
    if (spawn_function != null) {
      spawn_function(event);
    }
  }

  void spawn_paddle(Map event) {
    Entity paddle;
    if (event.containsKey('id')) {
      paddle = world.new_entity(event["id"]);
    }
    else {
      paddle = world.new_entity();
    }
    paddle.add_component(new Renderable("paddle"));
    paddle.add_component(new Position(200, 200));
    paddle.add_component(new Velocity(0, 0));
    paddle.add_component(new Moveable());
    paddle.add_component(new Size(80, 20));
    paddle.add_to_world();
  }
}
