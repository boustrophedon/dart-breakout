part of breakout_server;

class BallManagementSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  static final BALL_SIZE = 10;

  Random rng = new Random();

  ComponentMapper<Position> posmap;
  ComponentMapper<Velocity> velmap;
  ComponentMapper<Size> sizemap;

  bool spawning = false;
  BallManagementSystem(BreakoutServerWorld world) : super(world) {
    components_wanted = new Set.from([Ball,]);
    
    posmap = world.component_mappers[Position];
    velmap = world.component_mappers[Velocity];
    sizemap = world.component_mappers[Size];
  }
  void initialize() {
    spawn_new_ball();

    world.subscribe_event("RequestNewPlayer", handle_newplayer);

    world.subscribe_event("RequestNewBall", handle_newball);
    world.subscribe_event("BallDeath", handle_balldeath);
  }

  void handle_newball(Map event) {
    spawn_new_ball(); // ideally spawn it where the paddle is, but who cares
  }

  void spawn_new_ball() {
    int ball = world.new_entity();
    double x = (rng.nextInt(area.width-40)+20).toDouble();
    double y = 200.0;
    double theta = 0.5*PI*rng.nextDouble()+0.25*PI;
    world.add_component(ball, new Position(x,y));
    world.add_component(ball, new Velocity(4*cos(theta), 6*sin(theta)));
    world.add_component(ball, new Ball());
    world.add_component(ball, new Size(BALL_SIZE,BALL_SIZE));
    world.add_component(ball, new Collidable());

    world.add_to_world(ball);
    world.send_event("NewBallCreated", {'entity':ball, 'position':[x,y], 'velocity':[4*cos(theta), 6*sin(theta)], 'size':[BALL_SIZE,BALL_SIZE]});
  }

  void handle_newplayer(Map event) {
    for (int e in entities) {
      var pos = posmap.get_component(e);
      var vel = velmap.get_component(e);
      var size = sizemap.get_component(e);
      world.send_event("NewBallCreated", {'Clients':[event['client_id'],],
        'entity':e,
        'position':[pos.x, pos.y],
        'velocity':[vel.x, vel.y],
        'size':[size.width,size.height]}
      );
    }
    if (entities.length < world.clients.length && !spawning) {
      spawn_new_ball();
    }
  } 

  void handle_balldeath(Map event) {
    world.remove_entity(event['ball']);
    if (entities.length == 1 && world.clients.isNotEmpty) { // this is the last ball
      spawning = true;
      new Future.delayed(const Duration(seconds: 3), () {
        var to_spawn = world.clients.length;
        while (entities.length < to_spawn) {
          spawn_new_ball();
        }
        spawning = false;
      });
    }
  }
}
