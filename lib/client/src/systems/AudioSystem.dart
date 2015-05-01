part of breakout_client;

class AudioSystem extends System {
  LinkedHashMap<String, AudioElement> sounds;

  bool muted = false;

  AudioSystem(BreakoutClientWorld world) : super(world) {
    components_wanted = null;
    sounds = new LinkedHashMap<String, AudioElement>();
  }

  void initialize() {
    load_sounds();
    register_sounds();
    world.subscribe_event("ToggleMute", (e){muted = !muted;});
  }

  void load_sounds() {
    // at some point could probably load sounds from a json file or something
    sounds['BallDeath'] = new AudioElement()..src='packages/dart_breakout/assets/sound/balldeath.wav';
    sounds['BrickBounce'] = new AudioElement()..src='packages/dart_breakout/assets/sound/brickbreak.wav';
    sounds['PaddleBounce'] = new AudioElement()..src='packages/dart_breakout/assets/sound/paddlebounce.wav';
    sounds['PowerUpCollision'] = new AudioElement()..src='packages/dart_breakout/assets/sound/powerup.wav';
  }

  void register_sounds() {
    sounds.forEach((event,ele){
      ele.onCanPlay.first.then((e) { // no error handling here. just, when it is possible to play, start listening
        world.subscribe_event(event, play_sound);// eventually maybe do a subscribe_event_immediate so there's not a frame delay?
      });
    });
  }

  void play_sound(Map event) {
    if (!muted) {
      sounds[event["EVENT_TYPE"]].play();
    }
  }
}
