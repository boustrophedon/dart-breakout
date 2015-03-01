part of breakout_server;

class BallManagementSystem extends System {
  static final Rectangle area = const Rectangle(0,0,720,720);

  static final BALL_SIZE = 10;

  Random rng = new Random();

  bool spawning = false;
  BallManagementSystem(World world) : super(world) {
    components_wanted = new Set.from([Ball,]);
  }
  void initialize() {
    spawn_new_ball();

    world.subscribe_event("RequestNewPlayer", handle_newplayer); // not sure if this should be here or in playermanager

    world.subscribe_event("BallDeath", handle_balldeath);
  }

  void spawn_new_ball() {
    int ball = world.new_entity();
    double x = (rng.nextInt(area.width-40)+20).toDouble();
    double y = 200.0;
    double theta = PI*rng.nextDouble();
    world.add_component(ball, new Position(x,y));
    world.add_component(ball, new Velocity(4*cos(theta), 4*sin(theta)));
    world.add_component(ball, new Ball());
    world.add_component(ball, new Size(BALL_SIZE,BALL_SIZE));
    world.add_component(ball, new Collidable());

    world.add_to_world(ball);
    world.send_event("NewBallCreated", {'entity':ball, 'position':[x,y], 'velocity':[4*cos(theta), 4*sin(theta)], 'size':[BALL_SIZE,BALL_SIZE]});
  }

  void handle_newplayer(Map event) {
    var posmap = world.component_mappers[Position];
    var velmap = world.component_mappers[Velocity];
    for (int e in entities) {
      var pos = posmap.get_component(e);
      var vel = velmap.get_component(e);
      world.send_event("NewBallCreated", {'Clients':[event['client_id'],],
        'entity':e,
        'position':[pos.x, pos.y],
        'velocity':[vel.x, vel.y],
        'size':[BALL_SIZE,BALL_SIZE]}
      );
    }
    if (entities.isEmpty && !spawning) {
      spawn_new_ball();
    }
  } 

  void handle_balldeath(Map event) {
    world.remove_entity(event['ball']);
    if (entities.length == 1 && world.globaldata['Clients'].isNotEmpty) { // this is the last ball
      spawning = true;
      new Future.delayed(const Duration(seconds: 3), () {
        spawn_new_ball();  
        spawning = false;
      });
    }
  }
}
