part of breakout_server;

class BallMoveSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  ComponentMapper<Position> pos_mapper;
  ComponentMapper<Velocity> vel_mapper;
  ComponentMapper<Size> size_mapper;

  BallMoveSystem(BreakoutServerWorld world) : super(world) {
    components_wanted = new Set.from([Ball,Position,Velocity]);
    pos_mapper = world.component_mappers[Position];
    vel_mapper = world.component_mappers[Velocity];
    size_mapper = world.component_mappers[Size];
  }
  void initialize() {}

  void process_entity(int e) {
    Velocity vel = vel_mapper.get_component(e);
    Position pos = pos_mapper.get_component(e);

    double newx = pos.x+vel.x;
    double newy = pos.y+vel.y;
    pos.x = newx;
    pos.y = newy;
    world.send_event("ServerBallUpdate", {'ball':e, 'position':[pos.x,pos.y], 'velocity':[vel.x, vel.y]});
  }
}
