/* POLISH EXPRESSion OVERVIEW (in case you missed it, this is a take on the movie "Polar Express")
2019-11-06 Version 1: The purpose of this game is to practice and improve floor planning using translation from
a Polish Expression to clustered floorplan. Players are given a PE and a stack of labelled blocks.
These both appear on the train icon.  The train "moves" along the track toward a hole where a bridge
must be built using the blocks.  The user clicks and drags blocks into the bridge grid per the 
PE and must complete all placement correctly before the train arrives at the bridge.

Improvements:
- randomly generate PEs to solve
- background music for start screen, gameplay (different levels), and end screen
- sound effects for movements
- PE optimization
*/

/* Audio functions */
import processing.sound.*;

/* Display parameters for screen adjustment */
int s32DisplayWidth  = displayWidth;
int s32DisplayHeight = displayHeight;

byte s8ProgramState = 0;
/* 
Program States
0 = Start screen (set options; exits on "Start" button)
1 = Game starting (starting countdown; exits on timer delay)
2 = Game playing (graphics and gameplay active; exits on "quit" button, death, or completion of level)
3 = Game over (good-bye screen; exits on "OK" or "Exit" buttons)
*/

/* Program variables */
byte s8GameLevel = 1;

void setup()
{
  fullScreen();
}


void draw()
{

  switch(s8ProgramState)
  {
    /* State 0 = Start screen (set options; exits on "Start" button */
    case(0):
    {
      
      break;     
    } /* end Start screen */

    /* State 1 = Game starting (starting countdown; exits on timer delay) */
    case(1):
    {

      break;
    } /* end Game starting */


    /* State 2 = Game playing (graphics and gameplay active; exits on "quit" button, death, or completion of level) */
    case(2):
    {
      byte s8GraphicState = 0;
      int  s32GraphicDelayValue = 300 / s8GameLevel;   
      int  s32GraphicChangeDelay = s32GraphicDelayValue;
      bool bInState2 = TRUE;
      
      /* Update the graphics every s32GraphicDelayValue iterations */
      s32GraphicChangeDelay--;
      if(s32GraphicChangeDelay == 0)
      {
        /* Update all values for the graphic change */
        s32GraphicChangeDelay = s32GraphicDelayValue;
        s8GraphicState++;
        if(s8GraphicState == 3)
        {
          s8GraphicState = 0;
        }
        
      }
      
      /* Draw the current landscape */
      

      /* State exit */
      if(s8ProgramState != 2)
      {
        u8GraphicState = 0;
      }
      
      
      break;     
    } /* end Game playing */


    /* 3 = Game over (good-bye screen; exits on "OK" or "Exit" buttons) */
    case(3):
    {
      
      break;     
    } /* Game over */


    default:
    {
      print("ERROR: undefined program state\n\r");
      exit();
    } /* end default */

  } /* end switch(s8ProgramState) */
  
}
