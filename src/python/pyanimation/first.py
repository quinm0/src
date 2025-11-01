from tkinter import *
import time
import pyaudio
import numpy as np

WIDTH = 800
HEIGHT = 600
running = True
window = Tk()

canvas = Canvas(window, width=WIDTH, height=HEIGHT)
canvas.pack()

rect_vel_x = 1  # Velocity in the x direction
rect_vel_y = 1  # Velocity in the y direction


# Make a rectangle
rectangle = canvas.create_rectangle(50, 50, 200, 200, fill="blue")

# PyAudio settings
PyAudio = pyaudio.PyAudio  # Instantiate PyAudio
RATE = 44100  # Hertz
DURATION = 0.1  # Seconds
INITIAL_FREQ = 440.0  # Hz sine frequency
f = INITIAL_FREQ
collision_count = 0
RESET_INTERVAL = 4

# Grid settings
GRID_SIZE = 50
grid_boxes = []

def play_tone():
  global running, f
  p = PyAudio()
  stream = p.open(format=pyaudio.paFloat32,
          channels=1,
          rate=RATE,
          output=True)

  while running:
    samples = (np.sin(2*np.pi*np.arange(RATE*DURATION)*f/RATE)).astype(np.float32)
    stream.write(samples)

  stream.stop_stream()
  stream.close()

  p.terminate()

def check_collision(x1, y1, x2, y2):
    for box in grid_boxes:
        box_x1, box_y1, box_x2, box_y2 = canvas.coords(box)
        if x1 < box_x2 and x2 > box_x1 and y1 < box_y2 and y2 > box_y1:
            return True
    return False

def update():
  global rect_vel_x, rect_vel_y, running, f, collision_count

  if not running:
    return

  # Move the rectangle
  canvas.move(rectangle, rect_vel_x, rect_vel_y)

  # Get the current position of the rectangle
  x1, y1, x2, y2 = canvas.coords(rectangle)

  # Check for collision with the walls
  collision = False
  if x1 <= 0 or x2 >= WIDTH:
    rect_vel_x = -rect_vel_x  # Reverse direction in x
    collision = True
  if y1 <= 0 or y2 >= HEIGHT:
    rect_vel_y = -rect_vel_y  # Reverse direction in y
    collision = True

  # Check for collision with grid boxes
  if check_collision(x1, y1, x2, y2):
      rect_vel_x = -rect_vel_x
      rect_vel_y = -rect_vel_y
      collision = True

  if collision:
    f *= 1.5  # Increase frequency on collision
    collision_count += 1
    if collision_count % RESET_INTERVAL == 0:
      f = INITIAL_FREQ  # Reset frequency every RESET_INTERVAL collisions

  window.after(10, update)  # Call update again after 10 milliseconds

def stop():
  global running
  running = False

def create_grid_box(event):
    x = event.x // GRID_SIZE * GRID_SIZE
    y = event.y // GRID_SIZE * GRID_SIZE
    box = canvas.create_rectangle(x, y, x + GRID_SIZE, y + GRID_SIZE, fill="red")
    grid_boxes.append(box)

# Create grid lines for visual reference
for i in range(0, WIDTH, GRID_SIZE):
    canvas.create_line(i, 0, i, HEIGHT, fill="gray")
for i in range(0, HEIGHT, GRID_SIZE):
    canvas.create_line(0, i, WIDTH, i, fill="gray")

canvas.bind("<Button-1>", create_grid_box)

import threading
tone_thread = threading.Thread(target=play_tone)
tone_thread.daemon = True
tone_thread.start()

# run main loop
update()

window.mainloop()