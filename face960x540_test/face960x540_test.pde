import gab.opencv.*;
import processing.video.*;
import java.awt.*;
import codeanticode.syphon.*;

Capture cam;
OpenCV opencv;

PGraphics yourFace;
PImage thisFace;

PGraphics canvas;
SyphonServer server;

int CAMERA_CHOICE = 15; // name=Logitech Webcam C930e,size=960x540,fps=30

void setup() {
  size(960, 540,P2D);
  opencv = new OpenCV(this, 960, 540);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  getCameraListAndStartCamera();
  
  server = new SyphonServer(this, "Processing Syphon");
  yourFace = createGraphics(1200, 1200, P2D);
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
    cam = new Capture(this, 960, 540, cameras[CAMERA_CHOICE]);
    cam.start();     
  }
}

void draw() {
  opencv.loadImage(cam);
  image(cam, 0, 0, 960, 540);

  noFill();
  stroke(0, 255, 0);
  strokeWeight(2); 
  Rectangle[] faces = opencv.detect();
  println(faces.length);
  if (faces.length > 0) {
    Rectangle thisFaceRect = faces[0];
  
    println(thisFaceRect.x + "," + thisFaceRect.y);
    thisFace = copy();
    rect(thisFaceRect.x, thisFaceRect.y, thisFaceRect.width, thisFaceRect.height);
    
    yourFace.beginDraw();
    yourFace.copy(thisFace, thisFaceRect.x, thisFaceRect.y, thisFaceRect.width, thisFaceRect.height, 0, 0, 1200, 1200);
    yourFace.endDraw();
    
    image(yourFace, 0, 0, 200, 200);
    server.sendImage(yourFace);
  } 
}

void captureEvent(Capture c) {
  c.read();
}
