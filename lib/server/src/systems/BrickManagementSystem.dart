part of breakout_server;

class BrickManagementSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  ComponentMapper<Position> posmap;
  ComponentMapper<Color> colormap;

  Random rng = new Random();

  int BRICK_WIDTH = 60;
  int BRICK_HEIGHT = 20;

  static final BRICK_COLOR = 'rgba(0, 0, 255, 1.0)';

  BrickManagementSystem(World world) : super(world) {
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
    world.add_component(brick, new Brick());
    world.add_component(brick, new Size(BRICK_WIDTH,BRICK_HEIGHT));
    world.add_component(brick, new Collidable());

    world.add_to_world(brick);
    world.send_event("NewBrickCreated", {'entity':brick, 'position':[x,y], 'size':[BRICK_WIDTH,BRICK_HEIGHT], 'color':BRICK_COLOR});
  }

  void spawn_new_row() {
    // move down all current bricks
    for (int e in entities) {
      Position pos = posmap.get_component(e);
      pos.y+=BRICK_HEIGHT+5;
      world.send_event("ServerBrickUpdate", {'brick':e, 'position':[pos.x, pos.y], 'size':[BRICK_WIDTH, BRICK_HEIGHT], 'color':BRICK_COLOR});
    }
    for (int i = 0; i<area.right~/(BRICK_WIDTH+5); i++) {
      spawn_new_brick(5+i*(BRICK_WIDTH+5).toDouble(), 5.0);
    }
  }

  void handle_newplayer(Map event) {
    for (int e in entities) {
      var pos = posmap.get_component(e);
      var color = colormap.get_component(e);
      world.send_event("NewBrickCreated", {'Clients':[event['client_id'],],
        'entity':e,
        'position':[pos.x, pos.y],
        'size':[BRICK_WIDTH,BRICK_HEIGHT],
        'color':color.color}
      );
    }
  } 

  void handle_brickbreak(Map event) {
    world.remove_entity(event['brick']);
    // should do something fancier
    if (entities.length == 1 && world.globaldata['Clients'].isNotEmpty) { // this is the last brick
      new Future.delayed(const Duration(seconds: 3), () {
        int rows = rng.nextInt(5)+1;
        for (int i = 0; i<rows; i++) {
          spawn_new_row();
        }
      });
    }
  }
}