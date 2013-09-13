require 'Qt4'
require './turtle_scene'
require './turtle_pixmap'
require './turtle_view'

class InteractiveTurtle < Qt::Widget
  slots :do_steps,
        :on_startBtn_clicked,
        :on_pauseBtn_clicked,
        :on_resumeBtn_clicked,
        'on_speedSlider_valueChanged(int)',
        'set_view_rect(const QList<QRectF> &)'

  # signals :drawingStarted,
  #         :drawingFinished,
  #         'drawing(qreal, qreal)'

  attr_accessor :draw_block, :speed
  attr_reader :timer


  Commands = [:background, :pensize, 
              :pencolor, :forward, 
              :backward, :goto, 
              :turnright, :turnleft,
              :setheading, :width, 
              :height]

  def initialize(parent = nil)
    super(parent)
    self.windowTitle = "Interactive Turtle"
    self.windowIcon = Qt::Icon.new('turtle.png')
    resize(800, 600)
    
    @steps = []#{}

    @scene = TurtleScene.new
    @turtle = TurtlePixmap.new
    # even with zero speed
    # it take time to finish the 'steps'
    @speed = 50
    @timer = Qt::Timer.new
    @timer.interval = @speed

    initComponents
    addTurtlePixmap

    connect(@timer, SIGNAL('timeout()'), self, SLOT(:do_steps))
    connect(@scene, SIGNAL('changed(const QList<QRectF> &)'), self, SLOT('set_view_rect(const QList<QRectF> &)'))

    Qt::MetaObject.connectSlotsByName(self)
  end

  def addTurtlePixmap
    @scene.addItem(@turtle)
    @turtle.move(@scene.center)
    @view.ensureVisible(@turtle)
  end

  def method_missing(m, *args, &b)
    if Commands.include? m
      step(m, *args) { @scene.send(m, *args) }
    elsif !self.respond_to?(m) and @scene.respond_to?(m)
      #self.methods - @scene.methods
      @scene.send m, *args, &b
    else
      super
    end
  end

  def initComponents
    @view = TurtleView.new
    @view.scene = @scene

    @splitter = Qt::Splitter.new(Qt::Horizontal)

    @startBtn = Qt::PushButton.new("&Start")
    @startBtn.objectName = "startBtn"

    @pauseBtn = Qt::PushButton.new("&Pause")
    @pauseBtn.objectName = "pauseBtn"

    @resumeBtn = Qt::PushButton.new("&Resume")
    @resumeBtn.objectName = "resumeBtn"

    @hboxBtns = Qt::HBoxLayout.new
    @hboxBtns.addWidget(@startBtn)
    @hboxBtns.addWidget(@pauseBtn)
    @hboxBtns.addWidget(@resumeBtn)

    #TODO CONTROL
    @startBtn.enabled = true
    @pauseBtn.enabled = false
    @resumeBtn.hide

    @treeSteps = Qt::TreeWidget.new
    @treeSteps.columnCount = 2
    @treeSteps.headerLabels = ['Command', 'Parameters']

    @speedLabel = Qt::Label.new('Speed:')
    @speedSlider = Qt::Slider.new(Qt::Horizontal)
    @speedSlider.setRange(0.0, 1000.0)
    @speedSlider.value = @speed
    @speedSlider.objectName = "speedSlider"

    @speedhbox = Qt::HBoxLayout.new
    @speedhbox.addWidget(@speedLabel)
    @speedhbox.addWidget(@speedSlider)

    @vboxControl = Qt::VBoxLayout.new
    @vboxControl.addWidget(@treeSteps)
    @vboxControl.addLayout(@speedhbox)
    @vboxControl.addLayout(@hboxBtns)

    @controlWidget = Qt::Widget.new
    @controlWidget.layout = @vboxControl

    @splitter.addWidget(@view)
    @splitter.addWidget(@controlWidget)
    @splitter.sizes = [550, 250]
    self.layout = Qt::VBoxLayout.new {|l| l.addWidget(@splitter) }
  end

  # for testing
  def self.start(&b)
    t = self.new
    t.draw_block = b
    #t.instance_eval(&b)
    t.show #tmpry
    #t.draw
  end
  
  def on_startBtn_clicked
    #FIXME: should be moved to signals or separated methods
    @startBtn.enabled = false
    @pauseBtn.enabled = true

    @scene.removeItem(@turtle) if @scene.items.include?(@turtle)
    @scene.reset
    addTurtlePixmap
    
    @start_point = [@scene.x, @scene.y]
    self.instance_eval(&draw_block)
    @timer.start
  end

  def on_pauseBtn_clicked
    @timer.stop
    @pauseBtn.hide
    @resumeBtn.show
  end

  def on_resumeBtn_clicked
    @timer.start
    @pauseBtn.show
    @resumeBtn.hide
  end

  def on_speedSlider_valueChanged(value)
    p value
    @speed = value
    @timer.interval = value
  end

  def step(name = :command, *args, &b)
    #TODO: comands tree (will slow down drawing)
    @steps << b
  end

  def do_step(step, &b)
    Qt::Timer.singleShot(@speed * step, self) {b.call}
  end

  def finish_drawing
    @turtle.move(@start_point)
    @turtle.rotate(0)

    @startBtn.enabled = true
    @pauseBtn.enabled = false
    @pauseBtn.show
    @resumeBtn.hide

    @timer.stop
  end

  def drawing?
    !@steps.empty? and @timer.isActive
  end

  def do_steps
    # background, pensize, pencolor..etc
    # shouldn't wait for the interval?
    if @steps.empty?
      finish_drawing
      #emit drawingFinished
    else
      step = @steps.shift
      step.call
      @turtle.move([@scene.x, @scene.y])
      @turtle.rotate(@scene.dir + 90)
      #emit drawing(@x, @y)
    end
    #@view.centerOn(@turtle.pos)
  end

  def set_view_rect(region)
    @view.sceneRect = @scene.itemsBoundingRect #| Qt::RectF.new(rect.width + 20, rect.height + 20, 20, 20)
  end
end


if $0 == __FILE__

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
end