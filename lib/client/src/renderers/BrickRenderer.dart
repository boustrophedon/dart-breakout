part of breakout_client;

class BrickRenderer extends Renderer {
  ComponentMapper<Position> pos_mapper;
  ComponentMapper<Size> size_mapper;
  ComponentMapper<Color> color_mapper;
  BrickRenderer(CanvasElement canv, CanvasRenderingContext2D ctx, Map mappers) : super(canv, ctx) {
    pos_mapper = mappers[Position];
    size_mapper = mappers[Size];
    color_mapper = mappers[Color];
  }

  void render_entity(int e) {
    Position pos = pos_mapper.get_component(e);
    Size size = size_mapper.get_component(e);
    Color color = color_mapper.get_component(e);

    context.fillStyle = color.color;
    context.fillRect(pos.x, pos.y, size.width, size.height); 
  }
}
