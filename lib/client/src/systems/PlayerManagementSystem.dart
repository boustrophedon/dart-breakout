part of breakout_client;

class PlayerManagementSystem extends System {
  PlayerManagementSystem(BreakoutClientWorld world) : super(world) {
    components_wanted = new Set.from([Paddle,]);
  }
  void initialize() {
    world.subscribe_event("NewPlayerCreated", handle_newplayer);
    world.subscribe_event("PlayerLeft", handle_playerleave);
  }

  void handle_newplayer(Map event) {
    int e = event['entity'];
    if (event['paddle_id'] == world.client_id) {
      world.tagged_entities['player'] = e;
    }
    world.add_component(e, new Renderable("paddle"));
    world.add_component(e, new Color(event['color']));
    world.add_component(e, new Position(event['position'][0], event['position'][1]));
    world.add_component(e, new Velocity(0.0, 0.0));
    world.add_component(e, new Paddle(event['paddle_id']));
    world.add_component(e, new Size(event['size'][0], event['size'][1]));
    world.add_component(e, new Collidable());
    world.add_to_world(e);
  }
  void handle_playerleave(Map event) {
    world.remove_entity(event['player']);
  }

}
