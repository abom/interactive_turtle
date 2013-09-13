class TurtlePixmap < Qt::GraphicsPixmapItem

  def initialize(pixmap = Qt::Pixmap.new('turtle.png'))
    super(pixmap)
    self.zValue = 1
    self.transformOriginPoint = self.boundingRect.center
  end

  def resizeEvent(event)
    self.transformOriginPoint = self.boundingRect.center
  end

  def move(point)
    if point.kind_of? Array and point.length == 2
      x, y = point
    elsif point.kind_of? Qt::PointF
      x = point.rx
      y = point.ry
    else
      raise ArgumentError
    end
    self.x = x - self.boundingRect.width / 2.0
    self.y = y - self.boundingRect.height / 2.0
  end

  def rotate(angle)
    self.rotation = angle
  end
end