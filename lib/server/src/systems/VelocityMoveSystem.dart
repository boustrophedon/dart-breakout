part of breakout_server;

class VelocityMoveSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  ComponentMapper pos_mapper;
  ComponentMapper vel_mapper;
  ComponentMapper size_mapper;

  VelocityMoveSystem(BreakoutServerWorld world) : super(world) {
    components_wanted = new Set.from([Position,Velocity]);
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

    // should just have generic component update messages
    // world.send_event("ComponentUpdate", <String, Object>{'entity':e, 'component':??? Type,'value':val});
    // not sure 
    if (world.entities[e].contains(Ball)) {
      world.send_event("ServerBallUpdate", <String, Object>{'ball':e, 'position':[pos.x,pos.y], 'velocity':[vel.x, vel.y]});
    }
    else if (world.entities[e].contains(PowerUp)) {
      world.send_event("ServerPowerUpUpdate", <String, Object>{'powerup':e, 'position':[pos.x, pos.y], 'velocity':[vel.x, vel.y]});
    }
    else {}
  }
}
