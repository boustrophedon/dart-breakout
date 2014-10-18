part of breakout_client;

class Renderer {
  CanvasElement canvas;
  CanvasRenderingContext2D context;
  Set<Entity> entities;

  Renderer(CanvasElement canv, CanvasRenderingContext2D ctx) {
    canvas = canv;
    context = ctx;
    entities = new Set<Entity>();
  }

  // not necessary for me now but would be nice to have in the future
  // and super easy to implement here and now while i'm at it.
  void setup() {
    context.save();
  }
  void teardown() {
    context.restore();
  }

  void render_entities() {
    setup();
    for (Entity e in entities) {
      render_entity(e);
    }
    teardown();
  }

  void add_entity(Entity e) {
    entities.add(e);
  }

  void remove_entity(Entity e) {
    entities.remove(e);
  }

  void render_entity(Entity e) {}
}
