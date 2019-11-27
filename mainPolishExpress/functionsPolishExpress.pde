/* POLISH EXPRESSion program helper functions */

/*!************************************************************************************************
@fn void DrawMainMenu()
@brief Draws the main menu on the start screen

Requires
- NONE

Promises
All buttons in as32MenuButtons are written to the screen with a background border that extends
25 pixels around the buttons.
*/
void DrawMainMenu() 
{
  /* Menu background */
  fill(button_background);
  rect( (as32MenuButtons[0][0] - 25), ((as32MenuButtons[0][1] - 25)), (as32MenuButtons[0][2] + 50), ((as32MenuButtons[0][3] + 25) * s32NumMenuButtons) + 25);
  textAlign(CENTER, CENTER);

  /* Draw the buttons */
  textSize(20);
  for (int i = 0; i < s32NumMenuButtons; i++)
  {
    fill(button_color);
    rect(as32MenuButtons[i][0], as32MenuButtons[i][1], as32MenuButtons[i][2], as32MenuButtons[i][3]);
    fill(button_text_color);
    text(strMenuButtonNames.get(i), as32MenuButtons[i][0], as32MenuButtons[i][1], as32MenuButtons[i][2] - 5, as32MenuButtons[i][3] - 5);
  }

} /* end DrawMainMenu() */


/*!************************************************************************************************
@fn boolean IsMouseOverRect(int as32RectParameters[])
@brief Checks to see if the mouse if over a specified rectangle

Requires
@param as32RectParameters[] is four word array with standard rectangle parameters
  [0] top-left x-coordinate
  [1] top-left y-coordinate
  [2] x-size (width)
  [3] y-size (height)

Promises
- Returns true if the mouse is currently within the given rectangle
- Otherwise returns false

*/
boolean IsMouseOverRect(int as32RectParameters[]) 
{
  if (mouseX >= as32RectParameters[0] && mouseX <= as32RectParameters[0] + as32RectParameters[2] && 
      mouseY >= as32RectParameters[1] && mouseY <= as32RectParameters[1] + as32RectParameters[3]) 
  {
    return true;
  }
  else
  {
    return false;
  }
  
} /* end IsMouseOverRect() */
