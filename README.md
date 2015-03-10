dart-breakout
=============

i have been doing non-public code for a research project for a while now, and i meant to do this project a long time ago. let's build a breakout clone. let's make it networked.

current progress: you can run a server and have clients join it and they can see each others' paddles move around, there is a ball, there are bricks that break when you hit them. the velocity of the ball is affected by where it hits the paddle.

todo: it would be nice to have powerups. needs audio. it would be neat to either have paddles shrink proportionate to the number of players, or to have the world scrollable. also client prediction for the ball and possibly for other players would be nice. and pruning for collision testing using a quadtree or something. the bricks are static so at least that much should be easy.
