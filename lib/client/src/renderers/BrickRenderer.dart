part of breakout_client;

class BrickRenderer extends Renderer {
  ComponentMapper<Position> pos_mapper;
  ComponentMapper<Size> size_mapper;
  ComponentMapper<Brick> brick_mapper;
  BrickRenderer(CanvasElement canv, CanvasRenderingContext2D ctx, Map mappers) : super(canv, ctx) {
    pos_mapper = mappers[Position];
    size_mapper = mappers[Size];
    brick_mapper = mappers[Brick];
  }

  void render_entity(int e) {
    Position pos = pos_mapper.get_component(e);
    Size size = size_mapper.get_component(e);
    Brick brick = brick_mapper.get_component(e);

    context.fillStyle = brick.color;
    context.fillRect(pos.x, pos.y, size.width, size.height); 
  }
}
