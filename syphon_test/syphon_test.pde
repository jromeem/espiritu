import codeanticode.syphon.*;

PGraphics canvas;
SyphonServer server;

void setup() {
  size(400,400,P2D);
  canvas = createGraphics(400, 400, P2D);
  
  // create syphon server to send frames out
  server = new SyphonServer(this, "Processing Syphon");
  
  //canvas.pixelDensity(2);
  canvas.beginDraw();
  canvas.noStroke();
  canvas.colorMode(HSB, height);
  canvas.background(0);
  canvas.endDraw();
}

void draw() {
  canvas.beginDraw();
  canvas.fill(mouseY, 200, height);
  canvas.rect(mouseX - mouseX%50, 0, 50, height);
  canvas.endDraw();
  
  image(canvas, 0, 0);
  server.sendImage(canvas);
}
