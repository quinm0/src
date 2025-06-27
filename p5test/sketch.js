class Ball {
  constructor(x, y, dx, dy, radius, freq = 262, amp = 0.1) {
    this.x = x;
    this.y = y;
    this.dx = dx;
    this.dy = dy;
    this.radius = radius;
    this.freq = freq;
    this.amp = amp;
  }

  move() {
    this.x += this.dx;
    this.y += this.dy;
  }

  checkBounce(width, height) {
    let bounced = false;
    if (this.x - this.radius < 0 || this.x + this.radius > width) {
      this.dx *= -1;
      bounced = true;
    }
    if (this.y - this.radius < 0 || this.y + this.radius > height) {
      this.dy *= -1;
      bounced = true;
    }
    if (bounced) {
      playPing(millis(), this.freq, this.amp);
    }
  }

  draw() {
    fill(255);
    noStroke();
    circle(this.x, this.y, this.radius * 2);
  }
}

let balls = [];

function setup() {
  createCanvas(400, 400);
  balls.push(new Ball(width / 2, height / 2, 3, 2, 50, 262, 0.1));
  // balls.push(new Ball(100, 100, 2, 3, 30, 330, 0.15));
  // balls.push(new Ball(300, 300, -2, -3, 40, 440, 0.2));
  
  // Add more balls as needed
}

/**
 * Plays a ping sound when called.
 */
function playPing(time, freq = 262, amp = 0.1) {
  let pingOsc = new p5.Oscillator(freq, 'square');
  pingOsc.amp(amp, 0.01);
  pingOsc.start();
  setTimeout(() => {
    pingOsc.stop();
    pingOsc.dispose();
  }, 100);
}

function draw() {
  background(220);

  // Draw walls
  stroke(0);
  strokeWeight(4);
  noFill();
  rect(0, 0, width, height);

  // Move, check bounce, and draw each ball
  for (let ball of balls) {
    ball.move();
    ball.checkBounce(width, height);
    ball.draw();
  }
}
