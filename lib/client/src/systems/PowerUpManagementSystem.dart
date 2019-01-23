part of breakout_client;

class PowerUpManagementSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  ComponentMapper powerup_mapper;
  ComponentMapper pos_mapper;
  ComponentMapper vel_mapper;
  ComponentMapper size_mapper;
  ComponentMapper color_mapper;

  PowerUpManagementSystem(BreakoutClientWorld world) : super(world) {
    components_wanted = new Set.from([PowerUp,]);

    powerup_mapper = world.component_mappers[PowerUp];
    pos_mapper = world.component_mappers[Position];
    vel_mapper = world.component_mappers[Velocity];
    size_mapper = world.component_mappers[Size];
    color_mapper = world.component_mappers[Color];
  }
  void initialize() {
    world.subscribe_event("NewPowerUpCreated", handle_newpowerup);
    world.subscribe_event("ServerPowerUpUpdate", handle_update);
    world.subscribe_event("PowerUpDeath", handle_death);
  }

  void handle_newpowerup(Map event) {
    int powerup = event['entity'];
    world.add_component(powerup, new Renderable("powerup"));
    world.add_component(powerup, new Position(event['position'][0],event['position'][1]));
    world.add_component(powerup, new Velocity(event['velocity'][0],event['velocity'][1]));
    world.add_component(powerup, new PowerUp(event['powerup']));
    world.add_component(powerup, new Size(event['size'][0],event['size'][1]));
    world.add_component(powerup, new Color(event['color']));
    world.add_component(powerup, new Collidable());
    world.add_to_world(powerup);
  }

  void handle_update(Map event) {
    if (!entities.contains(event['powerup'])) {
      return;
    }
    int e = event['powerup'];
    var pos = pos_mapper.get_component(e);
    var vel = vel_mapper.get_component(e);

    pos.x = event['position'][0];
    pos.y = event['position'][1];
    vel.x = event['velocity'][0];
    vel.y = event['velocity'][1];
  }

  void handle_death(Map event) {
    int entity = event['powerup'];
    world.remove_entity(entity);
  }
}
