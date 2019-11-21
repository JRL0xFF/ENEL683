/* 
POLISH EXPRESSion OVERVIEW (in case you missed it, this is a take on the movie "Polar Express" hence the train)

2019-11-06 Version 1: The purpose of this game is to practice and improve floor planning using translation from
a Polish Expression (PE) to clustered floorplan. Players are given a PE and a stack of labelled blocks.
These both appear on the train icon.  The train moves along the track toward a hole where a bridge
must be built using the blocks.  Actually, the hole moves toward the train but the effect is the same.
The user clicks and drags blocks into the bridge grid per the PE and must complete all placement correctly 
before the train arrives at the bridge.

Improvements:
- randomly generate PEs to solve
- background music for start screen, gameplay (different levels), and end screen
- sound effects for movements
- PE optimization and better algorithm challenges to better meet the requirements of the assignment
- Create increasingly difficult bridges to climb a mountain and get to an end point.  Then do "something"
  with the collection of PEs used.
*/

/* Audio functions */
import processing.sound.*;

/* Display parameters for screen adjustment */
int s32DisplayWidth  = displayWidth;
int s32DisplayHeight = displayHeight;


/* Fonts (adapted from "Version3" example code in ENEL683 */
PFont fontMenu = createFont("Calibri-Bold", 48, true);


/* 
Program States
0 = Start screen (set options; exits on "Start" button)
1 = Game starting (starting countdown; exits on timer delay)
2 = Game playing (graphics and gameplay active; exits on "quit" button, death, or completion of level)
3 = Game over (good-bye screen; exits on "OK" or "Exit" buttons)
*/
byte s8ProgramState = 0;

/* Program variables */
byte s8GameLevel = 1;

void setup()
{
  fullScreen();
}


void draw()
{
  /* Test mode */
  s8ProgramState = 2;

  switch(s8ProgramState)
  {
    /* State 0 = Start screen (set options; exits on "Start" button) */
    case(0):
    {
      
      break;     
    } /* end Start screen */

    /* State 1 = Game starting (starting countdown; exits on timer delay) */
    case(1):
    {

      /* State exit */
      if(s8ProgramState != 1)
      {
        
      }

      break;
    } /* end Game starting */


    /* State 2 = Game playing (graphics and gameplay active; exits on "quit" button, death, or completion of level) */
    case(2):
    {
      /* Variables local to State 2 defined here (and Processing actually scopes them only to this case) */
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
