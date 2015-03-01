part of breakout_client;

class EntitySpawnSystem extends System {
  Map <String, Function> spawn_map;
  EntitySpawnSystem(World world) : super(world) {
    components_wanted = null;

    spawn_map = new Map<String,Function>();

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

}
