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
          bool collided = false;
          // there really isn't any difference between these two kinds. should be merged
          if (world.entities[other].contains(Paddle)) {
            collided = ball_paddle_collision(e, other);
          }
          else if (world.entities[other].contains(Brick)) {
            collided = ball_brick_collision(e, other);
          }
          //else if (world.entities[other].contains(Ball)) {
          //  collided = ball_ball_collision(e, other);
          //}
          if (collided) { break; }
        }
      }
    }
  }

  // bad names here and above
  bool ball_paddle_collision(int ball, int paddle) {
    Velocity ball_vel = vel_mapper.get_component(ball);
    Position ball_pos = pos_mapper.get_component(ball);
    Size ball_size = size_mapper.get_component(ball);

    Position paddle_pos = pos_mapper.get_component(paddle);
    //Velocity paddle_vel = vel_mapper.get_component(paddle);
    Size paddle_size = size_mapper.get_component(paddle);
  
    // bottom of ball hits top of paddle
    if (ball_pos.y+ball_size.height >= paddle_pos.y && ball_pos.y+ball_size.height <= paddle_pos.y+paddle_size.height && 
        ball_pos.x >= paddle_pos.x && ball_pos.x <= paddle_pos.x+paddle_size.width) { // does not handle hitting the edge
      ball_pos.y = paddle_pos.y-ball_size.height;
      ball_vel.y = -ball_vel.y;
      return true;
    }
    else {
      return false;
    }
  } 

  bool ball_brick_collision(int ball, int brick) {
    Velocity ball_vel = vel_mapper.get_component(ball);
    Position ball_pos = pos_mapper.get_component(ball);
    Size ball_size = size_mapper.get_component(ball);

    Position brick_pos = pos_mapper.get_component(brick);
    Size brick_size = size_mapper.get_component(brick);

    // top of ball hits bottom of brick
    if (ball_pos.y-ball_size.height <= brick_pos.y+brick_size.height && ball_pos.y-ball_size.height >= brick_pos.y && 
        ball_pos.x >= brick_pos.x && ball_pos.x <= brick_pos.x+brick_size.width) {
      ball_pos.y = brick_pos.y+brick_size.height+ball_size.height;
      ball_vel.y = -ball_vel.y;
      world.send_event("BrickBreak", {'brick':brick});
      return true;
    }
    // bottom of ball hits top of brick
    else if (ball_pos.y+ball_size.height >= brick_pos.y && ball_pos.y+ball_size.height <= brick_pos.y+brick_size.height &&
        ball_pos.x >= brick_pos.x && ball_pos.x <= brick_pos.x+brick_size.width) {
      ball_pos.y = brick_pos.y-ball_size.height;
      ball_vel.y = -ball_vel.y;
      world.send_event("BrickBreak", {'brick':brick});
      return true;
    }  
    else {
      return false;
    }
  }
}
