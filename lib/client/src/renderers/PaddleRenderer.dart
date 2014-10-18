part of breakout_client;

class PaddleRenderer extends Renderer {
  PaddleRenderer(CanvasElement canv, CanvasRenderingContext2D ctx) : super(canv, ctx);

  void render_entity(Entity e) {
    Position pos = e.get_component(Position);
    Renderable rend = e.get_component(Renderable);
    Size size = e.get_component(Size);

    context.fillStyle = '#FF0000';
    context.fillRect(pos.x, pos.y, size.height,size.width); 
  }
}
