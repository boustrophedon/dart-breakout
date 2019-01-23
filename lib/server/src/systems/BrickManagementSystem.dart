part of breakout_server;

class BrickManagementSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  ComponentMapper posmap;
  ComponentMapper colormap;

  Random rng = new Random();

  int BRICK_WIDTH = 60;
  int BRICK_HEIGHT = 20;

  static const double POWERUP_PROBABILITY = 0.5;

  static const String BRICK_COLOR = 'rgba(0, 0, 255, 1.0)';

  BrickManagementSystem(BreakoutServerWorld world) : super(world) {
    components_wanted = new Set.from([Brick,]);
    
    posmap = world.component_mappers[Position];
    colormap = world.component_mappers[Color];
  }
  void initialize() {
    for (int i = 0; i<5; i++) {
      spawn_new_row();
    }
    world.subscribe_event("RequestNewPlayer", handle_newplayer);
    world.subscribe_event("BrickBreak", handle_brickbreak);
  }

  void spawn_new_brick(double x, double y) {
    int brick = world.new_entity();
    world.add_component(brick, new Position(x,y));
    world.add_component(brick, new Color(BRICK_COLOR));
    world.add_component(brick, new Size(BRICK_WIDTH,BRICK_HEIGHT));
    world.add_component(brick, new Collidable());

    if (rng.nextDouble() <= POWERUP_PROBABILITY) {
      String ptype = PowerUp.types[rng.nextInt(PowerUp.types.length)];
      world.add_component(brick, new Brick(powerup: ptype));
    }
    else {
      world.add_component(brick, new Brick());
    }

    world.add_to_world(brick);
    world.send_event("NewBrickCreated", <String, Object>{'entity':brick, 'position':[x,y], 'size':[BRICK_WIDTH,BRICK_HEIGHT], 'color':BRICK_COLOR});
  }

  void spawn_new_row() {
    // move down all current bricks
    for (int e in entities) {
      Position pos = posmap.get_component(e);
      pos.y+=BRICK_HEIGHT+5;
      world.send_event("ServerBrickUpdate", <String, Object>{'brick':e, 'position':[pos.x, pos.y], 'size':[BRICK_WIDTH, BRICK_HEIGHT], 'color':BRICK_COLOR});
    }
    for (int i = 0; i<area.right~/(BRICK_WIDTH+5); i++) {
      spawn_new_brick(5+i*(BRICK_WIDTH+5).toDouble(), 5.0);
    }
  }

  void handle_newplayer(Map event) {
    for (int e in entities) {
      var pos = posmap.get_component(e);
      var color = colormap.get_component(e);
      world.send_event("NewBrickCreated", <String, Object>{'Clients':[event['client_id'],],
        'entity':e,
        'position':[pos.x, pos.y],
        'size':[BRICK_WIDTH,BRICK_HEIGHT],
        'color':color.color}
      );
    }
  } 

  void handle_brickbreak(Map event) {
    int brick = event['brick'];
    var brick_c = world.component_mappers[Brick].get_component(brick);
    if (brick_c.powerup != null) {
      var pos = posmap.get_component(brick);
      world.send_event('DropPowerUp', <String, Object>{'position':[pos.x, pos.y], 'powerup':brick_c.powerup});
    }

    world.remove_entity(brick);

    // should do something fancier
    if (entities.length == 1 && world.clients.isNotEmpty) { // this is the last brick
      new Future.delayed(const Duration(seconds: 3), () {
        int rows = rng.nextInt(5)+1;
        for (int i = 0; i<rows; i++) {
          spawn_new_row();
        }
      });
    }
  }
}
