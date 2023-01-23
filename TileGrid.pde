float MIN_COLOR = 0;
float MAX_COLOR = 256;

float MAX_GRID_LENGTH = 330;
float MIN_GRID_LENGTH = -110;

float TOTAL_GRID_LENGTH = (MAX_GRID_LENGTH-MIN_GRID_LENGTH);

float MAX_GRID_WIDTH = 200;
float MIN_GRID_WIDTH = -200;

int NUM_STACK = 2;

class TileGrid {
  color[] primary;
  Tile tile;
  PImage[] img;
  float[][] zH;

  TileGrid(color[] primary, PImage[] img, float[][] zH) {
    this.primary = primary;
    this.img = img;
    this.zH = zH;
  }

  void draw() {
    drawGrid(this.primary);
  }

  void newColor(color[] newC) {
    this.primary = newC;
  }
  
  void drawGrid(color[] primary) {
    int count = 0;

    for (float i = MIN_GRID_WIDTH; i <= MAX_GRID_WIDTH; i+=20) {
      for (float j = MIN_GRID_LENGTH; j <= MAX_GRID_LENGTH; j+=20) {
        pushMatrix();
        translate(i/100, j/100, -2);
        scale(0.1, 0.1, 1);
        drawSingleTile(primary[count], img[count], zH[count]);
        count++;
        popMatrix();
      }
    }
  }
  
  void drawSingleTile(color primary, PImage img, float[] zH) {
    if (doTextures) {
      drawTextureSquare3D(img, zH[NUM_STACK]);
      for (int i = NUM_STACK; i>=0; i--)
        if (zH[i]==0.5) {
          drawTextureSideSquare3D(side, zH[i]);
          break;
        } else {
          drawTextureSideSquare3D(side, zH[i]);
        }
    } else {
      tile = new Tile(primary);
      tile.draw();
    }
  }
}
