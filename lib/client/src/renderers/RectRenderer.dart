part of breakout_client;

class RectRenderer extends Renderer {
  ComponentMapper pos_mapper;
  ComponentMapper color_mapper;
  ComponentMapper size_mapper;
  RectRenderer(CanvasElement canv, CanvasRenderingContext2D ctx, Map mappers) : super(canv, ctx) {
    pos_mapper = mappers[Position];
    color_mapper = mappers[Color];
    size_mapper = mappers[Size];
  }

  void render_entity(int e) {
    Position pos = pos_mapper.get_component(e);
    Color color = color_mapper.get_component(e);
    Size size = size_mapper.get_component(e);

    context.fillStyle = color.color;
    context.fillRect(pos.x, pos.y, size.width, size.height); 
  }
}
