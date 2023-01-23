void drawSingleSquare() {
  beginShape(TRIANGLES);
  vertex(-1, -1);
  vertex(-1, 1);
  vertex(1, 1);
  vertex(1, 1);
  vertex(-1, -1);
  vertex(1, -1);
  endShape();
}

void drawSingleTextureSquare(PImage img) {
  beginShape(TRIANGLES);
  texture(img);
  vertex(-1, -1, 0, 1);
  vertex(1, -1, 1, 1);
  vertex(-1, 1, 0, 0);
  vertex(-1, 1, 0, 0);
  vertex(1, -1, 1, 1);
  vertex(1, 1, 1, 0);
  endShape();
}

void drawSingleTextureSquareFlip(PImage img) {
  beginShape(TRIANGLES);
  texture(img);
  vertex(-1, -1, 1, 1);
  vertex(1, -1, 0, 1);
  vertex(-1, 1, 1, 0);

  vertex(-1, 1, 1, 0);
  vertex(1, -1, 0, 1);
  vertex(1, 1, 0, 0);
  endShape();
}

void drawSingleSquare3D(float zDistance) {
  beginShape(TRIANGLES);
  vertex(-1, -1, zDistance);
  vertex(-1, 1, zDistance);
  vertex(1, 1, zDistance);
  vertex(1, 1, zDistance);
  vertex(-1, -1, zDistance);
  vertex(1, -1, zDistance);
  endShape();
}

void drawTextureSquare3D(PImage img, float zH) {
  noStroke();
  beginShape(TRIANGLES);
  texture(img);
  vertex(-1, -1, zH, 0, 1);
  vertex(1, -1, zH, 1, 1);
  vertex(-1, 1, zH, 0, 0);
  vertex(-1, 1, zH, 0, 0);
  vertex(1, -1, zH, 1, 1);
  vertex(1, 1, zH, 1, 0);
  endShape();
}

void drawTextureSideSquare3D(PImage img, float zH) {

  //front
  noStroke();
  beginShape(TRIANGLES);
  texture(img);
  vertex(-1, -1, zH, 0, 0);
  vertex(1, -1, zH, 1, 0);
  vertex(-1, -1, zH-0.1, 0, 1);

  vertex(-1, -1, zH-0.1, 0, 1);
  vertex(1, -1, zH, 1, 0);
  vertex(1, -1, zH-0.1, 1, 1);
  endShape();

  //left
  noStroke();
  beginShape(TRIANGLES);
  texture(img);
  vertex(-1, 1, zH, 0, 0);
  vertex(-1, -1, zH, 1, 0);
  vertex(-1, 1, zH-0.1, 0, 1);

  vertex(-1, 1, zH-0.1, 0, 1);
  vertex(-1, -1, zH, 1, 0);
  vertex(-1, -1, zH-0.1, 1, 1);
  endShape();

  //right
  noStroke();
  beginShape(TRIANGLES);
  texture(img);
  vertex(1, -1, zH, 0, 0);
  vertex(1, 1, zH, 1, 0);
  vertex(1, -1, zH-0.1, 0, 1);

  vertex(1, -1, zH-0.1, 0, 1);
  vertex(1, 1, zH, 1, 0);
  vertex(1, 1, zH-0.1, 1, 1);
  endShape();
}
