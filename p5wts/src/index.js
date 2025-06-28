import { createCanvas } from "p5";

// testasdf
console.log('hello world', P5.Color.length)

function setup() {
  //creates a canvas 600 pixels wide
  //and 400 pixels high
  createCanvas(600, 400);
}

function draw() {
  //sky blue background
  background(135, 206, 235);
  //sun in top right
  fill("yellow");//yellow  

  stroke("orange"); //orange outline 

  strokeWeight(20); //large outline    

  circle(550, 50, 100);
 
  //grass on bottom half

  stroke(0);//black outline

  strokeWeight(1);//outline thickness

  fill("green");

  rect(0, 200, 600, 200);
 
  //emojis
  textSize(75)
  text("🌸", 100, 250) //flower
  text("🐞", 300, 250) //ladybug
}