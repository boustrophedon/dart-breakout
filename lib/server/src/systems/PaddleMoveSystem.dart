part of breakout_server;

class PaddleMoveSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  ComponentMapper<Position> pos_mapper;
  ComponentMapper<Velocity> vel_mapper;
  ComponentMapper<Size> size_mapper;
  ComponentMapper<Paddle> paddle_mapper;

  PaddleMoveSystem(World world) : super(world) {
    components_wanted = new Set.from([Paddle,Position,Velocity]);
    pos_mapper = world.component_mappers[Position];
    vel_mapper = world.component_mappers[Velocity];
    size_mapper = world.component_mappers[Size];
    paddle_mapper = world.component_mappers[Paddle];
  }
  void initialize() {
    world.subscribe_event("MoveLeft", move_left);
    world.subscribe_event("MoveRight", move_right);
    world.subscribe_event("StopLeft", stop_left);
    world.subscribe_event("StopRight", stop_right);

    world.subscribe_event("ClientPaddleUpdate", handle_update);
  }

  void handle_update(Map event) {
    int e = event['entity'];
    if (!entities.contains(e)) {
      return;
    }
    if (paddle_mapper.get_component(e).paddle_id != event['client_id']) {
      return;
    }
    Position pos = pos_mapper.get_component(e);
    Size size = size_mapper.get_component(e);

    List<double> newpos = event['position'];
    // can do fancier latency-based compensation later
    //if ((newpos[0]-pos.x).abs() > 32) { 
    //  // basically arbitrary but actually since vel = 0.5 and dt = 16, it's
    //  // saying if you move more than 4 frames without sending an update the move doesn't count
    //  print('bad move x');
    //  return;
    //}
    if (newpos[1] != 680.0) {
      print('bad move y');
      return;
    }
    
    pos.x = check_bound(newpos[0], size.width, area.width);
    pos.y = check_bound(newpos[1], size.height, area.height);

    world.send_event("ServerPaddleUpdate", {'entity':e, 'position':[pos.x, pos.y]});
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
  //void process_entity(int e) {
  //  Velocity vel = vel_mapper.get_component(e);
  //  Position pos = pos_mapper.get_component(e);
  //  Size size = size_mapper.get_component(e);

  //  double newx = pos.x+vel.x*world.dt;
  //  double newy = pos.y+vel.y*world.dt;
  //  pos.x = check_bound(newx, size.width, area.width);
  //  pos.y = check_bound(newy, size.height, area.height);
  //}

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
