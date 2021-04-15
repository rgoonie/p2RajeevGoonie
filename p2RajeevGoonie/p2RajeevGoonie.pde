private final double[] GEAR_RATIOS = {3.4, 2.75, 1.77, 0.93, 0.71, 0.64};
private final int tireDiameter = 19; //19 inches
private int currentGear = 1;
private int rpm = 0;
private int speed = 0;
private double odometer = 76454.1;
private boolean isAccelerating = false;

private boolean leftSignal = false;
private boolean rightSignal = false;
private boolean hazardSignal = false;
private boolean signalOscillator = false;
private int timer;

private boolean cruiseControl = false;

private PShape fuelIcon;
private double fuelPercentage = 0.75;

private PShape coolantIcon;
private double coolantPercentage = 0.40;

private PShape oilPressureIcon;
private double oilPressurePercentage = 0.55;

private PShape highBeamIcon;
private boolean isHighBeamOn = false;

private PShape lowBeamIcon;
private boolean isLowBeamOn = false;

private PShape fogLightIcon;
private boolean isFogLightOn = false;

private PShape parkingBrakeIcon;
private boolean isParkingBrakeOn = false;

private PShape seatBeltWarningIcon;
private boolean isSeatBeltWarningOn = false;

private PShape openDoorIcon;
private boolean isDoorOpen = false;

private PShape fuelWarningIcon;
private boolean isFuelLow = false;

private PShape checkEngineIcon;
private boolean isCheckEngineOn = false;

private PShape genericWarningIcon;
private boolean isGenericWarningOn = false;

private PShape airBagWarningIcon;
private boolean isAirBagWarningOn = false; 

private PShape coolantWarningIcon;
private boolean isCoolantWarningOn = false; 

private PShape oilPressureWarningIcon;
private boolean isOilPressureWarningOn = false; 

private PShape brakeFailureWarningIcon;
private boolean isBrakeFailureWarningOn = false;

private PShape batteryWarningIcon;
private boolean isBatteryWarningOn = false;

public void setup(){
  size(1000, 500);
  frameRate(60);
  textAlign(CENTER, CENTER);
  timer = second();
  
  fuelIcon = loadShape("./assets/fuelIcon.svg");
  coolantIcon = loadShape("./assets/coolantIcon.svg");
  oilPressureIcon = loadShape("./assets/oilPressureIcon.svg");
  highBeamIcon = loadShape("./assets/highBeamIcon.svg");
  lowBeamIcon = loadShape("./assets/lowBeamIcon.svg");
  fogLightIcon = loadShape("./assets/fogLightIcon.svg");
  parkingBrakeIcon = loadShape("./assets/parkingBrakeIcon.svg");
  seatBeltWarningIcon = loadShape("./assets/seatBeltWarningIcon.svg");
  openDoorIcon = loadShape("./assets/openDoorIcon.svg");
  fuelWarningIcon = loadShape("./assets/fuelWarningIcon.svg");
  checkEngineIcon = loadShape("./assets/checkEngineIcon.svg");
  genericWarningIcon = loadShape("./assets/genericWarningIcon.svg");
  
  airBagWarningIcon = loadShape("./assets/airBagWarningIcon.svg");
  coolantWarningIcon = loadShape("./assets/coolantWarningIcon.svg");
  oilPressureWarningIcon = loadShape("./assets/oilPressureWarningIcon.svg");
  brakeFailureWarningIcon = loadShape("./assets/brakeFailureWarningIcon.svg");
  batteryWarningIcon = loadShape("./assets/batteryWarningIcon.svg");
}

public void draw(){
  clear();
  drawTachometer();
  drawSpeedometer();
  drawTurnSignals();
  drawOdometer();
  drawFuelGauge();
  drawCoolantTemperatureGauge();
  drawOilPressureGauge();
  drawWarningCenter();
  drawProblemCenter();
  
  //Calculations
  if(isAccelerating){
    rpm+=(25*GEAR_RATIOS[currentGear-1]);
    
    if(rpm >= 7200 && currentGear<GEAR_RATIOS.length){
       double oldGearRatio = GEAR_RATIOS[currentGear-1];
       currentGear++;
       double newGearRatio = GEAR_RATIOS[currentGear-1];
       rpm = (int)((rpm*newGearRatio)/oldGearRatio);
    }
    
    if(currentGear == GEAR_RATIOS.length && rpm>=10000){
      rpm=9750;
    }
    
  }
  else{
    //decrease rpm
    if(!cruiseControl)
      rpm-=25;
    
    if(rpm<=3500 && currentGear>1){
      double oldGearRatio = GEAR_RATIOS[currentGear-1];
       currentGear--;
       double newGearRatio = GEAR_RATIOS[currentGear-1];
       rpm = (int)((rpm*newGearRatio)/oldGearRatio);
    }
    if(currentGear == 1 && rpm<=0){
      rpm = 0;
    }
  }  
  
  //oscillator for signals
  if(leftSignal || rightSignal || hazardSignal){
    if(millis() - timer > 500){
      signalOscillator = !signalOscillator;
      timer = millis();
    }  
  }
  
  //adding to odometer
  double amountTraveled = speed/(60.0*60.0*60.0);
  odometer += amountTraveled;
}

private void drawTachometer(){
  //green section
  stroke(57,255,20);
  fill(57,255,20);
  rect(0,0,50,500);
  rect(0,0,600,50);
  //square(0,0,100);
  
  //yellow section
  stroke(255,204,0);
  fill(255,204,0);
  rect(600,0,100,50);
  
  //red section
  stroke(229,23,12);
  fill(243,32,19);
  rect(700,0,300,50);
  
  //increments
  stroke(0);
  fill(0);
  strokeWeight(5);
  for(int i = 400; i>=100; i-=150)
    line(25, i, 53, i);
    
  for(int i = 100; i<=850; i+=150)
    line(i,25, i, 53);
    
  //text
  textSize(10);
  text("RPM", 25,435);
  textSize(7.5);
  text("x1000", 25, 445);
  textSize(25);
  for(int i=375,j=1; j<=3; i-=150,j++)
    text(""+j,35,i);
  for(int i=125, j=4; j<=9; i+=150,j++)
  text(""+j,i,33);
  
  //gauge
  stroke(255);
  strokeWeight(1);
  if(0<=rpm && rpm<1000){
    triangle(0,-0.1*rpm+487.5, 0,-0.1*rpm+512.5,  12.5, -0.1*rpm+500);
  }
  if(1000<=rpm && rpm<3500){
    triangle(0,-0.15*(rpm-1000)+387.5, 0,-0.15*(rpm-1000)+412.5, 12.5, -0.15*(rpm-1000)+400);
  }
  if(3500<=rpm && rpm<=10000){
    triangle( 0.15*(rpm-4000)+87.5,0, 0.15*(rpm-4000)+112.5,0, 0.15*(rpm-4000)+100, 12.5);
  }
  
  //negative space
  stroke(60);
  fill(60);
  triangle(0,500, 50,500, 50,450);
  triangle(950,50, 1000,50, 1000,0);
  rect(50,50,950,450);
}

private void drawSpeedometer(){
  //box
  stroke(0);
  strokeWeight(7.5);
  fill(60);
  rect(400,150,200,250,2);
  
  //speed calc
  double wheelRPM = rpm/GEAR_RATIOS[currentGear-1];
  speed = (int)(wheelRPM * tireDiameter * PI * 60 * 0.30 / 63360); //formula found online
  
  //gauge
  stroke(0);
  fill(0);
  textSize(75);
  text(String.format("%d",speed),500,233);
  textSize(50);
  text("mph",500,300);
  
  //gear
  textSize(15);
  text(String.format("%d",currentGear), 585,165);
  
  //cruise control
  if(cruiseControl){
    stroke(57,255,20);
    fill(57,255,20);
    text("Cruise", 430, 382.5);
  }
  
  //outside temp
  stroke(255);
  fill(255);
  text(String.format("%3d"+(char)176+"F",100),572  ,382.5);
}

private void drawTurnSignals(){
   stroke(57,255,20);
   fill(57,255,20);
   
   //left
   if( (leftSignal || hazardSignal) && signalOscillator ){
     triangle(425,100, 446,80, 446,120);
     square(450,87.5,25);
   }
   
   //right
   if( (rightSignal || hazardSignal) && signalOscillator ){
     triangle(575,100, 554,80, 554,120);
     square(525,87.5,25);
   }
}

private void drawOdometer(){
  stroke(0);
  strokeWeight(3.5);
  fill(60);
  rect(400,425,200,50,2);
  
  fill(0);
  textSize(20);
  text(String.format("%09.1f miles", odometer), 500,450);
}

private void drawFuelGauge(){
  //fuel bar
  stroke(255,204,0);
  fill(255,204,0);
  rect(100.0, 187.5, (int)(200*fuelPercentage), 25.0);
  
  //black lines
  stroke(0);
  strokeWeight(3);
  line(103,200,300,200);
  strokeWeight(7.5);
  line(300,175,300,225);
  
  //red lines
  stroke(229,23,12);
  line(100,175,100,225);
  strokeWeight(3);
  line(102,200,149,200);
  
  //increments
  stroke(0);
  strokeWeight(2);
  line(200,181.25,200,218.75);
  line(150,187.5,150,212.5);
  line(250,187.5,250,212.5);
  
  //letters
  fill(229,23,12);
  textSize(27.5);
  text("E", 100, 150);
  fill(0);
  text("F", 300, 150);
  
  //icon
  shape(fuelIcon, 310, 175,50,50);
}

private void drawCoolantTemperatureGauge(){
  //fuel bar
  stroke(255,204,0);
  fill(255,204,0);
  rect(700, 187.5, (int)(200*coolantPercentage), 25.0);
  
  //black lines
  stroke(0);
  strokeWeight(3);
  line(700,200,900,200);
  strokeWeight(7.5);
  line(700,175,700,225);
  
  //red lines
  stroke(229,23,12);
  line(900,175,900,225);
  strokeWeight(3);
  line(852,200,900,200);
  
  //increments
  stroke(0);
  strokeWeight(2);
  line(800,181.25,800,218.75);
  line(750,187.5,750,212.5);
  line(850,187.5,850,212.5);
  
  //letters
  fill(229,23,12);
  textSize(27.5);
  text("H", 900, 150);
  fill(0);
  text("L", 700, 150);
  
  //icon
  shape(coolantIcon, 915, 175, 50, 50);
}

private void drawOilPressureGauge(){
  //fuel bar
  stroke(255,204,0);
  fill(255,204,0);
  rect(700, 287.5, (int)(200*oilPressurePercentage), 25.0);
  
  //black lines
  stroke(0);
  strokeWeight(3);
  line(700,300,900,300);
  strokeWeight(7.5);
  line(900,275,900,325);
  
  //red lines
  stroke(229,23,12);
  line(700,275,700,325);
  strokeWeight(3);
  line(700,300,748,300);
  
  //increments
  stroke(0);
  strokeWeight(2);
  line(800,281.25,800,318.75);
  line(750,287.5,750,312.5);
  line(850,287.5,850,312.5);
  
  //letters
  fill(229,23,12);
  textSize(27.5);
  text("L", 700, 250);
  fill(0);
  text("", 900, 250);
  
  //icon
  shape(oilPressureIcon, 915, 275, 50, 50);
}

private void drawWarningCenter(){
  stroke(0);
  fill(0);
  strokeWeight(4);
  rect(112.5,262.5,175, 175, 2);
  
  textSize(23.1);
  text("Warning Center", 201, 452.5);
  
  if(isHighBeamOn){
    shape(highBeamIcon, 130,287.5, 40,25);
  }
  if(isLowBeamOn){
    shape(lowBeamIcon, 130,337.5, 40,30);
  }
  if(isFogLightOn){
    shape(fogLightIcon, 130,387.5, 40,30);
  }
  if(isParkingBrakeOn){
    shape(parkingBrakeIcon, 181,285, 40,30);
  }
  if(isSeatBeltWarningOn){
    shape(seatBeltWarningIcon, 180,330, 40,40);
  }
  if(isDoorOpen){
    shape(openDoorIcon, 183,384, 35,35);
  }
  if(isFuelLow){
    shape(fuelWarningIcon, 235,283, 35,35);
  }
  if(isCheckEngineOn){
    shape(checkEngineIcon, 230,335, 40,30);
  }
  if(isGenericWarningOn){
    shape(genericWarningIcon, 234,385, 35,30);
  }
}

private void drawProblemCenter(){
  stroke(0);
  fill(0);
  rect(712.5,353,175,94,2);
  
  textSize(23.1);
  text("Problem Center", 800, 462);
  
  if(isAirBagWarningOn){
    shape(airBagWarningIcon, 735, 363, 30, 30);
  }
  if(isCoolantWarningOn){
    shape(coolantWarningIcon, 785, 363, 30, 30);
  }
  if(isOilPressureWarningOn){
    shape(oilPressureWarningIcon, 830, 371, 40, 17);
  }
  if(isBrakeFailureWarningOn){
    shape(brakeFailureWarningIcon, 757.5, 413, 35, 26);
  }
  if(isBatteryWarningOn){
    shape(batteryWarningIcon, 810, 414, 30, 21);
  }
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

//interaction
public void keyPressed(){  
  //accelerator (space bar)
  if(keyCode == 32)
    isAccelerating = true;

}

public void keyReleased(){
  
  //accelerator (space bar)
  if(keyCode == 32)
    isAccelerating = false;
    
  //left signal toggle
  if(keyCode == LEFT){
    leftSignal = !leftSignal;
    rightSignal = false;
    timer = millis();
  }
  
  //right signal toggle
  if(keyCode == RIGHT){
    rightSignal = !rightSignal;
    leftSignal = false;
    timer = millis();
  }
  
  //hazards toggle
  if(keyCode == UP){
    hazardSignal = !hazardSignal;
    timer = millis();
  }
  
  //cruise control toggle (c)
  if(keyCode == 67){
    cruiseControl = !cruiseControl;
  }
  
  //high beam toggle (h)
  if(keyCode == 72){
    isHighBeamOn = !isHighBeamOn;
  }
  
  //low beam toggle (l)
  if(keyCode == 76){
    isLowBeamOn = !isLowBeamOn;
  }
  
  //fog light toggle (f)
  if(keyCode == 70){
    isFogLightOn = !isFogLightOn;
  }
  
  //parking brake toggle (p)
  if(keyCode == 80){
    isParkingBrakeOn = !isParkingBrakeOn;
  }
  
  //seat belt toggle (s)
  if(keyCode == 83){
    isSeatBeltWarningOn = !isSeatBeltWarningOn;
  }
  
  //door toggle (d)
  if(keyCode == 68){
    isDoorOpen = !isDoorOpen;
  }
  
  //check engine toggle (e)
  if(keyCode == 69){
    isCheckEngineOn = !isCheckEngineOn;
  }
  
  //generic warning toggle (g)
  if(keyCode == 71){
    isGenericWarningOn = !isGenericWarningOn;
  }
  
  //airbag warning toggle (a)
  if(keyCode == 65){
    isAirBagWarningOn = !isAirBagWarningOn;
  }
  
  //battery warning toggle (b)
  if(keyCode == 66){
    isBatteryWarningOn = !isBatteryWarningOn;
  }
  
  //brake failure toggle (q)
  if(keyCode == 81){
    isBrakeFailureWarningOn = !isBrakeFailureWarningOn; 
  }
}

public void mouseWheel(MouseEvent e){
  double change = 0.05 * -e.getCount();
  if(100<=mouseX && mouseX<=300 && 175<=mouseY && mouseY<=225){
    fuelPercentage += change;
    if(fuelPercentage > 1)
      fuelPercentage = 1;
    else if(fuelPercentage < 0)
      fuelPercentage = 0;
      
    if(fuelPercentage < 0.25)
      isFuelLow = true;
    else
      isFuelLow = false;
  }
  
  if(700<=mouseX && mouseX<=900 && 175<=mouseY && mouseY<=225){
    coolantPercentage += change;
    if(coolantPercentage > 1)
      coolantPercentage = 1;
    else if(coolantPercentage < 0)
      coolantPercentage = 0;
      
    if(coolantPercentage >= 0.75)
      isCoolantWarningOn = true;
    else
      isCoolantWarningOn = false;
  }
  
  if(700<=mouseX && mouseX<=900 && 275<=mouseY && mouseY<=325){
    oilPressurePercentage += change;
    if(oilPressurePercentage > 1)
      oilPressurePercentage = 1;
    else if(oilPressurePercentage < 0)
      oilPressurePercentage = 0;
      
    if(oilPressurePercentage < 0.25)
      isOilPressureWarningOn = true;
    else
      isOilPressureWarningOn = false;
  }
}
