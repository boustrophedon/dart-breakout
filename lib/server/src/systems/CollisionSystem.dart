part of breakout_server;

class CollisionSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  ComponentMapper<Position> pos_mapper;
  ComponentMapper<Velocity> vel_mapper;
  ComponentMapper<Size> size_mapper;

  CollisionSystem(BreakoutServerWorld world) : super(world) {
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
    else if (world.entities[e].contains(PowerUp)) {
      do_powerup_collision(e);
    }
  }
  void do_ball_collision(int e) {
    Velocity vel = vel_mapper.get_component(e);
    Position pos = pos_mapper.get_component(e);
    Size size = size_mapper.get_component(e);

    // the problem with bounce events being emitted on the server
    // is that the sounds will lag. this is one of the reasons why client-side prediction is important
    if (pos.x-size.width < 0) {
      pos.x = 0.0+size.width;
      vel.x = -vel.x;
      world.send_event("WallBounce", {});
    }
    else if (pos.x+size.width > area.right) {
      pos.x = (area.right-size.width).toDouble();
      vel.x = -vel.x;
      world.send_event("WallBounce", {});
    }
    else if (pos.y+size.height > area.bottom) {
      pos.y = (area.bottom-size.height).toDouble();
      vel.y = 0.0;
      vel.x = 0.0;
      world.send_event("BallDeath", {'ball':e});
    }
    else if (pos.y-size.height < 0) {
      pos.y = 0.0+size.height;
      vel.y = -vel.y;
      world.send_event("WallBounce", {});
    }
    else {
      for (int other in entities) {
        if (e != other) {
          bool collided = false;
          if (world.entities[other].contains(Paddle)) {
            collided = ball_paddle_collision(e, other);
            if (collided == true) {
              world.send_event("PaddleBounce", {'paddle':other, 'ball':e});
              break;
            }
          }
          else if (world.entities[other].contains(Brick)) {
            collided = ball_brick_collision(e, other);
            if (collided == true) {
              world.send_event("BrickBounce", {'brick':other});
              // maybe slightly redundant, but perhaps i'll have bricks that take multiple hits to break in the future
              // currently the code just emits a break event when a brick gets hit though...
              break;
            }
          }
          //else if (world.entities[other].contains(Ball)) {
          //  collided = ball_ball_collision(e, other);
          //}
        }
      }
    }
  }

  List<double> aa_circle_rect_collision(int circle, int rect) {
    Position circle_pos = pos_mapper.get_component(circle);
    Size circle_size = size_mapper.get_component(circle);

    Position rect_pos = pos_mapper.get_component(rect);
    //Velocity rect_vel = vel_mapper.get_component(rect);
    Size rect_size = size_mapper.get_component(rect);


    // code via http://forums.tigsource.com/index.php?topic=26092.msg734944#msg734944
    // 
    List<double> pt = new List<double>(2);
    pt[0] = circle_pos.x;
    pt[1] = circle_pos.y;

    if (pt[0] >= rect_pos.x+rect_size.width) { pt[0] = rect_pos.x+rect_size.width; }
    if (pt[0] <= rect_pos.x) { pt[0] = rect_pos.x; }
    if (pt[1] >= rect_pos.y+rect_size.height) { pt[1] = rect_pos.y+rect_size.height; }
    if (pt[1] <= rect_pos.y) { pt[1] = rect_pos.y; }

    if ( pow(pt[0] - circle_pos.x, 2) + pow(pt[1] - circle_pos.y,2) <= circle_size.width*circle_size.width) {
      return pt;
    }
    else {
      return null;
    }

  }

  // bad names here and below
  // there should also be a better way to reduce the amount of overlapping code, but whatever
  bool ball_paddle_collision(int ball, int paddle) {
    Velocity ball_vel = vel_mapper.get_component(ball);
    Position ball_pos = pos_mapper.get_component(ball);
    Size ball_size = size_mapper.get_component(ball);

    Position paddle_pos = pos_mapper.get_component(paddle);
    //Velocity paddle_vel = vel_mapper.get_component(paddle);
    Size paddle_size = size_mapper.get_component(paddle);
  
    var intersect = aa_circle_rect_collision(ball, paddle);
    if (intersect != null) {
      if (intersect[1] == paddle_pos.y) {
        ball_pos.x = intersect[0];
        ball_pos.y = intersect[1]-ball_size.height;

        ball_vel.y = -ball_vel.y;

        var displacement = (intersect[0] - (paddle_pos.x + paddle_size.width/2))/(paddle_size.width/2);
        ball_vel.x = (ball_vel.x + 10*displacement).clamp(-5.0,5.0);
      }
      else if (intersect[0] == paddle_pos.x) {
        ball_pos.x = intersect[0]-ball_size.width;
        ball_pos.y = intersect[1];

        ball_vel.x = -1*ball_vel.x.abs();
      }
      else if (intersect[0] == paddle_pos.x+paddle_size.width) {
        ball_pos.x = intersect[0]+ball_size.width;
        ball_pos.y = intersect[1];
  
        ball_vel.x = ball_vel.x.abs();
      }
      else if (intersect[1] == paddle_pos.y+paddle_size.height) {
        ball_pos.x = intersect[0];
        ball_pos.y = intersect[1]+ball_size.height;

        ball_vel.y = 2*ball_vel.y.abs();
      }
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

    var intersect = aa_circle_rect_collision(ball, brick);
    if (intersect != null) {
      if (intersect[1] == brick_pos.y) {
        ball_pos.x = intersect[0];
        ball_pos.y = intersect[1]-ball_size.height;

        ball_vel.y = -ball_vel.y;
      }
      else if (intersect[0] == brick_pos.x) {
        ball_pos.x = intersect[0]-ball_size.width;
        ball_pos.y = intersect[1];

        ball_vel.x = -ball_vel.x;
      }
      else if (intersect[0] == brick_pos.x+brick_size.width) {
        ball_pos.x = intersect[0]+ball_size.width;
        ball_pos.y = intersect[1];
  
        ball_vel.x = -ball_vel.x;
      }
      else if (intersect[1] == brick_pos.y+brick_size.height) {
        ball_pos.x = intersect[0];
        ball_pos.y = intersect[1]+ball_size.height;

        ball_vel.y = -ball_vel.y;
      }
      world.send_event("BrickBreak", {'brick':brick});
      return true;
    }
    else {
      return false;
    }
  }

  void do_powerup_collision(int e) {
    Position pos = pos_mapper.get_component(e);
    Size size = size_mapper.get_component(e);
    if (pos.y+size.height > area.bottom) {
      world.send_event("PowerUpDeath",{'powerup':e});
    }
    else {
      List<int> colliders = new List<int>();
      for (int other in entities) {
        if (world.entities[other].contains(Paddle)) {
          bool result = aa_rect_rect_collision(e, other);
          if (result != false) {
            colliders.add(other);
          }
        }
      }
      for (int paddle in colliders) {
        world.send_event("PowerUpCollision", {'powerup':e, 'paddle':paddle});
      }
      if (colliders.isNotEmpty) {
        world.send_event("PowerUpDeath", {'powerup':e});
      }
    }
  }

  // in this case we don't need to know where the collision takes place
  // the names are kind of misleading though, since they're both aa_something_collision
  bool aa_rect_rect_collision(int rect1, int rect2) {
    Position pos1 = pos_mapper.get_component(rect1);
    Position pos2 = pos_mapper.get_component(rect2);

    Size size1 = size_mapper.get_component(rect1);
    Size size2 = size_mapper.get_component(rect2);

    if (range_overlap(pos1.x, pos1.x+size1.width, pos2.x, pos2.x+size2.width) &&
        range_overlap(pos1.y, pos1.y+size1.height, pos2.y, pos2.y+size2.height)) {
      return true;
    }
    else {
      return false;
    }
  }
}
// aa rectangle overlap simplification from http://codereview.stackexchange.com/a/31529
bool range_overlap(num min1, num max1, num min2, num max2) {
  return ((min1 <= max2) && (min2 <= max1));
}
