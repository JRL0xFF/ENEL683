/* 
POLISH EXPRESSion program state functions
This file has the code for each state of the program to help readability.
Each state has regular operation code PolishExpressionStateX() 
and mouse functionality code PolishExpressStateXMouse()
*/

/* Variables for State 2  */
byte s8GraphicState;
int  s32GraphicDelayValue;   
int  s32GraphicChangeDelay;
boolean bInState2;

/*****************************************************************************************
STATE 0
******************************************************************************************/
void PolishExpressState0()
{

    /* Variables local to this state */
    float bx;
    float by;
    int boxSize = 75;
    boolean overBox = false;
    boolean locked = false;
    float xOffset = 0.0; 
    float yOffset = 0.0; 
    
    int s32ButtonNumberPressed = -1;

    /* Always draw the background and menu */
    background(0);
    image(imgTitleScreen, 0, 0);
    DrawMainMenu();
    
    /* Track mouse for button control */
    
} /* end PolishExpressState0() */

void PolishExpressState0Mouse()
{

} /* end PolishExpressState0Mouse() */

/*****************************************************************************************
STATE 1
******************************************************************************************/
void PolishExpressState1()
{
  /* Variables local to this state */

  /* Test mode to get to state 2 with inits */
  s8ProgramState = 2;
  
  /* State exit */
  if(s8ProgramState != 1)
  {
    s8GraphicState = 0;
    s32GraphicDelayValue = 30 / s8GameLevel;   
    s32GraphicChangeDelay = s32GraphicDelayValue;
    bInState2 = true;        
  }
  
} /* end PolishExpressState1() */

void PolishExpressState1Mouse()
{

} /* end PolishExpressState1Mouse() */


/*****************************************************************************************
STATE 2
******************************************************************************************/
void PolishExpressState2()
{
  /* Variables local to this state */

      //<>//
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
    
    /* Update the animated graphics */
    shapeTrain(300,200,s8GraphicState);     
    
  }
  
  /* State exit */
  if(s8ProgramState != 2)
  {
    s8GraphicState = 0;
  }      
  
} /* end PolishExpressState2() */

void PolishExpressState2Mouse()
{

} /* end PolishExpressState2Mouse() */


/*****************************************************************************************
STATE 3
******************************************************************************************/
void PolishExpressState3()
{
  /* Variables local to this state */
    
} /* end PolishExpressState3() */

void PolishExpressState3Mouse()
{

} /* end PolishExpressState3Mouse() */
