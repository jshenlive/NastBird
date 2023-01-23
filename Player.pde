final float Y_BANK = PI/6;
final float X_BANK = PI/6;
final float PLAYER_SCALE = 1.2;
final float MOVE_SPEED = 0.2;
final float RETURN_SPEED = 0.05;
final int Y_OFFSET = -8;

boolean moveLeft = false;
boolean moveRight = false;
boolean moveUp = false;
boolean moveDown = false;
boolean faceRight = true;

boolean bankLeft = false;
boolean bankRight = false;
boolean bankUp = false;
boolean bankDown = false;

boolean isPlayerDead;

float topXBound;
float botXBound;
float topYBound;
float botYBound;
float orthoOffset;

float perspectiveBoundSlope=1;

int currentParticle = 0;

class Player {
  boolean isPlayer;
  float rPlayer = 1;
  float playerXPos = 0;
  float playerYPos = Y_OFFSET;
  boolean[] showPlayerParticles = new boolean[maxPlayerParticles];
  Particle[] playerParticles;

  Player() {
    isPlayerDead = false;
    isPlayer = true;
    
    initiatePlayerParticles();
  }

  void initiatePlayerParticles() {
    float initX = 0;
    float initY = 0;
    int notEnemy = -1;

    playerParticles = new Particle[maxPlayerParticles];
    for (int i = 0; i< maxPlayerParticles; i++) {
      playerParticles[i] = new Particle(i, initX, initY, showPlayerParticles, notEnemy, isPlayer);
    }
  }

  void draw() {
    pushMatrix();
    translate(0, 0, OBJECTS_Z);
    scale(GLOBAL_SCALE);
    if (orthoMode) {
      updateOrthoBounds();
      orthoOffset = playerYPos;
    } else {
      updatePerspectiveBounds();
      perspectiveBoundSlope = (topYBound-botYBound)/(topXBound-botXBound);
    }

    checkNewLife();

    drawPlayerParticles();
    movePlayer();
    translatePlayer();
    drawPlayer();
    noTint();
    popMatrix();

    if (doCollision) {
      checkEnemyCollision();
    }
  }

  void drawPlayer() {
    pushMatrix();
    scale(PLAYER_SCALE, PLAYER_SCALE);
    if (!isPlayerDead) {
      if (doTextures) {
        if(faceRight){
        drawSingleTextureSquare(playerImg);
      }else{
        drawSingleTextureSquareFlip(playerImg);
      }
        
      } else {
        fill(red);
        drawSingleSquare();
      }
    }
    popMatrix();
  }

  void drawPlayerParticles() {
    for (int i = 0; i < maxPlayerParticles; i++) {
      if (showPlayerParticles[i]) {
        playerParticles[i].draw();
      }
    }
  }

  void checkNewLife() {
    if (newLife) {
      doCollision = false;
      tint(1, 0.5);
    } else {
      doCollision = true;
    }
  }

  void checkEnemyCollision() {
    PVector currEnemyPos;
    float enemyScale;
    Enemy currEnemy;
    float rEnemy;

    for (int i = 0; i < maxEnemies; i++) {
      currEnemy = newEnemies.get(i);
      currEnemyPos = currEnemy.getEnemyPosition();
      enemyScale = currEnemy.scale;
      rEnemy = enemyScale*1.3;
      if (!isPlayerDead && checkCollision(currEnemyPos.x, playerXPos, currEnemyPos.y, playerYPos, rEnemy, rPlayer)) {
        enemiesProperties.get(i)[SHOW] = false;
        isPlayerDead = true;
        hits(false, currEnemyPos.x, currEnemyPos.y);
        hits(true, playerXPos, playerYPos);
        life--;
      }
    }
  }

  void updatePlayerParticle(int i) {
    playerParticles[i].updateParticle(i, playerXPos, playerYPos);
  }

  PVector getPlayerPosition() {
    return new PVector(playerXPos, playerYPos);
  }

  void movePlayer() {
    if (moveLeft) {
      faceRight = false;
      movePlayerLeft();
    }
    if (moveRight) {
      faceRight = true;
      movePlayerRight();
    }
    if (moveUp) {
      movePlayerUp();
    }
    if (moveDown) {
      movePlayerDown();
    }
    if (!moveLeft && !moveRight && !moveUp && !moveDown) {
      returnPlayer();
    }
    translate(playerXPos, playerYPos);
  }

  void movePlayerLeft() {
    playerXPos = constrain(playerXPos-MOVE_SPEED, -(botXBound+(playerYPos-orthoOffset)/perspectiveBoundSlope), (botXBound+(playerYPos-orthoOffset)/perspectiveBoundSlope));
  };

  void movePlayerRight() {
    playerXPos = constrain(playerXPos+MOVE_SPEED, -(botXBound+(playerYPos-orthoOffset)/perspectiveBoundSlope), (botXBound+(playerYPos-orthoOffset)/perspectiveBoundSlope));
  };

  void movePlayerUp() {
    playerYPos = constrain(playerYPos+MOVE_SPEED, botYBound, topYBound);
  };

  void movePlayerDown() {
    playerYPos = constrain(playerYPos-MOVE_SPEED, botYBound, topYBound);
  };

  void returnPlayer() {
    if (playerXPos > 0) {
      faceRight = false;
      playerXPos -= RETURN_SPEED;
    }
    if (playerXPos < 0) {
      faceRight = true;
      playerXPos += RETURN_SPEED;
    }
    if (playerYPos > Y_OFFSET) {
      playerYPos -= RETURN_SPEED;
    }
    if (playerYPos < Y_OFFSET) {
      playerYPos += RETURN_SPEED;
    }
  }

  void translatePlayer() {
    if (bankLeft) {
      rotateY(-Y_BANK);
    }
    if (bankRight) {
      rotateY(Y_BANK);
    }
    if (bankUp) {
      rotateX(-X_BANK);
    }
    if (bankDown) {
      rotateX(X_BANK);
    }
  }
}
