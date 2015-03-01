part of breakout_client;

class BallRenderer extends Renderer {
  ComponentMapper<Position> pos_mapper;
  ComponentMapper<Size> size_mapper;
  BallRenderer(CanvasElement canv, CanvasRenderingContext2D ctx, Map mappers) : super(canv, ctx) {
    pos_mapper = mappers[Position];
    size_mapper = mappers[Size];
  }

  void render_entity(int e) {
    Position pos = pos_mapper.get_component(e);
    Size size = size_mapper.get_component(e);

    context.fillStyle = '#FFFFFF';
    context.beginPath();
    print(size.width);
    context.arc(pos.x, pos.y, size.width, 0, 2*PI);
    context.fill();
  }
}
