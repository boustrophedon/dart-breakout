part of breakout_client;

class BallMoveSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  ComponentMapper pos_mapper;
  ComponentMapper vel_mapper;
  ComponentMapper size_mapper;

  BallMoveSystem(BreakoutClientWorld world) : super(world) {
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
    Size size = size_mapper.get_component(ball);
    if (event.containsKey('position')) {
      pos.x = event['position'][0];
      pos.y = event['position'][1];
    }
    if (event.containsKey('velocity')) {
      vel.x = event['velocity'][0];
      vel.y = event['velocity'][1];
    }
    // this shouldn't really be here but oh well
    if (event.containsKey('size')) {
      size.width = event['size'][0];
      size.height = event['size'][1];
    }
  }
}
