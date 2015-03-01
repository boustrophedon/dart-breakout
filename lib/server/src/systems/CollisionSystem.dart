part of breakout_server;

class CollisionSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  ComponentMapper<Position> pos_mapper;
  ComponentMapper<Velocity> vel_mapper;
  ComponentMapper<Size> size_mapper;

  CollisionSystem(World world) : super(world) {
    components_wanted = new Set.from([Collidable,Position,Size]);
    pos_mapper = world.component_mappers[Position];
    vel_mapper = world.component_mappers[Velocity];
    size_mapper = world.component_mappers[Size];
  }
  void initialize() {}

  void process_entity(int e) {
    if (world.entities[e].contains(Ball)) {
      do_ball_collision(e);
    }
    //else if (world.entities[e].contains(Paddle)) {
    //  do_paddle_collision(e);
    //}
  }
  void do_ball_collision(int e) {
    Velocity vel = vel_mapper.get_component(e);
    Position pos = pos_mapper.get_component(e);
    Size size = size_mapper.get_component(e);

    if (pos.x-size.width < 0) {
      pos.x = 0.0+size.width;
      vel.x = -vel.x;
    }
    else if (pos.x+size.width > area.right) {
      pos.x = (area.right-size.width).toDouble();
      vel.x = -vel.x;
    }
    else if (pos.y+size.height > area.bottom) {
      pos.y = (area.bottom-size.height).toDouble();
      //vel.y = -vel.y;
      vel.y = 0.0;
      vel.x = 0.0;
      world.send_event("BallDeath", {'ball':e});
    }
    else if (pos.y-size.height < 0) {
      pos.y = 0.0+size.height;
      vel.y = -vel.y;
    }
    else {
      for (int other in entities) {
        if (e != other) {
          bool collided = ball_collision(e, other);
          if (collided) { break; }
        }
      }
    }
  }

  // bad names here and above
  bool ball_collision(int ball, int other) {
    Velocity ball_vel = vel_mapper.get_component(ball);
    Position ball_pos = pos_mapper.get_component(ball);
    Size ball_size = size_mapper.get_component(ball);

    //Velocity other_vel = vel_mapper.get_component(other);
    Position other_pos = pos_mapper.get_component(other);
    Size other_size = size_mapper.get_component(other);
  
    if (ball_pos.y+ball_size.height >= other_pos.y && ball_pos.y+ball_size.height <= other_pos.y+other_size.height && 
        ball_pos.x >= other_pos.x && ball_pos.x <= other_pos.x+other_size.width) { // does not handle hitting the edge
      ball_pos.y = other_pos.y-ball_size.height;
      ball_vel.y = -ball_vel.y;
      return true;
    }
    else {
      return false;
    }
  } 

  void do_paddle_collision(int e) { }
}
