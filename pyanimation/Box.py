class Box:
  def __init__(self, x, y, width, height):
    self.x = x
    self.y = y
    self.width = width
    self.height = height

  def draw(self, canvas):
    canvas.create_rectangle(self.x, self.y, self.x + self.width, self.y + self.height)