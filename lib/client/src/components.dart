part of breakout_client;

class Position extends Component {
  int x;
  int y;
  Position(this.x, this.y);
}
class Velocity extends Component {
  int x;
  int y;
  Velocity(this.x, this.y);
}
class Size extends Component {
  int height;
  int width;
  Size(this.height, this.width);
}
class Renderable extends Component {
  String type;
  Renderable(this.type);
}

class Moveable extends Component {
  Moveable();
}
