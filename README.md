interactive_turtle
==================

turtle graphics with QtRuby and Hackety Hack style.
with the help of kidsruby, turtle wax and hackety hack code.

could it be a replacement for turtle wax in KidsRuby?

for testing:

``` ruby
require 'interactive_turtle'

app = Qt::Application.new(ARGV)

InteractiveTurtle.start do
  background lightblue
  pensize 2
  4.times do
    forward 100
    turnleft 90
  end
end

app.exec
```
and the scene might be used directly also:

``` ruby
require 'turtle_scene'

app = Qt::Application.new(ARGV)

TurtleScene.start do
  background lavender
  pensize 2
  pencolor red
  36.times do
    36.times do
      pencolor random_color
      forward 10
      turnright 10
    end
    turnright 10
  end
end

app.exec
```


it's a try and not complete.

## Current Features
* It can change pen color while drawing.
* Start, stop and resume controls.
* Different drawing speeds.

## Drawbacks
* it uses QTimer (less interval, more cpu load?).
* limited speed with large drawing.
* others!
