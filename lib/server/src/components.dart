part of breakout_server;

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
class Paddle extends Component {
  int paddle_id;
  Paddle(this.paddle_id);
}
class Ball extends Component {
  Ball();
}
class Brick extends Component {
  //Powerup powerup; // use enum
  Brick();
}
class Color extends Component {
  String color;
  //Powerup powerup; // use enum
  Color(this.color);
}
class Collidable extends Component {
  Collidable();
}

List<Type> component_types = [Position, Velocity, Size, Paddle, Ball, Brick, Collidable, Color];
