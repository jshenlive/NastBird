//particles


final float PARTICLE_SPEED = 0.2;

float scoreLevel = 20;
//boolean shoot = false;

class Particle {

  float scale = 0.45;
  float particleXPos, particleYPos;
  int posIndex;
  boolean[] showParticles;  //do we need this?
  float originX, originY;
  boolean isPlayer;
  float t;
  int numStep=0;
  PVector playerPos;
  float slope =1;
  float initX;
  float initY;
  int count=20;
  float endX;
  float endY;
  float bound = -11;
  int enemyIndex;
  float rEnemy = 1.5;
  float rPlayer = 0.9;
  float rParticle = 0.75;
  float rPoop = 1;

  Particle(int posIndex, float x, float y, boolean[] showParticles, int enemyIndex, boolean isPlayer) {
    this.posIndex = posIndex;
    particleXPos = x;
    particleYPos = y;
    this.showParticles = showParticles;
    this.isPlayer = isPlayer;
    playerPos = new PVector();
    this.enemyIndex = enemyIndex;
  }

  void draw() {

    pushMatrix();

    if (doCollision) {
      if (isPlayer) {
        checkPlayerShot();
      } else {
        checkEnemyShot();
      }
    }

    movingParticle();

    popMatrix();
  }
  void checkPlayerShot() {

    for (int i = 0; i< maxEnemies; i++) {
      Enemy currEnemy = newEnemies.get(i);
      if (enemiesProperties.get(i)[SHOW]) {
        rEnemy = currEnemy.scale*1.55;
        if (checkCollision(currEnemy.enemyXPos, particleXPos, currEnemy.enemyYPos, particleYPos, rEnemy, rParticle)) {
          enemiesProperties.get(i)[SHOW] = false;
          if (!doGodShot) {

            showParticles[posIndex]= false;
          }

          hits(false, currEnemy.enemyXPos, currEnemy.enemyYPos);

          checkEnemyReset(i);
          updateScore();
          break;
        }
      }
    }
  }

  void checkEnemyShot() {
    PVector playerPos = newPlayer.getPlayerPosition();
    float playerX = playerPos.x;
    float playerY = playerPos.y;
    if (!isPlayerDead && checkCollision(particleXPos, playerX, particleYPos, playerY, rPoop, rPlayer)) {
      showParticles[posIndex]=false;
      isPlayerDead = true;
      hits(true, playerX, playerY);
      life--;
    }
  }

  void updateScore() {
    score++;
    scoreLevel = scoreLevel * 2;
    if (score % (scoreLevel) == 0) {
      enemyLevelUp();
    }

    if (score % bonus == 0) {
      playerLevelUp();
      bonus *= 2;
    }
  }

  void movingParticle() {
    if (isPlayer) {
      particleYPos += PARTICLE_SPEED;
      translate(particleXPos, particleYPos+1.2);
      scale(scale);

      drawSingleParticle();
      if (particleYPos > topYBound) {
        showParticles[posIndex] = false;
      }
    } else {
      count++;
      if (numStep == 0) {
        playerPos = newPlayer.getPlayerPosition();
        PVector enemyPos = new PVector(particleXPos, particleYPos);
        slope = (playerPos.y - particleYPos)/(playerPos.x-particleXPos);
        numStep = numStepsForConstantSpeed(enemyPos, playerPos, 1000);

        initX = particleXPos;
        initY = particleYPos;
        if (slope == 0) {
          slope =1;
        }

        if (playerPos.y > particleYPos) {
          endY = topYBound*2;
        } else {
          endY = -topYBound*2;
        }

        if (Math.abs(playerPos.y -initY) < Math.abs(playerPos.x-initX)) {
          if (playerPos.x > particleXPos) {
            endX = topXBound*2;
          } else {
            endX = -topXBound*2;
          }
        } else {
          endX =max(min((endY-initY)/slope + initX, topXBound*2), -topXBound*2);
        }
        if (endX <= -topXBound*2 || endX >= topXBound+2) {
          endY = (endX-initX)*slope + initY ;
        }
      }

      t= (float)count/numStep;
      particleXPos = lerp(particleXPos, endX, t);
      particleYPos = lerp(particleYPos, endY, t);
      translate(particleXPos, particleYPos);
      scale(scale);
      drawSingleParticle();
      if (particleYPos < -11 || particleYPos > 11 || particleXPos > 11 || particleXPos < -11) {
        numStep = 0;
        count = 20;
        showParticles[posIndex]=false;
        if (!isPlayer) {
          checkEnemyReset(enemyIndex);
        }
      }
    }
  }

  void checkEnemyReset(int index) {
    if (!enemiesProperties.get(index)[SHOW]) {
      Enemy currEnemy = newEnemies.get(index);
      boolean reset = true;
      for (int i = 0; i< maxEnemyParticles; i++) {
        if (currEnemy.showEnemyParticles[i]) {
          reset = false;
          break;
        }
      }
      if (reset) {
        newEnemies.set(index, new Enemy(index));
        enemiesProperties.get(index)[SHOW] = true;
      }
    }
  }

  void drawSingleParticle() {
    pushMatrix();
    if (doTextures) {
      if (!isPlayer) {
        scale(0.9, 1.5, GLOBAL_SCALE);
        drawSingleTextureSquare(poopImg);
      } else {
        drawSingleTextureSquare(ballImg);
      }
    } else {
      fill(black);
      circle(0, 0, 1);
    }
    popMatrix();
  }

  void updateParticle(int i, float originX, float originY) {
    showParticles[i] = true;
    setParticlePos(originX, originY);
  }

  void setParticlePos(float x, float y) {
    particleXPos = x;
    particleYPos = y;
  }
}
