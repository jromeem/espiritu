import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import codeanticode.syphon.*;

Capture cam;
OpenCV opencv;

PGraphics yourFace;
PImage thisFace;
SyphonServer server;

int CAMERA_CHOICE = 3; // name=Logitech Webcam C930e,size=960x540,fps=30

void setup() {
  size(960, 540, P2D);
  opencv = new OpenCV(this, 400, 300);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  getCameraListAndStartCamera();
  
  yourFace = createGraphics(400, 400, P2D);
  server = new SyphonServer(this, "Processing Syphon");
}

void getCameraListAndStartCamera() {
  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    print("Using this camera: ");
    println(cameras[CAMERA_CHOICE]);
    cam = new Capture(this, 400, 300, cameras[CAMERA_CHOICE]);
    cam.start();     
  }
}

void draw() {
  opencv.loadImage(cam);
  //image(cam, 0, 0, 960, 540);
  //image(cam, 0, 0, 400, 300);
  //scale(960/400.0, 540/300.0);

  noFill();
  stroke(0, 255, 0);
  strokeWeight(2); 
  Rectangle[] faces = opencv.detect();
  println(faces.length);
  
  if (faces.length > 0) {
    Rectangle thisFaceRect = faces[0];
    //
    image(cam, 0, 0, 960, 540);
    
    thisFace = copy();
    image(thisFace, 0, 0);
    yourFace.beginDraw();
    yourFace.scale(960/400.0, 540/400.0);
    yourFace.copy(cam, thisFaceRect.x, thisFaceRect.y, thisFaceRect.width, thisFaceRect.height, 0, 0, 400, 400);
    yourFace.endDraw();
    
    stroke(255, 0, 0);
    image(yourFace, 0, 0, 400, 400);
    
    scale(960/400.0, 540/300.0);
    rect(thisFaceRect.x, thisFaceRect.y, thisFaceRect.width, thisFaceRect.height);

    server.sendImage(yourFace);
  }
}

void captureEvent(Capture c) {
  c.read();
}
