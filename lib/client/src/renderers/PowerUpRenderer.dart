part of breakout_client;

class PowerUpRenderer extends Renderer {
  ComponentMapper<Position> pos_map;
  ComponentMapper<Size> size_map;
  ComponentMapper<Color> color_map;
  PowerUpRenderer(CanvasElement canv, CanvasRenderingContext2D ctx, Map mappers) : super(canv, ctx) {
    pos_map = mappers[Position];
    size_map = mappers[Size];
    color_map = mappers[Color];
  }
  void draw_rounded_rect(num x, num y, int w, int h, int radius) {
    // stolen from http://stackoverflow.com/a/7838871
    context.beginPath();
    context.moveTo(x+radius, y);
    context.arcTo(x+w, y,   x+w, y+h, radius);
    context.arcTo(x+w, y+h, x,   y+h, radius);
    context.arcTo(x,   y+h, x,   y,   radius);
    context.arcTo(x,   y,   x+w, y,   radius);
    context.closePath();
  }

  void render_entity(int e) {
    Position pos = pos_map.get_component(e);
    Size size = size_map.get_component(e);
    Color color = color_map.get_component(e);

    context.fillStyle = color.color;
    draw_rounded_rect(pos.x, pos.y, size.width, size.height, 5);
    context.fill();
  }
}
