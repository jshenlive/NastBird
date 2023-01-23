class Tile {
  color primary;
  float zDistance = 0.7;

  Tile(color primary) {
    this.primary = primary;
  }

  void draw() {
    pushMatrix();
    drawTile();
    popMatrix();
  }

  void drawTile() {
    strokeWeight(1);
    pushMatrix();
    stroke(this.primary);
    fill(this.primary);
    drawSingleSquare3D(zDistance);
    popMatrix();
  }
}
