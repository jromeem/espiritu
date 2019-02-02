import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture cam;
OpenCV opencv;

void setup() {
  size(870, 520);
  opencv = new OpenCV(this, 870, 520);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  

  getCameraListAndStartCamera();
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
    println(cameras[0]);
    cam = new Capture(this, 960, 540, cameras[0]);
    cam.start();     
  }
}

void draw() {
  scale(2);
  opencv.loadImage(cam);

  image(cam, 0, 0, cam.width/2, cam.height/2);

  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  Rectangle[] faces = opencv.detect();
  println(faces.length);

  for (int i = 0; i < faces.length; i++) {
    println(faces[i].x + "," + faces[i].y);
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
}

void captureEvent(Capture c) {
  c.read();
}
