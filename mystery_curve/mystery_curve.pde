


import peasy.*;
import controlP5.*;
import processing.dxf.*;

// http://paulbourke.net/geometry/knots/

PMatrix3D currCameraMatrix;
PGraphics3D g3;
ControlP5 MyController;

PeasyCam cam;
PVector[][] globe;

boolean saveDXF = false;
int total = 1000;
float p, q;

void setup(){
    size(1000,1000, P3D);
    cam = new PeasyCam(this, 500);
    globe = new PVector[total+1][1];
    colorMode(HSB);
    g3 = (PGraphics3D)g;
    MyController = new ControlP5(this);
    setupControllers();
    MyController.setAutoDraw(false);  
}

void gui() {
  currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  MyController.draw();
  g3.camera = currCameraMatrix;
}

void draw(){
  background(0);

   lights();
   float radius = 120;
   
   if(saveDXF == true){
    beginRaw(DXF, "data/" + Float.toString(frameRate) + ".dxf");
   }
   
   stroke(255);
   for(int i = 0; i <= total; i++){

      float t = map(i, 0, total, 0, TWO_PI);

      float x = cos(t) + (cos(p*t)/2.0) + (sin(q*t)/3.0);
      float y = sin(t) + (sin(p*t)/2.0) + (cos(q*t)/3.0);
      float z = -sin(t);
      
      globe[i][0] = new PVector(x,y,z);
   }
   
   strokeWeight(5);
   strokeCap(ROUND);
   for(int i = 0; i <= total; i++){

      float hu = map(i, 0, total, 0, 255);
      stroke(hu%255, 255, 255);

      PVector v = globe[i][0];
      PVector v_next;
      
      if (i == total){
        v_next = globe[0][0];
      }
      else {
        v_next = globe[i+1][0];
      }

      line(radius*v.x,radius*v.y, radius*v.z,
           radius*v_next.x, radius*v_next.y, radius*v_next.z);
  }

  if(saveDXF == true){
    endRaw();
    saveDXF = false;
  } 
  gui();
}

void keyPressed(){
  if(key == 's'){
    saveDXF = true;
  }
}


void setupControllers(){
  
    MyController.addNumberbox("p").setPosition(50,10)
     .setSize(30,30)
     .setScrollSensitivity(1.1)
     .setValue(6);
     
    MyController.addNumberbox("q").setPosition(100,10)
     .setSize(30,30)
     .setScrollSensitivity(1.1)
     .setValue(14);
}