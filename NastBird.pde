
final int TEXT_SIZE = 32;

final int FRAME_RATE = 60;
final int NUM_BIRD_FRAMES = 4;
final float ANIMATION_FR = 10;
final float ANIMATION_PER_FRAME = ANIMATION_FR/FRAME_RATE;

final float GLOBAL_SCALE = 0.1;
final float OBJECTS_Z = -0.9;

final int NUM_ENEMY_PROPERTIES = 2;

World newWorld;
Player newPlayer;
ArrayList<Enemy> newEnemies;
ArrayList<Float> birdFrame;
ArrayList<Flock> flock;
ArrayList<boolean[]> enemiesProperties;
PImage playerImg;
PImage poopImg;
PImage ballImg;
PImage featherImg;
PImage snowImg;
PImage tile1;
PImage tile2;
PImage over;
PImage side;
PImage start;
PImage player1Img;
PImage ball1Img;
PImage player2Img;
PImage ball2Img;
PImage player3Img;
PImage ball3Img;

PImage[] birdMove = new PImage[NUM_BIRD_FRAMES];
PImage[] birdPoopMove = new PImage[NUM_BIRD_FRAMES];

int count = 0;
int timer = 0;
int score;
int life;
int bonus;
boolean levelUp;
boolean newLife;
boolean startGame;
boolean gameOver;

int maxPlayerParticles; //change on difficulty
int maxEnemies; //change on difficulty
int maxEnemyParticles; //change on difficulty

color black;
color white;
color yellow;
color red;

//Records best score to file
PrintWriter scoreRecord;
int bestScore;
boolean newBest;

void setup() {
  size(700, 700, P3D); // change the dimensions if desired
  colorMode(RGB, 1.0f);
  black = color(0);
  white = color(1);
  yellow = color(240/255f, 225/255f, 110/255f);
  red = color(245/255f, 60/255f, 15/255f);
  textureMode(NORMAL); // use normalized 0..1 texture coords
  textureWrap(REPEAT);
  setupPOGL();
  setupProjections();
  resetMatrix(); // do this here and not in draw() so that you don't reset the camera


  loadImages();  //Load texture and animation files
  checkRecord(); //check best score
  resetGame();  //initiate game settings
}

void resetGame() {

  stepUp = 25;
  maxEnemyScale = 1.5;
  minEnemyScale = 1.25;
  //inital settings
  score = 0;
  maxPlayerParticles = 5; //change on difficulty
  maxEnemies = 1; //change on difficulty
  maxEnemyParticles = 3; //change on difficulty
  life = 1;
  bonus = 50;
  newBest = false;

  checkRecord();  //check bestscore
  updateOrthoBounds();  //setting initial bounds
  initiateObjects();  //initate objects
}

void checkRecord() {
  String[] line = loadStrings("img/record.txt");
  if (line == null) {
    scoreRecord = createWriter("img/record.txt");
    scoreRecord.print(0);
    scoreRecord.close();
  } else {
    bestScore = Integer.parseInt(line[0]);
  }
}

void initiateObjects() {
  newWorld = new World();
  newPlayer = new Player();
  birdFrame = new ArrayList<>();
  newEnemies = new ArrayList<Enemy>();
  enemiesProperties = new ArrayList<>();
  flock = new ArrayList<>();

  initiateEnemies();
}

void initiateEnemies() {
  for (int i = 0; i< maxEnemies; i++) {
    enemiesProperties.add(new boolean[NUM_ENEMY_PROPERTIES]);
    newEnemies.add(new Enemy(i));
    birdFrame.add(0.0);
  }
  enemiesProperties.get(0)[SHOW] = true;
}

void loadImages() {
  side = loadImage("img/column.jpg");
  over = loadImage("img/gameOver.png");
  poopImg = loadImage("img/poop.png");
  featherImg = loadImage("img/feather.png");
  snowImg = loadImage("img/snow1.png");
  tile1 = loadImage("img/snow0.png");
  tile2 = loadImage("img/snow1.png");
  start = loadImage("img/start.png");
  player1Img = loadImage("img/player1.png");
  ball1Img = loadImage("img/ball1.png");
  player2Img = loadImage("img/player2.png");
  ball2Img = loadImage("img/ball2.png");
  player3Img = loadImage("img/player3.png");
  ball3Img = loadImage("img/ball3.png");

  setupBird();
}

void setupBird() {
  for (int i = 0; i<NUM_BIRD_FRAMES; i++) {
    birdMove[i] = loadImage("img/bird" + i + ".png");
    birdPoopMove[i] = loadImage("img/birdPoop" + i + ".png");
  }
}

void draw() {
  clear();
  background(black);
  setCamera();

  movingWorld();
  if (!startGame) {
    startGame();
  }
  if (startGame) {
    showStatus();
    if (!gameOver) {
      movingPlayer();
      movingEnemy();
      showFlock();
      checkTimer();
    } else {
      endGame();
    }
  }
}

void setCamera() {
  if (orthoMode) {
    resetMatrix();
    setProjection(projectOrtho);
  } else {
    resetMatrix();
    setProjection(projectPerspective);
    camera(0, -1, 0.5,
      0, -0.7, 0,
      0, 0, 1);
  }
}

void showStatus() {
  pushMatrix();
  textSize(TEXT_SIZE);
  translate(0, 0, OBJECTS_Z);
  scale(0.003, -0.003, 1);
  fill(black);
  text("Score: " + score +"   Life: " + life, -105, -300);

  if (gameOver) {
    if (newBest) {
      fill(random(1), random(1), random(1));
      text("NEW BEST SCORE!!", -125, -250);
    } else {
      text("CURRENT BEST SCORE: " + bestScore, -165, -250);
    }
  }
  popMatrix();
}

void movingWorld() {
  pushMatrix();
  count ++;
  if (count > (TOTAL_GRID_LENGTH+20)*2) {
    newWorld.newGrid();
    //changed = true;
    count = 0;
  }
  translate(0, -(float)count/200);
  newWorld.draw();
  popMatrix();
}

void movingPlayer() {
  pushMatrix();
  newPlayer.draw();
  popMatrix();
}

void movingEnemy() {
  pushMatrix();
  for (int i = 0; i<maxEnemies; i++) {
    newEnemies.get(i).draw();
  }
  popMatrix();
}

void showFlock() {
  pushMatrix();
  translate(0, 0, OBJECTS_Z);
  checkFlock();
  popMatrix();
}

void checkFlock() {
  for (int i =0; i< flock.size(); i++) {
    Flock curr = flock.get(i);
    curr.run();
    curr.delete();
    if (curr.numNodes<1) {
      if (curr.isPlayer) {
        if (life == 0) {
          gameOver=true;
        } else {
          newPlayer = new Player();
          isPlayerDead = false;
          newLife = true;
        }
      }
      flock.remove(curr);
    }
  }
}

void checkTimer() {
  if (timer == 750) {
    enemyLevelUp();
    timer = 0;
  }
  timer++;
}

void startGame() {
  pushMatrix();
  translate(0, 0, OBJECTS_Z);
  scale(1, 1, 0.1);
  noStroke();
  drawTextureSquare3D(start, OBJECTS_Z);
  popMatrix();
}


void endGame() {
  pushMatrix();
  translate(0, 0, OBJECTS_Z);
  scale(1, 1, -0.1);
  noStroke();
  drawTextureSquare3D(over, OBJECTS_Z);
  popMatrix();

  if (score > bestScore) {
    scoreRecord = createWriter("img/record.txt");
    scoreRecord.print(score);
    scoreRecord.close();
    newBest=true;
    bestScore = score;
  }
}
