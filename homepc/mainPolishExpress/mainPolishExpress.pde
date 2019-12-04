/* 
POLISH EXPRESSion OVERVIEW (in case you missed it, this is a take on the movie "Polar Express" hence the train)

Credits:
The Polar Express is an awesome movie in this game is an obvious rip-off of the imagery.  Hopefully this game
inspires people to check out the movie!

Menu button code is taken from "Version3" example program provided in ENEL683.  Author unknown, but thank you! 
The code was modified for this application.

Version History
2019-11-06 Version 1: The purpose of this game is to practice and improve floor planning using translation from
a Polish Expression (PE) to clustered floorplan. Players are given a PE and a stack of labelled blocks.
These both appear on the train icon.  The train moves along the track toward a hole where a bridge
must be built using the blocks.  Actually, the hole moves toward the train but the effect is the same.
The user clicks and drags blocks into the bridge grid per the PE and must complete all placement correctly 
before the train arrives at the bridge.  There are 5 bridges per level to get up the mountain.  Each level
is increasingly difficult in speed and size of the bridges to solve.

Improvements:
- randomly generate PEs to solve
- background music for start screen, gameplay (different levels), and end screen
- sound effects for movements
- PE optimization and better algorithm challenges to better meet the requirements of the assignment
- Do "something" with the collection of PEs used.
- Save high score to file so it persists
*/

/* Audio */
import processing.sound.*;
SoundFile songMenuScreen;
SoundFile songGameScreen;
boolean bSoundOn = true;
//boolean bSoundOn = false;
 

/* Images */
PImage imgTitleScreen;
PImage imgInstrScreen;
PImage imgGameScreen;

/* Display parameters for screen adjustment */
int s32DisplayWidth  = displayWidth;
int s32DisplayHeight = displayHeight;

/* Colors */
color red = color(255,0,0);
color dark_red = color(152,21,21);
color gold = color(255,211,90);
color blue = color(5,178,255);
color gray = color(149,149,149);
color dark_gray = color(82,82,82);
color black = color(0,0,0);
color green = color(46,183,6);
color button_color = color(125,156,222);
color button_color_mouse_over = color(173,193,234);
color button_text_color = color(255,255,255);
color button_background = color(92,101,121);

/* Fonts (adapted from "Version3" example code in ENEL683 */
//PFont fontMenu = createFont("Calibri-Bold", 48, true);


/* 
Program States
0 = Start screen (Difficulty option, "Start Game" button, "Exit" button, "Instructions" button)
1 = Game starting (starting countdown; exits on timer delay; no user input)
2 = Game playing (graphics and gameplay active; exits on "quit" button, death, or completion of level)
3 = Game over (good-bye screen; exits on "OK" or "Exit" buttons)
*/
byte s8ProgramState = 1;

/* Program variables */
byte s8GameLevel = 2;
int  s32CurrentScore = 0;
int  s32HighScore = 0;

/* Buttons - arrays are [BUTTON_NUMBER][RECTANGLE_PARAMETER] */
final int s32NoButtonPressed = -1;

int [][]as32MenuButtons;    
final int s32NumMenuButtons = 3;
final int s32MenuStartButton = 0;
final int s32MenuInstructionsButton = 1;
final int s32MenuQuitButton = 2;
StringList strMenuButtonNames;

int [][]as32GameButtons;    
final int s32NumGameButtons = 1;
final int s32GameStopButton = 0;
StringList strGameButtonNames;

int [][]as32EndButtons;
final int s32NumEndButtons = 3;
final int s32EndRestartButton = 0;
final int s32EndMenuButton = 1;
final int s32EndQuitButton = 2;
StringList strEndButtonNames;

void setup()
{
  //fullScreen();
  
  /* For now, set screen size to the TitleScreen image size */
  size(1200,675);
  imgTitleScreen = loadImage("TitleScreen.jpg");
  imgInstrScreen = loadImage("GameInstructions.jpg");
  imgGameScreen  = loadImage("GameBackground.jpg");
  
  /* One-time menu and buttons setup */
  as32MenuButtons = new int[s32NumMenuButtons][4];
  as32GameButtons = new int[s32NumGameButtons][4];
  as32EndButtons  = new int[s32NumEndButtons][4];
  
  /* Menu START button */
  as32MenuButtons[s32MenuStartButton][0] = 875;
  as32MenuButtons[s32MenuStartButton][1] = 400;
  as32MenuButtons[s32MenuStartButton][2] = 250;
  as32MenuButtons[s32MenuStartButton][3] = 50;  

  /* Menu INSTRUCTIONS button */
  as32MenuButtons[s32MenuInstructionsButton][0] = 875;
  as32MenuButtons[s32MenuInstructionsButton][1] = 475;
  as32MenuButtons[s32MenuInstructionsButton][2] = 250;
  as32MenuButtons[s32MenuInstructionsButton][3] = 50;  

  /* Menu QUIT button */
  as32MenuButtons[s32MenuQuitButton][0] = 875;
  as32MenuButtons[s32MenuQuitButton][1] = 550;
  as32MenuButtons[s32MenuQuitButton][2] = 250;
  as32MenuButtons[s32MenuQuitButton][3] = 50;  
  
  strMenuButtonNames = new StringList();
  strMenuButtonNames.append("START GAME");
  strMenuButtonNames.append("INSTRUCTIONS");
  strMenuButtonNames.append("QUIT");


  /* Game STOP button */
  as32GameButtons[s32MenuStartButton][0] = 25;
  as32GameButtons[s32MenuStartButton][1] = 25;
  as32GameButtons[s32MenuStartButton][2] = 100;
  as32GameButtons[s32MenuStartButton][3] = 25;  

  strGameButtonNames = new StringList();
  strGameButtonNames.append("STOP");
  
  
  /* End RETRY button */
  as32EndButtons[s32MenuStartButton][0] = 525;
  as32EndButtons[s32MenuStartButton][1] = 250;
  as32EndButtons[s32MenuStartButton][2] = 250;
  as32EndButtons[s32MenuStartButton][3] = 50;  

  /* End MAIN MENU button */
  as32EndButtons[s32MenuInstructionsButton][0] = 525;
  as32EndButtons[s32MenuInstructionsButton][1] = 325;
  as32EndButtons[s32MenuInstructionsButton][2] = 250;
  as32EndButtons[s32MenuInstructionsButton][3] = 50;  

  /* End QUIT button */
  as32EndButtons[s32MenuQuitButton][0] = 525;
  as32EndButtons[s32MenuQuitButton][1] = 400;
  as32EndButtons[s32MenuQuitButton][2] = 250;
  as32EndButtons[s32MenuQuitButton][3] = 50;  

  strEndButtonNames = new StringList();
  strEndButtonNames.append("RETRY");
  strEndButtonNames.append("MAIN MENU");
  strEndButtonNames.append("QUIT");

  
  /* Setup audio and opening screen song */
  if(bSoundOn)
  {
    songMenuScreen = new SoundFile(this, "bensound-jazzyfrenchy_intro.mp3");  /* https://www.bensound.com/royalty-free-music/track/jazzy-frenchy */
    songGameScreen = new SoundFile(this, "bensound-funnysong_game.mp3");      /* https://www.bensound.com/royalty-free-music/track/funny-song */
    songMenuScreen.loop();
  }

  s8ProgramState = 0;
  
} /* end setup() */


void draw()
{

  switch(s8ProgramState)
  {
    /* Start screen (Difficulty option, "Start Game" button, "Exit" button, "Instructions" button) */
    case 0:
    {
      PolishExpressState0();     
      break;     
    } /* end Start screen */

    /* State 1 = Game starting (starting countdown; exits on timer delay) */
    case 1:
    {
      PolishExpressState1();     
      break;
    } /* end Game starting */


    /* State 2 = Game playing (graphics and gameplay active; exits on "quit" button, death, or completion of level) */
    case 2:
    {      
      PolishExpressState2();     
      break;     
    } /* end Game playing */


    /* 3 = Game over (good-bye screen; exits on "OK" or "Exit" buttons) */
    case 3:
    {
      PolishExpressState3();           
      break;     
    } /* end Game over */


    default:
    {
      print("ERROR: undefined program state\n\r");
      exit();
    } /* end default */

  } /* end switch(s8ProgramState) */
  
} /* end draw() */


void mousePressed() 
{
  switch(s8ProgramState)
  {
    /* Start screen (Difficulty option, "Start Game" button, "Exit" button, "Instructions" button) */
    case 0:
    {
      PolishExpressState0Mouse();       
      break;     
    } /* end Start screen mouse functionality */

    /* State 1 = Game starting (starting countdown; exits on timer delay) */
    case 1:
    {
      PolishExpressState1Mouse();
      break;
    } /* end Game starting mouse functionality */

    /* State 2 = Game playing (graphics and gameplay active; exits on "quit" button, death, or completion of level) */
    case 2:
    {      
      PolishExpressState2Mouse();
      break;     
    } /* end Game playing mouse functionality */

    /* 3 = Game over (good-bye screen; exits on "OK" or "Exit" buttons) */
    case 3:
    {
      PolishExpressState3Mouse();
      break;     
    } /* end Game over mouse functionality */


    default:
    {
      print("ERROR: undefined mouse pressed state\n\r");
      exit();
    } /* end default */

  } /* end switch(s8ProgramState) */

} /* end mousePressed() */





  