part of breakout_client;

class RenderSystem extends System {

  CanvasElement canvas;
  CanvasRenderingContext2D context;

  LinkedHashMap<String, Renderer> renderers;

  ComponentMapper<Renderable> rend_mapper;

  RenderSystem(BreakoutClientWorld world) : super(world) {
    renderers = new Map<String, Renderer>();
    components_wanted = new Set.from([Renderable,Position]);
    rend_mapper = world.component_mappers[Renderable];
  }

  void set_context(CanvasElement canv) {
    this.canvas = canv;

    context = canvas.context2D;
  }

  void initialize() {
    set_context(world.canvas);

    // order of renderers specified here specifies draw order. first in first out -> last thing added gets drawn on top
    renderers['paddle'] = new PaddleRenderer(canvas, context, world.component_mappers);
    renderers['brick'] = new BrickRenderer(canvas, context, world.component_mappers);
    renderers['ball'] = new BallRenderer(canvas, context, world.component_mappers);
  }

  void process() {
    render_entities();
  }

  void render_entities() {

    //context.clearRect(0,0,canvas.width, canvas.height);
    context.fillStyle = '#111111';
    context.fillRect(0,0,canvas.width, canvas.height);
    for (Renderer r in renderers.values) {
      r.render_entities();
    }
  }

  void process_entity(int e) {}

  void process_new_entity(int entity) {
    Renderable rend = rend_mapper.get_component(entity);
    if (renderers.containsKey(rend.type)) {
      renderers[rend.type].add_entity(entity);
    }
  }

  void remove_entity(int entity) {
    Renderable rend = rend_mapper.get_component(entity);
    if (renderers.containsKey(rend.type)) {
      renderers[rend.type].remove_entity(entity);
    }
  }
}

