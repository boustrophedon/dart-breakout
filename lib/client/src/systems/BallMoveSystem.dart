part of breakout_client;

class BallMoveSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  ComponentMapper<Position> pos_mapper;
  ComponentMapper<Velocity> vel_mapper;
  ComponentMapper<Size> size_mapper;

  BallMoveSystem(World world) : super(world) {
    components_wanted = new Set.from([Ball,Position,Velocity]);
    pos_mapper = world.component_mappers[Position];
    vel_mapper = world.component_mappers[Velocity];
    size_mapper = world.component_mappers[Size];
  }
  void initialize() {
    world.subscribe_event("ServerBallUpdate", handle_update);  
  }

  void handle_update(Map event) {
    int ball = event['ball'];
    if (!entities.contains(ball)) {
      print('no ball entity $ball');
      return;
    }
    Position pos = pos_mapper.get_component(ball);
    Velocity vel = vel_mapper.get_component(ball);

    pos.x = event['position'][0];
    pos.y = event['position'][1];

    vel.x = event['velocity'][0];
    vel.y = event['velocity'][1];
  }
}
