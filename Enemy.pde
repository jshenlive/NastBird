
final int SHOW = 0;
final int CONSTANT_SPEED = 1;

final int NUM_KEYFRAMES = 3; // 3 points a,b,c ==> while a->b, randomize c, then b->c randomize a, c->b randomize b, repeat
final int NUM_DATA = 4; //X,Y,SCALE,ANGLE

final int X = 0;
final int Y = 1;
final int SCALE = 1;
final int ANGLE = 3;


final int NUM_STEPS = 150; //adjusts enemy moving speed



float maxEnemyScale;
float minEnemyScale; //changes base on difficulty

class Enemy {
  int enemyIndex;
  int numSteps;
  int counter;
  int startFrame = 0;
  int endFrame = 1;
  int freeFrame = 2;
  int birdFrameIndex;
  
  PVector[] vertices = new PVector[NUM_KEYFRAMES];
  float t;
  float enemyXPos, enemyYPos;
  float maxTopXPos, maxTopYPos;
  float scale;
  boolean doPooping = false;
  boolean doFlip = false;

  Particle[] enemyParticles;
  int[] particleStepCounter;
  float[][] keyFrames = new float[NUM_KEYFRAMES][NUM_DATA];
  boolean[] showEnemyParticles = new boolean[maxEnemyParticles];

  Enemy(int enemyIndex) {
    this.enemyIndex = enemyIndex;
    initiateEnemy();
    initiateParticles();
  }

  void initiateEnemy() {
    scale = random(minEnemyScale, maxEnemyScale);
    vertices[0] = randomVector(-topXBound, topXBound, -1, topYBound);
    vertices[1] = randomVector(-topXBound, topXBound, -1, topYBound);
    vertices[2] = randomVector(-topXBound, topXBound, -1, topYBound);

    if (random(2) > 1 ) {
      enemiesProperties.get(enemyIndex)[CONSTANT_SPEED] = true;
    }

    numSteps=numStepsForConstantSpeed(vertices[startFrame], vertices[endFrame], stepUp);
  }

  void initiateParticles() {
    enemyParticles = new Particle[maxEnemyParticles];
    particleStepCounter = new int[maxEnemyParticles];
    for (int i = 0; i< maxEnemyParticles; i++) {
      enemyParticles[i] = new Particle(i, 0, 0, showEnemyParticles, enemyIndex, false);
    }
  }

  PVector randomVector(float minX, float maxX, float minY, float maxY) {
    return new PVector(random(minX, maxX), random(minY, maxY));
  };

  void draw() {
    pushMatrix();
    scale(GLOBAL_SCALE, GLOBAL_SCALE, 1);

    if (enemiesProperties.get(enemyIndex)[SHOW]) {
      pushMatrix();
      updateCounter();
      t = parameterFromCounter(counter);

      enemyXPos = lerp(vertices[startFrame].x, vertices[endFrame].x, t);
      enemyYPos = lerp(vertices[startFrame].y, vertices[endFrame].y, t);

      if (vertices[endFrame].x < vertices[startFrame].x) {
        doFlip = true;
      } else {
        doFlip = false;
      }

      if (checkCollision(vertices[endFrame].x, enemyXPos, vertices[endFrame].y, enemyYPos, 1, 1)) {
        doPooping= true;
      } else {
        doPooping = false;
      }

      drawMovingEnemy();
      updateBirdAnimation();
      popMatrix();
    }

    pushMatrix();
    translate(0, 0, OBJECTS_Z);
    for (int i = 0; i<maxEnemyParticles; i++) {
      if (showEnemyParticles[i])
        enemyParticles[i].draw();
    }
    popMatrix();

    popMatrix();
  }


  void drawMovingEnemy() {
    pushMatrix();
    translate(enemyXPos, enemyYPos, OBJECTS_Z);
    drawSingleEnemy();
    popMatrix();
  }

  void drawSingleEnemy() {
    if (doTextures) {
      PImage img;
      scale(scale);

      if (doPooping) {
        scale(GLOBAL_SCALE+1, GLOBAL_SCALE+1);
        img = birdPoopMove[birdFrameIndex];
      } else {
        img = birdMove[birdFrameIndex];
      }

      //flip x-axis for left-right travel directions
      if (doFlip) {
        drawSingleTextureSquareFlip(img);
      } else {
        drawSingleTextureSquare(img);
      }
    } else {
      fill(red);
      drawSingleSquare();
    }
  }

  void drawParticles() {
    for (int i = 0; i < maxEnemyParticles; i++) {
      if (showEnemyParticles[i]) {
        enemyParticles[i].draw();
      }
    }
  }

  //counter for moving enemy
  void updateCounter() {
    counter++;
    if (nextKeyframe(counter)) {
      freeFrame = startFrame;
      startFrame = (startFrame+1) % NUM_KEYFRAMES; // num_keyframes = 3
      endFrame = (endFrame+1) % NUM_KEYFRAMES;
      vertices[freeFrame] = randomVector(-10, 10, -3, 9);
      counter = 0;
      numSteps=numStepsForConstantSpeed(vertices[startFrame], vertices[endFrame], stepUp);
      enemyFire();
    }
  }

  boolean nextKeyframe(int c) {
    boolean goToNext;
    if (enemiesProperties.get(enemyIndex)[CONSTANT_SPEED]) {
      goToNext = c >= numSteps;
    } else {
      goToNext = c >= NUM_STEPS;
    }
    return goToNext;
  }


  float parameterFromCounter(int c) {
    float t;
    if (enemiesProperties.get(enemyIndex)[CONSTANT_SPEED]) {
      t = (float)c/numSteps;
    } else {
      t = (float)c/NUM_STEPS;
    }
    return t;
  }

  void enemyFire() {
    for (int i = 0; i<maxEnemyParticles; i++) {
      if (!showEnemyParticles[i]) {
        updateEnemyParticle(i);
        break;
      }
    }
  }

  void updateEnemyParticle(int i) {
    enemyParticles[i].updateParticle(i, enemyXPos, enemyYPos);
  }

  PVector getEnemyPosition() {
    return new PVector(enemyXPos, enemyYPos);
  }

  void updateBirdAnimation() {
    birdFrame.set(enemyIndex, (birdFrame.get(enemyIndex) + ANIMATION_PER_FRAME) % NUM_BIRD_FRAMES);
    float frame = birdFrame.get(enemyIndex);
    birdFrameIndex = (int)frame;
  }
}
