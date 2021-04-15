public void setup(){
  size(1000, 500);
  frameRate(30);
  textAlign(CENTER, CENTER);
}

public void draw(){
  clear();
  background(0);
  drawTachometer();
  //drawGrid();
}

private void drawTachometer(){
  //green section
  stroke(57,255,20);
  fill(57,255,20);
  rect(0,0,50,500);
  rect(0,0,600,50);
  square(0,0,100);
  
  //yellow section
  stroke(255,204,0);
  fill(255,204,0);
  rect(600,0,100,50);
  
  //red section
  stroke(243,32,19);
  fill(243,32,19);
  rect(700,0,300,50);
  
  stroke(0);
  fill(0);
  triangle(0,500, 50,500, 50,450);
  triangle(50,100, 100,100, 100,50);
  triangle(950,50, 1000,50, 1000,0);
}

//This is used for referencing
private void drawGrid(){
  stroke(255,110,199);
  strokeWeight(1);
  
  //horizontal
  for(int i = 0; i<=500; i+=50)
    line(0, i, 1000, i);
  
  //vertical
  for(int i = 0; i<=1000; i+=50)
    line(i, 0, i, 500);
}
