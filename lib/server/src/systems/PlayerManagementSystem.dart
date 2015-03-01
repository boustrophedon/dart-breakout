part of breakout_server;

class PlayerManagementSystem extends System {
  Random rng = new Random();
  Map<int, int> client_player_map;
  PlayerManagementSystem(World world) : super(world) {
    components_wanted = new Set.from([Paddle,]);
    client_player_map = new Map<int, int>();
  }
  void initialize() {
    world.subscribe_event("RequestNewPlayer", handle_newplayer);
    world.subscribe_event("ClientDisconnected", handle_disconnect);
  }

  void handle_newplayer(Map event) {
    send_current_players(event['client_id']);

    int paddle = world.new_entity();
    double x = rng.nextInt(720-80).toDouble();
    world.add_component(paddle, new Position(x, 680.0));
    world.add_component(paddle, new Velocity(0.0,0.0));
    world.add_component(paddle, new Paddle(event['client_id']));
    world.add_component(paddle, new Size(80, 20));
    world.add_to_world(paddle);

    client_player_map[event['client_id']] = paddle;
    world.send_event("NewPlayerCreated", {'entity':paddle, 'paddle_id':event['client_id'], 'position':[x,680.0], 'velocity':[0.0, 0.0], 'size':[80,20]});
  }
  
  void send_current_players(int client_id) {
    var posmap = world.component_mappers[Position];
    var velmap = world.component_mappers[Velocity];
    var paddlemap = world.component_mappers[Paddle];
    for (int e in entities) {
      var pos = posmap.get_component(e);
      var vel = velmap.get_component(e);
      var paddle = paddlemap.get_component(e);
      world.send_event("NewPlayerCreated", {'Clients':[client_id,], 
        'entity':e,
        'paddle_id':paddle.paddle_id,
        'position':[pos.x, pos.y],
        'velocity':[vel.x, vel.y],
        'size':[80,20]}
      );
    }
  }

  void handle_disconnect(Map event) {
    world.send_event("PlayerLeft", {'player':client_player_map[event['client_id']]});
    world.remove_entity(client_player_map[event['client_id']]);
    client_player_map.remove(event['client_id']);
  }   
}
