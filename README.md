Interactive Turtle
==================

Turtle graphics in QtRuby and Hackety Hack style,
with the help of KidsRuby, Turtle Wax and Hackety Hack code.

Could it be a replacement for turtle wax in KidsRuby?

For testing:

```
ruby interactive_turtle.rb
```

You can edit:

``` ruby
  InteractiveTurtle.start do
    # ...
  end
```

with the steps you want, and the scene might be used directly also:

``` ruby
require 'Qt4'
require './turtle_scene'

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

## Dependencies
* QtRuby
```
gem install qtbindings
```

## Current Features
* It can change pen color while drawing.
* Start, stop and resume controls.
* Different drawing speeds.

## Drawbacks
* It uses QTimer (less interval, more cpu load?).
* Limited speed with large drawing.
* It's a try (not yet completed).
* Others!

