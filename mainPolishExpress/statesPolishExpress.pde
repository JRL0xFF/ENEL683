/* 
POLISH EXPRESSion program state functions
This file has the code for each state of the program to help readability.
Each state has regular operation code PolishExpressionStateX() 
and mouse functionality code PolishExpressStateXMouse()
*/

/* Global variables */
int s32ButtonNumberPressed = s32NoButtonPressed;
byte s8GraphicState;
int  s32GraphicDelayValue;   
int  s32GraphicChangeDelay;


/*****************************************************************************************
STATE 0
******************************************************************************************/
boolean bShowInstructions = false;

void PolishExpressState0()
{
    /* Variables local to this state */

    /* Always draw the background and menu */
    image(imgTitleScreen, 0, 0);
    DrawMainMenu();
    
    /* Draw the instructions if requested */
    if(bShowInstructions == true)
    {
       image(imgInstrScreen, 100, 150);
    }
    
    /* Highlight a button on mouse-over */
    for (int i = 0; i < s32NumMenuButtons; i++)
    { 
      if(IsMouseOverRect(as32MenuButtons[i]))
      {
        fill(button_color_mouse_over);
        rect(as32MenuButtons[i][0], as32MenuButtons[i][1], as32MenuButtons[i][2], as32MenuButtons[i][3]);
        fill(button_text_color);
        text(strMenuButtonNames.get(i), as32MenuButtons[i][0], as32MenuButtons[i][1], as32MenuButtons[i][2] - 5, as32MenuButtons[i][3] - 5);
      }
    }

    /* mousePressed() will update s32ButtonNumberPressed so check this */
    switch(s32ButtonNumberPressed)
    {
      /* Do nothing if no button is pressed */
      case s32NoButtonPressed:
      {
        break;     
      } /* end s32NoButtonPressed */
  
      /* Start button transitions to State 1 */
      case s32MenuStartButton:
      {
        s32ButtonNumberPressed = s32NoButtonPressed;
        
        if(bSoundOn)
        {
          songMenuScreen.stop();
        }

        bShowInstructions = false;
        s8ProgramState = 1;
        image(imgGameScreen, 0, 0);
        shapeTrain(190, 490, 0);

        break;
      } /* end s32MenuStartButton */
  
  
      /* Instruction button pops up the instruction screen */
      case s32MenuInstructionsButton:
      {      
        s32ButtonNumberPressed = s32NoButtonPressed;
        bShowInstructions = true;
        break;     
      } /* end s32MenuInstructionsButton */
  
  
      /* Quit button can immediately kill the program */
      case s32MenuQuitButton:
      {
        exit();
        break;     
      } /* end s32MenuQuitButton */
  
  
      default:
      {
        print("ERROR: undefined button press\n\r");
        exit();
      } /* end default */    
      
    } /* end switch (s32ButtonNumberPressed) */
      
} /* end PolishExpressState0() */

void PolishExpressState0Mouse()
{
  /* Check if mouse is currently over a button */
  s32ButtonNumberPressed = s32NoButtonPressed;
  for (int i = 0; i < s32NumMenuButtons; i++)
  { 
    if(IsMouseOverRect(as32MenuButtons[i]))
    {
      s32ButtonNumberPressed = i;
    }
  }
  
} /* end PolishExpressState0Mouse() */

/*****************************************************************************************
STATE 1
******************************************************************************************/
byte s8Count = 3;
char s16CountChar[] = {'3'};

final int s32DelayStart = 70;
final int s32PositionStart = -90;

int s32Delay = s32DelayStart;
int s32Position = s32PositionStart;
int s8Wheels = 0;

void PolishExpressState1()
{
  /* Variables local to this state */
  String strCount = new String(s16CountChar);
  
  image(imgGameScreen, 0, 0);
  if( (s32Position % 10) == 0)
  {
    s8Wheels++;
    if(s8Wheels == 3)
    {
      s8Wheels = 0;
    }
  }
  shapeTrain(s32Position, 490, s8Wheels);
  s32Position++;

  textAlign(CENTER, CENTER);
  textSize(100);
  fill(255);
  text(strCount,500,200,300,300);

  /* Test mode to get to state 2 with inits */
  //s8ProgramState = 2;
  if(s32Delay == 0)
  {
    if(s8Count == 0)
    {
      s8ProgramState = 2;
    }

    /* Draw the background and count down box */
    //fill(0);
    //rect(500,200,300,300);

    
    s32Delay = s32DelayStart;
    s16CountChar[0]--;
    s8Count--;
  }
  
  s32Delay--;
    
  /* State exit */
  if(s8ProgramState != 1)
  {  
    /* Reset State 1 variables for next time */
    s8Count = 3;
    s32Delay = s32DelayStart;
    s32Position = s32PositionStart;
    s16CountChar[0] = '3';
    
    /* Preset State 2 variables */
    s8GraphicState = 0;
    s32GraphicDelayValue = 30 / s8GameLevel;   
    s32GraphicChangeDelay = s32GraphicDelayValue;
    image(imgGameScreen, 0, 0);
    shapeTrain(190, 490, 0);

    if(bSoundOn)
    {
      songGameScreen.loop();
    }
}
  
} /* end PolishExpressState1() */

void PolishExpressState1Mouse()
{
  /* Currently no mouse functionality here */
  
} /* end PolishExpressState1Mouse() */


/*****************************************************************************************
STATE 2
******************************************************************************************/
void PolishExpressState2()
{
  /* Variables local to this state */

  /* Score box */
  fill(0);
  rect(1050,25,125,80);

  textAlign(CENTER, CENTER);
  textSize(20);
  fill(255);
  text("SCORE",1050,25,125,40);
  text("0",1050,25,125,100);
    
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
    shapeTrain(190,490,s8GraphicState);     
    
  }

  /* Check the STOP button */
  
  /* Highlight the button on mouse-over */
  for (int i = 0; i < s32NumGameButtons; i++)
  { 
    if(IsMouseOverRect(as32GameButtons[i]))
    {
      fill(button_color_mouse_over);
      rect(as32GameButtons[i][0], as32GameButtons[i][1], as32GameButtons[i][2], as32GameButtons[i][3]);
    }
    else
    {
      fill(button_color);
      rect(as32GameButtons[i][0], as32GameButtons[i][1], as32GameButtons[i][2], as32GameButtons[i][3]);      
    }

    textAlign(CENTER, CENTER);
    textSize(14);
    fill(button_text_color);
    text(strGameButtonNames.get(i), as32GameButtons[i][0], as32GameButtons[i][1], as32GameButtons[i][2], as32GameButtons[i][3]);
  }  
  
  if(s32ButtonNumberPressed == s32GameStopButton)
  {
    s32ButtonNumberPressed = s32NoButtonPressed;
    s8ProgramState = 3;
    if(bSoundOn)
    {
      //songGameScreen.stop();
    }
  }
  
  /* State exit */
  if(s8ProgramState != 2)
  {
    s8GraphicState = 0;
    if(s32CurrentScore > s32HighScore)
    {
      s32HighScore = s32CurrentScore;
    }
  }      
  
} /* end PolishExpressState2() */

void PolishExpressState2Mouse()
{
  /* Check if mouse is currently over a button */
  s32ButtonNumberPressed = s32NoButtonPressed;
  for (int i = 0; i < s32NumGameButtons; i++)
  { 
    if(IsMouseOverRect(as32GameButtons[i]))
    {
      s32ButtonNumberPressed = i;
    }
  }
  
} /* end PolishExpressState2Mouse() */


/*****************************************************************************************
STATE 3
******************************************************************************************/
void PolishExpressState3()
{
  /* Variables local to this state */
  /* Always draw the background and menu */
  DrawGameOverMenu();
  
  /* Highlight a button on mouse-over */
  for (int i = 0; i < s32NumEndButtons; i++)
  { 
    if(IsMouseOverRect(as32EndButtons[i]))
    {
      fill(button_color_mouse_over);
      rect(as32EndButtons[i][0], as32EndButtons[i][1], as32EndButtons[i][2], as32EndButtons[i][3]);
      fill(button_text_color);
      text(strEndButtonNames.get(i), as32EndButtons[i][0], as32EndButtons[i][1], as32EndButtons[i][2] - 5, as32EndButtons[i][3] - 5);
    }
  }

  /* mousePressed() will update s32ButtonNumberPressed so check this */
  switch(s32ButtonNumberPressed)
  {
    /* Do nothing if no button is pressed */
    case s32NoButtonPressed:
    {
      break;     
    } /* end s32NoButtonPressed */

    /* Restart button returns to State 1 */
    case s32EndRestartButton:
    {
      s32ButtonNumberPressed = s32NoButtonPressed;
      s32CurrentScore = 0;
      s8ProgramState = 1;
      image(imgGameScreen, 0, 0);
      shapeTrain(190, 490, 0);
      
      if(bSoundOn)
      {
        songGameScreen.stop();
      }

      break;
    } /* end s32EndRestartButton */


    /* Main menu button returns to main intro screen */
    case s32EndMenuButton:
    {      
      s32ButtonNumberPressed = s32NoButtonPressed;
      s8ProgramState = 0;

      if(bSoundOn)
      {
        songGameScreen.stop();
        songMenuScreen.loop();
      }

      break;     
    } /* end s32EndMenuButton */


    /* Quit button can immediately kill the program */
    case s32EndQuitButton:
    {
      exit();
      break;     
    } /* end s32EndQuitButton */


    default:
    {
      print("ERROR: undefined button press\n\r");
      exit();
    } /* end default */    
    
  } /* end switch (s32ButtonNumberPressed) */
  
} /* end PolishExpressState3() */

void PolishExpressState3Mouse()
{
  /* Check if mouse is currently over a button */
  s32ButtonNumberPressed = s32NoButtonPressed;
  for (int i = 0; i < s32NumEndButtons; i++)
  { 
    if(IsMouseOverRect(as32EndButtons[i]))
    {
      s32ButtonNumberPressed = i;
    }
  }
  
} /* end PolishExpressState3Mouse() */
