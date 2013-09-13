class TurtleView < Qt::GraphicsView

  def initialize(parent = nil)
    super(parent)
    #self.horizontalScrollBarPolicy = Qt::ScrollBarAlwaysOff
    #self.verticalScrollBarPolicy = Qt::ScrollBarAlwaysOff
  end

  # # http://stackoverflow.com/questions/4689709/qgraphicsview-disable-automatic-scrolling
  # def resizeEvent
  #   fitView
  # end

  # def showEvent
  #   fitView
  # end

  # def fitView
  #   rect = self.scene.itemsBoundingRect
  #   self.fitInView(rect, Qt::KeepAspectRatio)
  #   self.sceneRect = rect
  # end
end