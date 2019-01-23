part of breakout_server;

class PaddleMoveSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  ComponentMapper pos_mapper;
  ComponentMapper size_mapper;
  ComponentMapper paddle_mapper;

  PaddleMoveSystem(BreakoutServerWorld world) : super(world) {
    components_wanted = new Set.from([Paddle,Position]);
    pos_mapper = world.component_mappers[Position];
    size_mapper = world.component_mappers[Size];
    paddle_mapper = world.component_mappers[Paddle];
  }
  void initialize() {
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

    var newpos = event['position'];
    pos.x = check_bound(newpos[0].toDouble(), size.width, area.width);
    pos.y = check_bound(newpos[1].toDouble(), size.height, area.height);

    world.send_event("ServerPaddleUpdate", <String, Object>{'entity':e, 'position':[pos.x, pos.y], 'size':[size.width, size.height]});
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
