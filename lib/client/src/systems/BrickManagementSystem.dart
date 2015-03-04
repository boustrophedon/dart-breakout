part of breakout_client;

class BrickManagementSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  ComponentMapper<Color> color_mapper;
  ComponentMapper<Position> pos_mapper;
  ComponentMapper<Size> size_mapper;

  BrickManagementSystem(World world) : super(world) {
    components_wanted = new Set.from([Brick,]);
    color_mapper = world.component_mappers[Color];
    pos_mapper = world.component_mappers[Position];
    size_mapper = world.component_mappers[Size];
  }
  void initialize() {
    world.subscribe_event("NewBrickCreated", handle_newbrick);
    world.subscribe_event("ServerBrickUpdate", handle_brickupdate);
    world.subscribe_event("BrickBreak", handle_brickbreak);
  }

  void handle_newbrick(Map event) {
    int brick = event['entity'];
    world.add_component(brick, new Renderable("brick"));
    world.add_component(brick, new Color(event['color']));
    world.add_component(brick, new Position(event['position'][0],event['position'][1]));
    world.add_component(brick, new Brick());
    world.add_component(brick, new Size(event['size'][0],event['size'][1]));
    world.add_component(brick, new Collidable());
    world.add_to_world(brick);
  }

  void handle_brickupdate(Map event) {
    if (!entities.contains(event['brick'])) {
      return;
    }
    int e = event['brick'];
    var color = color_mapper.get_component(e);
    var pos = pos_mapper.get_component(e);
    var size = size_mapper.get_component(e);

    color.color = event['color'];
    pos.x = event['position'][0];
    pos.y = event['position'][1];
    size.width = event['size'][0];
    size.height = event['size'][1];
  }

  void handle_brickbreak(Map event) {
    world.remove_entity(event['brick']);
  }
}
