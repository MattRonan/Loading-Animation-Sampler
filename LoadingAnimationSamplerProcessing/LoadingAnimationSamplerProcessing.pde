/* 2016-2022 Matt Ronan
*  Licensed under the Apache License, Version 2.0 (the "License");
*
*
* Loading animation sampler platter in Processing
* 'd' to switch design
* 'p' to pause
* (click inside drawing window first)
*/

int bgVal = 0;
boolean paused = false;
int unlockMoment = 0;
int designType = 0;

StatusWheel statusWheel;

void setup(){
  size(150,150);
  imageMode(CENTER);
  setDesignType();
}

void draw(){
  
  if(!paused){
  statusWheel.display();
  }
  
  if(keyPressed){
    if(key == 'p' && millis() > unlockMoment){
      unlockMoment = millis() + 100;
      if(paused){
        paused = false; 
      }
      else{
        paused = true; 
      }
    }
    if(key == 'd' && millis() > unlockMoment){
      designType++;
      if(designType > 5){
        designType = 0; 
      }
      setDesignType();
      unlockMoment = millis() + 100;
    }
  }
}

class StatusWheel{
  
  int numPoints;
  int pointHeadSize;
  float radius;
  PGraphics wheel;
  long frameStamp;
  int posCounter = 360;
  float pointSizeDecrementer;
  float minPointSize = 1;
  float randomness = .1;
  int toggle = 0;
  int[] color1 = {0,255,255}; //default cyan
  int[] color2 = {255,220,0};//default orange
  boolean doStroke = true;
  int[] sCol = {255,255,255};
  
   StatusWheel(int numPoints, int pointHeadSize, int dim){
    this.numPoints = numPoints;
    this.pointHeadSize = pointHeadSize;
    this.radius = dim/2;
    pointSizeDecrementer = (pointHeadSize - minPointSize)/(numPoints);
    frameStamp= frameCount;
    wheel = createGraphics(dim+75,dim+75);
    wheel.beginDraw();
   } 
 
   void setRandom(float r){
     randomness = r; 
   }
   void setColor1(int r, int g, int b){
     color1[0] = r;
     color1[1] = g;
     color1[2] = b;
   }
   void setColor2(int r, int g, int b){
     color2[0] = r;
     color2[1] = g;
     color2[2] = b;
   }
   void setStrokeWeight(int w){
      wheel.strokeWeight(w);
   }
   void setStrokeColor(int r, int g, int b){
     sCol[0] = r;
     sCol[1] = g;
     sCol[2] = b;
   }
   void drawASplash(int ss){
    
     float pointSize = pointHeadSize;
     int opacity = 255;

     int start,end,dec;
     
     
     start = 0; end = numPoints; dec = 1; //run forward
     //start = numPoints-1; end = 0; dec = -1; //run backward
     for(int i = start; i != end; i += dec){
    
      if(ss == 0 ){
        wheel.fill(color1[0],color1[1],color1[2],opacity);
        if(doStroke){
          wheel.stroke(sCol[0],sCol[1],sCol[2],200); //you can use 'opacity' here but I thought a static opacity looked better for whatever reason
        }
      }
      else if(ss == 1){
        wheel.fill(color2[0],color2[1],color2[2],opacity);
        if(doStroke){
          wheel.stroke(sCol[0],sCol[1],sCol[2],200);
        }
      }
       
      wheel.ellipse(  (wheel.width/2)+(cos(radians((posCounter+(ss*180))+(i*4)))*radius)*(random(-1*randomness,1*randomness)*((float)i/numPoints))  ,  (wheel.height/2)+(sin(radians((posCounter+(ss*180))+(i*4)))*radius)+(random(-3*randomness,3*randomness)*((float)i/numPoints)) ,  pointSize,  pointSize);
      
      pointSize -= pointSizeDecrementer;
      
      opacity-=(255/numPoints/2);
   }
   //----------------------------------------
   }
   
   void display(){
        
        if(frameCount > frameStamp){
          
           if(!doStroke){ //if no stroke do this once here.  if stroke that happens each time in drawASplash cause we also add opacity per point
              wheel.noStroke();
           } 

          wheel.beginDraw();
          wheel.background(bgVal);
          
          if(toggle == 0){ //toggle stuff is only noticeable when using 2 different colored splashes
            for(int splashSide = 0; splashSide < 2; splashSide++){
              drawASplash(splashSide);
            }
          }
          else{
            for(int splashSide = 1; splashSide >= 0; splashSide--){
              drawASplash(splashSide);
            }
          }
          
          frameStamp = frameCount;
        
          wheel.endDraw();
          
          image(wheel,width/2,height/2);
          
          posCounter-=4;
          
          //this just sets the crossover point where splash A is draw on top of spash B and vise versa to give a better 3d feel with designs that have 2 different colors
          if(posCounter == 212){
           if(toggle == 0){ toggle = 1;}
           else{ toggle = 0;}
          }
          else if(posCounter == 32){
            if(toggle == 0){ toggle = 1;}
            else{ toggle = 0;} 
          }
          
          if(posCounter == 0){//then this is just the normal full cycle reset
            posCounter = 360;   
          }
      }
   }//end display method
}

void setDesignType(){
   if(designType == 0){// Honey
    statusWheel = new StatusWheel(34,20,60);
    statusWheel.doStroke = false;
    statusWheel.setColor1(255,225,0);
    statusWheel.setRandom(0);
    bgVal = 0;
  }
  else if(designType == 1){ //Cyan Plasma
    statusWheel = new StatusWheel(40,20,100);
    statusWheel.doStroke = false;
    statusWheel.setColor2(0,225,255);
    statusWheel.setRandom(.1);
    bgVal = 0;
  }
  else if(designType == 2){//Purple Spell
    statusWheel = new StatusWheel(40,20,100);
    statusWheel.doStroke = false;
    statusWheel.setColor1(225,0,255);
    statusWheel.setColor2(255,56,225);
    statusWheel.setRandom(.5);
    bgVal = 0;
  }
  else if(designType == 3){ //Green and Red Fish
   statusWheel = new StatusWheel(10,20,50);
   statusWheel.doStroke = true;
   statusWheel.setStrokeColor(255,255,255);
   statusWheel.setStrokeWeight(1);
   statusWheel.setColor1(0,150,100);
   statusWheel.setColor2(255,0,0);
   statusWheel.setRandom(0);
   bgVal = 250;
  } 
  else if(designType == 4){ //Orange and Cyan Book Worms
   statusWheel = new StatusWheel(40,30,100);
   statusWheel.setStrokeColor(0,0,0);
   statusWheel.setStrokeWeight(1);
   statusWheel.doStroke = true;
   statusWheel.setRandom(0);
   bgVal = 225;
  } 
  else if(designType == 5){ //Lemon and Lime Balls
   statusWheel = new StatusWheel(3,30,50);
   statusWheel.setStrokeColor(255,255,255);
   statusWheel.setColor1(0,255,155);
   statusWheel.setColor2(255,225,0);
   statusWheel.doStroke = true;
   statusWheel.setRandom(0);
   statusWheel.setStrokeWeight(2);
   bgVal = 155;
  }
  
  background(bgVal);
}

//from statusWheel_6
