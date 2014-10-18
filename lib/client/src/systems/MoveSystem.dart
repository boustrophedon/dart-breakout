part of breakout_client;

class MoveSystem extends System {
  MoveSystem(World world) : super(world) {
    components_wanted = new Set.from([Moveable,]);
  }
  void initialize() {
    world.subscribe_event("KeyDown", do_move);
    world.subscribe_event("KeyUp", do_stop);
  }

  void do_move(Map event) {
    print(event["KeyboardEvent"].keyCode);
    int key = event["KeyboardEvent"].keyCode;
    if (key == 37) {
      move_left();
    }
    else if (key == 39) {
      move_right();
    }
  }

  void move_left() {
    for (Entity e in entities) {
      Velocity vel = e.get_component(Velocity);
      vel.x = -0.5;
      vel.y = 0;
    }
  }
  void move_right() {
    for (Entity e in entities) {
      Velocity vel = e.get_component(Velocity);
      vel.x = 0.5;
      vel.y = 0;
    }
  }

  void do_stop(Map event) {
    print(event["KeyboardEvent"].keyCode);
    int key = event["KeyboardEvent"].keyCode;
    if (key == 37) {
      stop_left();
    }
    else if (key == 39) {
      stop_right();
    }
  }
  void stop_left() {
    for (Entity e in entities) {
      Velocity vel = e.get_component(Velocity);
      if (vel.x == -0.5) {
        vel.x = 0;
      }
    }
  }
  void stop_right() {
    for (Entity e in entities) {
      Velocity vel = e.get_component(Velocity);
      if (vel.x == 0.5) {
        vel.x = 0;
      }
    }
  }
  void process_entity(Entity e) {
    Velocity vel = e.get_component(Velocity);
    Position pos = e.get_component(Position);

    pos.x += vel.x*world.dt;
    pos.y += vel.y*world.dt;
  }
}
