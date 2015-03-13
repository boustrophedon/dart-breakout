part of breakout_server;

class PowerUpManagementSystem extends System {

  static int POWERUP_WIDTH = 60;
  static int POWERUP_HEIGHT = 15;

  ComponentMapper<Position> posmap;
  ComponentMapper<Velocity> velmap;
  ComponentMapper<PowerUp> powermap;

  PowerUpManagementSystem(BreakoutServerWorld world) : super(world) {
    components_wanted = new Set.from([PowerUp,]);

    posmap = world.component_mappers[Position];
    velmap = world.component_mappers[Velocity];
    powermap = world.component_mappers[PowerUp];
  }
  void initialize() {
    world.subscribe_event("DropPowerUp", handle_spawn);
    world.subscribe_event("RequestNewPlayer", handle_newplayer);
    world.subscribe_event("PowerUpCollision", handle_collide);
    world.subscribe_event("PowerUpDeath", handle_death);
  }

  void handle_spawn(Map event) {
    int powerup = world.new_entity();
    double x = event['position'][0];
    double y = event['position'][1];
    world.add_component(powerup, new Position(x,y));
    world.add_component(powerup, new Velocity(0.0, 4.0));
    world.add_component(powerup, new PowerUp(event['powerup']));
    world.add_component(powerup, new Size(POWERUP_WIDTH, POWERUP_HEIGHT));
    world.add_component(powerup, new Color("#00FFAA"));
    world.add_component(powerup, new Collidable());

    world.add_to_world(powerup);
   world.send_event("NewPowerUpCreated", {'entity':powerup, 'position':[x,y], 'velocity':[0.0, 4.0], 'powerup':event['powerup'], 'size':[POWERUP_WIDTH,POWERUP_HEIGHT], 'color':"#00FFAA"});
  }

  void handle_newplayer(Map event) {
    for (int e in entities) {
      var pos = posmap.get_component(e);
      var vel = velmap.get_component(e);
      var power = powermap.get_component(e);
      world.send_event("NewPowerUpCreated", {'Clients':[event['client_id'],] ,
        'entity':e,
        'position':[pos.x, pos.y],
        'velocity':[vel.x, vel.y],
        'size':[POWERUP_WIDTH,POWERUP_HEIGHT],
        'color':"#00FFAA",
        'powerup':power.powerup}
      );
    }
  }

  void handle_collide(Map event) {
    int powerup = event['powerup'];
    int paddle = event['paddle'];
    if (paddle == null) {}
    else {
      world.component_mappers[Paddle].get_component(paddle).powerups.add(powermap.get_component(powerup).powerup);
    }
    world.remove_entity(event['powerup']);
  }

  void handle_death(Map event) {
    world.remove_entity(event['powerup']);
  }
}
