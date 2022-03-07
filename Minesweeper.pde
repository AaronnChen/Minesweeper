import de.bezier.guido.*;

//CONSTANTS
private int NUM_ROWS = 11;
private int NUM_COLS = 11;
private int NUM_BOMBS = 10;
private int MIDDLE_X = NUM_ROWS / 2;
private int MIDDLE_Y = NUM_COLS / 2;

//ARRAYS
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

private boolean isLost = false;

void setup () {
  size(400, 400);
  textAlign(CENTER, CENTER);

  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int x = 0; x < NUM_ROWS; x++) {
    for (int y = 0; y < NUM_COLS; y++) {
      buttons[x][y] = new MSButton(x, y);
    }
  }

  setMines();
}

public void draw () {
  if (isWon() == true && isLost == false) displayWinningMessage();
}

public void setMines() { //set all the mines on the board
  for (int i = 0; i < NUM_BOMBS; i++) { //for the number of bombs you should have
    int row = (int)(Math.random() * NUM_COLS); //create a new random row #
    int col = (int)(Math.random() * NUM_ROWS); //create a new random column #

    if (!mines.contains(buttons[row][col])) //if the button at row and col isn't already a mine
      mines.add(buttons[row][col]); //make it a mine
  }
}

public boolean isWon() { //check if player won
  boolean bool = true;
  if(isLost == false) { //if they haven't lost
    for (int x = 0; x < NUM_ROWS; x++)  //for every button
      for (int y = 0; y < NUM_COLS; y++) 
        //if ANY button is not flagged or not clicked return not won
        if(!(buttons[x][y].isFlagged() || buttons[x][y].isClicked())) bool = false;
  } return bool;
}

public void displayWinningMessage() {
  buttons[MIDDLE_X][MIDDLE_Y - 1].setLabel("W");
  buttons[MIDDLE_X][MIDDLE_Y].setLabel("I");
  buttons[MIDDLE_X][MIDDLE_Y + 1].setLabel("N");
}
       
public void displayLosingMessage() {
  buttons[MIDDLE_X][MIDDLE_Y - 2].setLabel("L");
  buttons[MIDDLE_X][MIDDLE_Y - 1].setLabel("O");
  buttons[MIDDLE_X][MIDDLE_Y].setLabel("S");
  buttons[MIDDLE_X][MIDDLE_Y + 1].setLabel("E");
  buttons[MIDDLE_X][MIDDLE_Y + 2].setLabel("R");
  buttons[MIDDLE_X + 1][MIDDLE_Y - 1].setLabel("L");
  buttons[MIDDLE_X + 1][MIDDLE_Y].setLabel("O");
  buttons[MIDDLE_X + 1][MIDDLE_Y + 1].setLabel("L");
  
  for(int x = 0; x < NUM_ROWS; x++) 
    for(int y = 0; y < NUM_COLS; y++) 
      if(mines.contains(buttons[x][y])) 
        buttons[x][y].setClicked(true); //reveal all squares
}

public boolean isValid(int r, int c) {
  if (r >= 0 && c >= 0 && r < NUM_ROWS && c < NUM_COLS) return true;
  return false;
}

public int countMines(int row, int col) { //count mines around
  int numMines = 0;
  for (int x = -1; x <= 1; x++) 
    for (int y = -1; y <= 1; y++) 
      if(isValid(row + x, col + y) && mines.contains(buttons[row + x][col + y])) numMines++; 
  return numMines;
}

public class MSButton {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col ) {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed () {
    if(!(isWon() || isLost)) { //if the player has neither won or lost
      clicked = true;
      
      if(mouseButton == RIGHT) flagged = !flagged; //flag square using right click
      
      else if(mines.contains(this)) { //if the clicked square is a mine
        clicked = true;
        isLost = true;
        displayLosingMessage(); 
      }
      
      //if there is a bomb nearby, 
      else if(countMines(myRow, myCol) > 0) { myLabel = Integer.toString(countMines(myRow, myCol)); 
      System.out.println(myLabel); }
      
      //open surrounding not bomb
      else {
      for (int x = myRow - 1; x <= myRow + 1; x++) 
        for (int y = myCol - 1; y <= myCol + 1; y++) 
          if(isValid(x, y) && buttons[x][y].isClicked() == false) 
            buttons[x][y].mousePressed();
      }
    }
  }
  
  public void draw () {  
    if(flagged) fill(0, 255, 255); //flag
    
    else if( clicked && mines.contains(this) ) fill(200, 0, 0); //bomb 
    
    else if(clicked) fill(255); //click
    
    else fill(50); //reg

    rect(x, y, width, height);
    fill(0);
    text(myLabel,x+width/2,y+height/2);
  }
  
  public void setLabel(String newLabel) { myLabel = newLabel; }
  
  public void setLabel(int newLabel) { myLabel = ""+ newLabel; }
  
  public boolean isFlagged() { return flagged; }
  
  public void setClicked(boolean bool) { clicked = bool; }
  
  public boolean isClicked() { return clicked; }
}
