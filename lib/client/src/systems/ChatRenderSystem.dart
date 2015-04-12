part of breakout_client;

class ChatRenderSystem extends System {

  CanvasElement canvas;
  CanvasRenderingContext2D context;


  ChatRenderSystem(BreakoutClientWorld world) : super(world) {
    components_wanted = null;
  }

  void set_context(CanvasElement canv) {
    this.canvas = canv;

    context = canvas.context2D;
  }

  void initialize() {
    set_context(world.canvas);
    context.font = "12pt Sans Serif";
  }

  void process() {
    int height = canvas.height-20;
    context.fillStyle="rgba(255,255,255,0.5)";
    for (String s in world.chat_messages.reversed) {
      if (s != null) {
        context.fillText(s, 10, height);
        height-=20;
      }
    }
  }
}
