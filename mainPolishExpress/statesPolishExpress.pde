/* 
POLISH EXPRESSion program state functions
This file has the code for each state of the program to try to help readability.
Each state has regular operation code PolishExpressionStateX() 
and mouse functionality code PolishExpressStateXMouse()
*/

/* Global variables */
int  s32ButtonNumberPressed = s32NoButtonPressed;
int  s32GraphicDelayValue;   
int  s32GraphicChangeDelay;
int  s32BridgeLocation;
int  s32BridgeMoveDelay;
byte s8GraphicState;

int s32UserGridLocationX;
int s32UserGridLocationY;

final int s32UserGridXEasy = 550;
final int s32UserGridYEasy = 300;

final int s32UserGridXMedium = 525;
final int s32UserGridYMedium = 275;

final int s32UserGridXHard = 500;
final int s32UserGridYHard = 250;

final int s32GridBoxSize = 20;

char[] PEString;
int s32OverBox;
boolean bMouseLocked = false;
float xOffset = 0.0; 
float yOffset = 0.0;

/*****************************************************************************************
STATE 0: Start screen (Difficulty option, "Start Game" button, "Exit" button, "Instructions" button)
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
      rect(as32MenuButtons[i][0], as32MenuButtons[i][1], as32MenuButtons[i][2], as32MenuButtons[i][3], s32ButtonCornerRadius);
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
      
      /* Set up the game parameters for the next state */
      DifficultyControl.get(ScrollableList.class, "Difficulty").setBarVisible(false);
      s32GameLevel = int(DifficultyControl.get(ScrollableList.class, "Difficulty").getValue() ) + 1;

      /* Create the solution grids and game pieces; any previous grids should be garbage collected, right Java? */
      if(s32GameLevel == 3)
      {
        UserSolutionGrid = new PE_ShapeGrid(s32HardWidth, s32HardHeight);
        s32UserGridLocationX = s32UserGridXHard;
        s32UserGridLocationY = s32UserGridYHard;
      }
      else if(s32GameLevel == 2)
      {
        UserSolutionGrid = new PE_ShapeGrid(s32MediumWidth, s32MediumHeight);
        s32UserGridLocationX = s32UserGridXMedium;
        s32UserGridLocationY = s32UserGridYMedium;
      }
      else
      {
        UserSolutionGrid = new PE_ShapeGrid(s32EasyWidth, s32EasyHeight);
        s32UserGridLocationX = s32UserGridXEasy;
        s32UserGridLocationY = s32UserGridYEasy;
        
        /* Get a PE and copy into the current expression */
        as32CurrentPE = new int[aas32PolishExpressionsEasy[0].length];
        for(int i = 0; i < as32CurrentPE.length; i++)
        {
          as32CurrentPE[i] = aas32PolishExpressionsEasy[0][i];
        }
                
        /* Create the slicing tree */
        CurrentSlicingTree = new PE_SlicingTree(as32CurrentPE.length, aas32PolishExpressionsEasy[0],
                                                aas32EasyNodeWidths[0], aas32EasyNodeHeights[0],
                                                aas32EasyNodeRightChild[0], aas32EasyNodeLeftChild[0]);
      }
          
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
STATE 1: Game starting (starting countdown; exits on timer delay; no user input)
******************************************************************************************/
byte s8Count = 3;

final int s32DelayStart = 70;
final int s32PositionStart = -90;

int s32Delay = s32DelayStart;
int s32Position = s32PositionStart;
int s8Wheels = 0;

void PolishExpressState1()
{
  /* Variables local to this state */
  
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
  text("" + s8Count,440,150,300,300);

  /* Test mode to get to state 2 with inits */
  if(s32Delay == 0)
  {
    if(s8Count == 0)
    {
      s8ProgramState = 2;
    }

    /* Draw the background and count down box */
    s32Delay = s32DelayStart;
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
    
    /* Preset State 2 variables */
    s8GraphicState = 0;
    s32GraphicDelayValue = int(30 / s32GameLevel);   
    s32GraphicChangeDelay = s32GraphicDelayValue;
    image(imgGameScreen, 0, 0);
    shapeTrain(190, 490, 0);
    s32BridgeLocation = 1200;
    s32BridgeMoveDelay = 0;
    
    /* Generate and print the available blocks - for now, just stack them straight up on the train car */
    UserQuadShapes = new PE_QuadShape[CurrentSlicingTree.getNumLeafNodes()];
    int s32TreeParser = 0;
    int s32HeightTracker = 0;
    
    /* Loop through the whole tree to find and print all of the leaf nodes.
    After this initial print, UserQuadShapes will refresh in State 2 and update
    with mouse activity. */
    for(int i = 0; i < CurrentSlicingTree.getTreeSize(); i++)
    {
      if(CurrentSlicingTree.getNodeType(i) > 0)
      {
        UserQuadShapes[s32TreeParser] = new PE_QuadShape(50, 500 - s32HeightTracker,
                                                         CurrentSlicingTree.getNodeLeafWidth(i),
                                                         CurrentSlicingTree.getNodeLeafHeight(i),
                                                         0, CurrentSlicingTree.getNodeType(i) );
        UserQuadShapes[s32TreeParser].printQuadShape(colorFilledBlock);
        s32TreeParser++;
        s32HeightTracker += CurrentSlicingTree.getNodeLeafHeight(i) * s32GridBoxSize;
        /* Check if at end though this *should* be redundant */
        if(s32TreeParser == CurrentSlicingTree.getNumLeafNodes())
        {
          break;
        }
      }
    }
    
    /* Prepare the PE string for display */
    PEString = new char[CurrentSlicingTree.getTreeSize()];
    for(int i = 0; i < PEString.length; i++)
    {
      /* Parse out the node names and convert to cut value or number ASCII codes */
      PEString[i] = char(CurrentSlicingTree.getNodeType(i));
      if(PEString[i] == char(-1))
      {
        PEString[i] = 'V';
      }
      else if (PEString[i] == char(-2))
      {
        PEString[i] = 'H';
      }
      else
      {
        PEString[i] += 0x30;
      }
    }
    
    if(bSoundOn)
    {
      songGameScreen.loop();
    }
  } /* end if(s8ProgramState != 1) */
  
} /* end PolishExpressState1() */


void PolishExpressState1Mouse()
{
  /* Currently no mouse functionality here */
  
} /* end PolishExpressState1Mouse() */


/*****************************************************************************************
STATE 2: Game playing (graphics and gameplay active; exits on "quit" button, death, or completion of level)
******************************************************************************************/
void PolishExpressState2()
{
  /* Variables local to this state */

  /* Score box */
  fill(0);
  rect(1050,25,125,80, s32ButtonCornerRadius);

  textAlign(CENTER, CENTER);
  textSize(20);
  fill(255);
  text("SCORE",1050,25,125,40);
  text("0",1050,25,125,100);

  image(imgGameScreen, 0, 0);
  shapeTrain(190, 490, s8GraphicState);
  
  /* Update the bridge location */
  fill(white);
  rect(s32BridgeLocation, 561, s32GridBoxSize * ((2 * s32GameLevel) + 4), 90);
  fill(blue);
  rect(s32BridgeLocation, 650, s32GridBoxSize * ((2 * s32GameLevel) + 4), 25);
  
  s32BridgeMoveDelay++;
  if(s32BridgeMoveDelay == 3)
  {
    s32BridgeMoveDelay = 0;
    s32BridgeLocation--;     
  }

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

  /* Draw the puff of smoke with the PE inside */
  fill(gray);
  ellipse(260, 450, 250, 50);
  fill(black);
  text(PEString, 0, PEString.length, (200 + (PEString.length * 6)), 448);

  /* Print the User solution grid */
  UserSolutionGrid.DrawShapeGrid(s32UserGridLocationX, s32UserGridLocationY, s32GridBoxSize);

  /* Update the QuadShapes. For mouse-over, the Y-location must be adjusted since the boxes are being drawn from
  bottom to top and IsMouseOverRect assumes a standard top-down rectangle definition. */
  int[] as32QuadShape;
  as32QuadShape = new int[4];
  
  //s32OverBox = -1;
  for(int i = 0; i < UserQuadShapes.length; i++)
  {
    as32QuadShape[0] = UserQuadShapes[i].getLocX();
    as32QuadShape[1] = UserQuadShapes[i].getLocY() - ((UserQuadShapes[i].getHeight() - 1) * s32GridBoxSize);
    as32QuadShape[2] = UserQuadShapes[i].getWidth() * s32GridBoxSize;
    as32QuadShape[3] = UserQuadShapes[i].getHeight() * s32GridBoxSize;
    if(IsMouseOverRect(as32QuadShape))
    {
      UserQuadShapes[i].printQuadShape(colorFilledBlockHighlight);
      if(!bMouseLocked)
      {
        s32OverBox = i;
      }
    }
    else
    {
      UserQuadShapes[i].printQuadShape(colorFilledBlock);
    }    
  }
      
  /* Check the STOP button */
  
  /* Highlight the button on mouse-over */
  for (int i = 0; i < s32NumGameButtons; i++)
  { 
    if(IsMouseOverRect(as32GameButtons[i]))
    {
      fill(button_color_mouse_over);
      rect(as32GameButtons[i][0], as32GameButtons[i][1], as32GameButtons[i][2], as32GameButtons[i][3], s32ButtonCornerRadius);
    }
    else
    {
      fill(button_color);
      rect(as32GameButtons[i][0], as32GameButtons[i][1], as32GameButtons[i][2], as32GameButtons[i][3], s32ButtonCornerRadius);      
    }

    textAlign(CENTER, CENTER);
    textSize(14);
    fill(button_text_color);
    text(strGameButtonNames.get(i), as32GameButtons[i][0], as32GameButtons[i][1] - 2, as32GameButtons[i][2], as32GameButtons[i][3]);
  }  
  
  if(s32ButtonNumberPressed == s32GameStopButton)
  {
    s32ButtonNumberPressed = s32NoButtonPressed;
    s8ProgramState = 3;
    
    /* Can't decide whether nor not to leave the sound on here... */
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

  /* Manage box movement */
  if(s32OverBox >= 0)
  {
    bMouseLocked = true;
  }
  else
  {
    bMouseLocked = false;
  }
  
} /* end PolishExpressState2Mouse() */


void PolishExpressState2MouseDragged()
{
  if(bMouseLocked)
  {
    UserQuadShapes[s32OverBox].setLocation( int(mouseX - xOffset), int(mouseY-yOffset) );
  }
  
} /* end PolishExpressState2MouseDragged() */


void PolishExpressState2MouseReleased()
{
  bMouseLocked = false;
  s32OverBox = -1;
  
} /* end PolishExpressState2MouseReleased() */


/*****************************************************************************************
STATE 3: Game over (good-bye screen; exits on "OK" or "Exit" buttons)
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
      rect(as32EndButtons[i][0], as32EndButtons[i][1], as32EndButtons[i][2], as32EndButtons[i][3], s32ButtonCornerRadius);
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
      
      UserSolutionGrid.ClearShapeGrid();
      
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
      DifficultyControl.get(ScrollableList.class, "Difficulty").setBarVisible(true);


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
      print("ERROR: undefined end button press\n\r");
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
