import processing.net.*;

Server myServer;
int[][] grid;
boolean actionable;
int timer;
void setup(){
  size(300,400);
  grid = new int[3][3];
  strokeWeight(3);
  textAlign(CENTER,CENTER);
  textSize(50);
  myServer = new Server(this,1234);
  actionable = false;
  timer = 0;
}

void draw(){
  background(255);
  
  stroke(0);
  line(0,100,300,100);
  line(0,200,300,200);
  line(100,0,100,300);
  line(200,0,200,300);
  
  for(int i = 0;i<3;i++){
    for(int j = 0;j<3;j++){
      drawXO(i,j);
    }
  }
  
  fill(0);
  text(mouseX + "," + mouseY, 150,350);
  
  Client myClient = myServer.available();
  if(myClient != null){
    String incoming = myClient.readString();
    int r = int(incoming.substring(0,1));
    int c = int(incoming.substring(2,3));
    grid[r][c] = 1;
    actionable = true;
  }
  if(winningCondition(grid) || tieCondition(grid)){
    reset();
  }
  
}

void drawXO(int row, int col){
  pushMatrix();
  translate(row * 100,col * 100);
  if(grid[row][col] == 1){
    fill(255);
    ellipse(50,50,90,90);
  }else if(grid[row][col] == 2){
    line(10,10,90,90);
    line(90,10,10,90);
  }
  popMatrix();
}

boolean winningCondition(int[][] board){
  for(int i = 0;i<board.length;i++){
    if(board[i][0] == board[i][1] && board[i][0] == board[i][2] && board[i][0] != 0){
      return true;
    }else if(board[0][i] == board[1][i] && board[0][i] == board[2][i] && board[i][0] != 0){
      return true;
    }
  }
  
    if(board[0][0] == board[1][1] && board[0][0] == board[2][2] && board[1][1] != 0){
      return true;
    }else if(board[2][0] == board[1][1] && board[2][0] == board[0][2] && board[1][1] != 0){
      return true;
    }else{
      return false;
    }
}

void reset(){
  fill(0);
  rect(0,0,width,height);
  fill(255);
if(winningCondition(grid)){
if(actionable == true){
  text("Eclipse Wins",width/2, height/2);
  }else{
  text("Cross Wins",width/2, height/2);
  }
}else{
  text("Tie", width/2, height/2);
}
  timer++;
  if(timer == 180){
    timer = 0;
    for(int i = 0;i<3;i++){
      for(int j = 0;j<3;j++){
        grid[i][j] = 0;
      }
    }
    actionable = false;
  }
}

boolean tieCondition(int[][] grid){
  for(int i = 0;i<3;i++){
    for(int j = 0;j<3;j++){
      if(grid[i][j] == 0){
        return false;
      }
    }
  }
  return true;
}

void mouseReleased(){
  int row = mouseX/100;
  int col = mouseY/100;
  if(grid[row][col] == 0 && actionable == true){
    grid[row][col] = 2;
    myServer.write(row + "," + col);
    actionable = false;
  }
}
