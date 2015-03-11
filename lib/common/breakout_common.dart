library breakout_common;

import 'package:entity_component/entity_component_common.dart';

part 'src/components.dart';

final Set<String> server_transmit = new Set.from(["ServerPing", "NewPlayerCreated", "ServerPaddleUpdate", "PlayerLeft", "NewBallCreated", "ServerBallUpdate", "BallDeath", "NewBrickCreated","ServerBrickUpdate","NewPowerUpCreated", "ServerPowerUpUpdate","PowerUpDeath", "WallBounce", "PaddleBounce", "BrickBounce", "BrickBreak"]);

final Set<String> client_transmit = new Set.from(["RequestNewPlayer", "MoveLeft", "MoveRight", "StopLeft", "StopRight", "ClientPaddleUpdate"]);
