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
  Paddle(this.paddle_id);
}
class Ball extends Component {
  Ball();
}
class Brick extends Component {
  Brick();
}
class Color extends Component {
  String color;
  Color(this.color);
}
class Collidable extends Component {
  Collidable();
}

List<Type> component_types = [Position, Velocity, Size, Renderable, Paddle, Ball, Brick, Collidable, Color];