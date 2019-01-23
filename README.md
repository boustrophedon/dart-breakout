dart-breakout
=============

NOTE: This project is originally from 2014/2015. I recently updated this project to Dart 2, and encountered a few minor problems, mostly with Map literals having too tightly-bound types. The code itself is kind of okay but not really at my current standards, and the design of the entity component system is a bit too dynamic: it uses a lot of strings and heterogeneous maps for the events instead of using enums and actual classes. There also aren't any tests, which is a dealbreaker for present-day Harry but apparently wasn't for 2014 Harry. How time flies.

but hey, at least i shipped it. to try it out, run the server with `dart bin/server.dart` and then run the client with `webdev serve` and open the link in your browser.

the old readme follows, with some updates to the todo section:


i have been doing non-public code for a research project for a while now, and i meant to do this project a long time ago. let's build a breakout clone. let's make it networked.

current progress: you can run a server and have clients join it and they can see each others' paddles move around, there is a ball, there are bricks that break when you hit them. the velocity of the ball is affected by where it hits the paddle. powerups for enlarging and shrinking the balls and paddles drop, as well as extra ball powerups. they all look the same.

todo: it would be neat to either have paddles shrink proportionate to the number of players, or to have the world scrollable. also client prediction for the ball and possibly for other players would be nice. and pruning for collision testing using a quadtree or something. the bricks are static so at least that much should be easy. it would be nice to have better/more powerups. 
