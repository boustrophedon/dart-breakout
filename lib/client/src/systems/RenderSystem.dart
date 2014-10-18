part of breakout_client;

class RenderSystem extends System {

  CanvasElement canvas;
  CanvasRenderingContext2D context;

  LinkedHashMap<String, Renderer> renderers;

  RenderSystem(World world) : super(world) {
    renderers = new Map<String, Renderer>();
    components_wanted = new Set.from([Renderable,Position]);
  }

  void set_context(CanvasElement canv) {
    this.canvas = canv;

    context = canvas.context2D;
  }

  void initialize() {
    set_context(world.globaldata['canvas']);

    // order of renderers specified here specifies draw order. first in first out -> last thing added gets drawn on top
    renderers['paddle'] = new PaddleRenderer(canvas, context);
    //renderers['brick'] = new BrickRenderer(canvas, context);
    //renderers['ball'] = new BallRenderer(canvas, context);
  }

  void process() {
    render_entities();
  }

  void render_entities() {
    context.clearRect(0,0,canvas.width, canvas.height);
    for (Renderer r in renderers.values) {
      r.render_entities();
    }
  }

  void process_entity(Entity e) {}

  void process_new_entity(Entity entity) {
    Renderable rend = entity.get_component(Renderable);
    if (renderers.containsKey(rend.type)) {
      renderers[rend.type].add_entity(entity);
    }
  }

  void remove_entity(Entity entity) {
    Renderable rend = entity.get_component(Renderable);
    if (renderers.containsKey(rend.type)) {
      renderers[rend.type].remove_entity(entity);
    }
  }
}

