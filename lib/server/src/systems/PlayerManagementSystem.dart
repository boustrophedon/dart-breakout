part of breakout_server;

class PlayerManagementSystem extends System {
  Random rng = new Random();
  Map<int, int> client_player_map;

  static final int PADDLE_WIDTH = 80;
  static final int PADDLE_HEIGHT = 20;

  ComponentMapper<Position> posmap;
  ComponentMapper<Velocity> velmap;
  ComponentMapper<Color> colormap;
  ComponentMapper<Paddle> paddlemap;

  PlayerManagementSystem(BreakoutServerWorld world) : super(world) {
    components_wanted = new Set.from([Paddle,]);
    client_player_map = new Map<int, int>();

    posmap = world.component_mappers[Position];
    velmap = world.component_mappers[Velocity];
    colormap = world.component_mappers[Color];
    paddlemap = world.component_mappers[Paddle];
  }
  void initialize() {
    world.subscribe_event("RequestNewPlayer", handle_newplayer);
    world.subscribe_event("ClientDisconnected", handle_disconnect);
  }

  void handle_newplayer(Map event) {
    send_current_players(event['client_id']);

    int paddle = world.new_entity();
    double x = rng.nextInt(720-PADDLE_WIDTH).toDouble();
    var c1 = (rng.nextInt(256)+50)~/2;
    var c2 = (rng.nextInt(256)+50)~/2;
    var c3 = (rng.nextInt(256)+50)~/2;
    String color = "rgba($c1, $c2, $c3, 1.0)";
    world.add_component(paddle, new Color(color));
    world.add_component(paddle, new Position(x, 720.0-PADDLE_HEIGHT-20));
    world.add_component(paddle, new Velocity(0.0,0.0));
    world.add_component(paddle, new Paddle(event['client_id']));
    world.add_component(paddle, new Size(PADDLE_WIDTH, PADDLE_HEIGHT));
    world.add_component(paddle, new Collidable());
    world.add_to_world(paddle);

    client_player_map[event['client_id']] = paddle;
    world.send_event("NewPlayerCreated", {'entity':paddle, 'paddle_id':event['client_id'], 'position':[x,680.0], 'velocity':[0.0, 0.0], 'size':[PADDLE_WIDTH,PADDLE_HEIGHT], 'color':color});
  }
  
  void send_current_players(int client_id) {
    for (int e in entities) {
      var pos = posmap.get_component(e);
      var vel = velmap.get_component(e);
      var color = colormap.get_component(e);
      var paddle = paddlemap.get_component(e);
      world.send_event("NewPlayerCreated", {'Clients':[client_id,], 
        'entity':e,
        'color':color.color,
        'paddle_id':paddle.paddle_id,
        'position':[pos.x, pos.y],
        'velocity':[vel.x, vel.y],
        'size':[PADDLE_WIDTH,PADDLE_HEIGHT]}
      );
    }
  }

  void handle_disconnect(Map event) {
    if (client_player_map[event['client_id']] == null) {
      return;
    }
    world.send_event("PlayerLeft", {'player':client_player_map[event['client_id']]});
    world.remove_entity(client_player_map[event['client_id']]);
    client_player_map.remove(event['client_id']);
  }   
}
