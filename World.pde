final float INIT_TILE_HEIGHT = 0.5;
final float GRID_OFFSET = (TOTAL_GRID_LENGTH/20+1)/5;
final int NUM_TILES = int((TOTAL_GRID_LENGTH/20+1) * ((MAX_GRID_WIDTH-MIN_GRID_WIDTH)/20+1));


class World{
  TileGrid currentGrid, nextGrid;

  World(){
   currentGrid = new TileGrid(randomColor(),randomImg(),randomZH());
   nextGrid = new TileGrid(randomColor(),randomImg(),randomZH());
  }

  void draw(){   
    pushMatrix();
    drawTileGrid(currentGrid);
    translate(0,GRID_OFFSET);  
    drawTileGrid(nextGrid);
    popMatrix();
  }
 
  void drawTileGrid(TileGrid grid){  
    grid.draw();
  }
  
  void newGrid(){
    currentGrid = nextGrid;
    nextGrid = new TileGrid(randomColor(),randomImg(),randomZH());
  }
}
  color[] randomColor(){
    color[] arr = new color[NUM_TILES];
    for (int i = 0; i < (NUM_TILES); i++){
      arr[i] = color(random(255)/255,random(255)/255,random(255)/255);
    }
    return arr;
  }
  
  PImage[] randomImg(){
    PImage[] arr = new PImage[NUM_TILES];
    for(int i = 0; i<NUM_TILES; i++){
      if(random(4)>1){
      arr[i] = tile1;
      }else{
      arr[i] = tile2;
      }
    }
    return arr;
  }
  float[][] randomZH(){
    float[][] arr = new float[NUM_TILES][3];
    for(int i = 0; i<NUM_TILES; i++){
      float rand = random(3);
      if(rand>2){
      arr[i][0] = INIT_TILE_HEIGHT;
      arr[i][1] = INIT_TILE_HEIGHT+0.1;
      arr[i][2] = INIT_TILE_HEIGHT+0.2;
      }else if (rand > 1){
      arr[i][1] = INIT_TILE_HEIGHT;
      arr[i][2] = INIT_TILE_HEIGHT+0.1;
      }else{
      arr[i][2]= INIT_TILE_HEIGHT;
      }
    }
    return arr;
  }
