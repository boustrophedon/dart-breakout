part of breakout_client;

class PaddleMoveSystem extends System {
  CanvasElement canvas;

  ComponentMapper<Position> pos_mapper;
  ComponentMapper<Velocity> vel_mapper;
  ComponentMapper<Size> size_mapper;

  PaddleMoveSystem(BreakoutClientWorld world) : super(world) {
    components_wanted = new Set.from([Paddle,Position,Velocity]);
    pos_mapper = world.component_mappers[Position];
    vel_mapper = world.component_mappers[Velocity];
    size_mapper = world.component_mappers[Size];
  }
  void initialize() {
    canvas = world.canvas;
    world.subscribe_event("MoveLeft", move_left);
    world.subscribe_event("MoveRight", move_right);
    world.subscribe_event("StopLeft", stop_left);
    world.subscribe_event("StopRight", stop_right);

    world.subscribe_event("ServerPaddleUpdate", handle_update);
  }

  void handle_update(Map event) {
    int paddle = event['entity'];
    if (!entities.contains(paddle)) {
      return;
    }
    if (event.containsKey('size')) {
      Size size = size_mapper.get_component(paddle);
      size.width = event['size'][0];
      size.height = event['size'][1];
    }
    if (event['entity'] == world.tagged_entities['player']) {
      return;
    }
    if (event.containsKey('position')) {
      Position pos = pos_mapper.get_component(paddle);
      pos.x = event['position'][0];
      pos.y = event['position'][1];
    }
  }

  void move_left(Map event) {
    int e = event['paddle'];
    Velocity vel = vel_mapper.get_component(e);
    vel.x = -0.5;
    vel.y = 0.0;
  }
  void move_right(Map event) {
    int e = event['paddle'];
    Velocity vel = vel_mapper.get_component(e);
    vel.x = 0.5;
    vel.y = 0.0;
  }

  void stop_left(Map event) {
    int e = event['paddle'];
    Velocity vel = vel_mapper.get_component(e);
    if (vel.x == -0.5) {
      vel.x = 0.0;
    }
  }
  void stop_right(Map event) {
    int e = event['paddle'];
    Velocity vel = vel_mapper.get_component(e);
    if (vel.x == 0.5) {
      vel.x = 0.0;
    }
  }
  void process_entity(int e) {
    Velocity vel = vel_mapper.get_component(e);
    Position pos = pos_mapper.get_component(e);
    Size size = size_mapper.get_component(e);

    double newx = pos.x+vel.x*world.dt;
    double newy = pos.y+vel.y*world.dt;
    pos.x = check_bound(newx, size.width, canvas.width);
    pos.y = check_bound(newy, size.height, canvas.height);
    world.send_event("ClientPaddleUpdate", {"entity":e, "position":[pos.x, pos.y]});
  }

  double check_bound(double left, int size, num smax) {
    if (left < 0) {
      return 0.0;
    }
    else if (left+size > smax) {
      return (smax-size).toDouble();
    }
    else {
      return left;
    }
  }
}
