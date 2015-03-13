part of breakout_common;

class Position extends Component {
  double x;
  double y;
  Position(this.x, this.y);
}
class Velocity extends Component {
  double x;
  double y;
  Velocity(this.x, this.y);
}
class Size extends Component {
  int width;
  int height;
  Size(this.width, this.height);
}
class Renderable extends Component {
  String type;
  Renderable(this.type);
}
class Paddle extends Component {
  int paddle_id;
  Set<String> powerups;
  Paddle(this.paddle_id) { 
    powerups = new Set<String>();
  }
}
class Ball extends Component {
  Ball();
}
class Brick extends Component {
  String powerup = null;
  Brick({this.powerup});
}
class PowerUp extends Component {
  static const List<String> types = const ['ShrinkBall', 'EnlargeBall', 'ShrinkPaddle', 'EnlargePaddle', 'ExtraBall'];
  String powerup;
  PowerUp(this.powerup);
}
class Color extends Component {
  String color;
  Color(this.color);
}
class Collidable extends Component {
  Collidable();
}

List<Type> component_types = [Position, Velocity, Size, Renderable, Paddle, Ball, Brick, Collidable, Color, PowerUp];
