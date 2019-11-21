/* 
POLISH EXPRESSion Shapes

Graphical items used in the Polish Express game.

*/

PShape shapeTrainBase, shapeTrain2, shapeTrain3;
color red = color(255,0,0);
color dark_red = color(152,21,21);
color gold = color(255,211,90);
color blue = color(5,178,255);
color gray = color(149,149,149);
color dark_gray = color(82,82,82);
color black = color(0,0,0);
color green = color(46,183,6);

int s32Counter = 0;
byte s8Mode = 1;

/*!************************************************************************************************
@fn shapeTrain(int s8TopLeftX_, int s8TopLeftY_, byte s8Mode_)
@brief Draws the main train graphic at the location specified.

The train graphic occupies an area 90 pixels wide by 55 pixels tall.

Requires
@param s8TopLeftX_ Starting X coordinate of the train 
@param s8TopLeftY_ Starting X coordinate of the train
@param s8Mode_     The wheel position (for animation: either 1, 2 or 3)

Promises
The train graphic will be drawn starting at the position given with the wheels in
one of the three positions 
*/
//void shapeTrain(int s32X_, int s32Y_, byte s8Mode_)
  
void setup()
{
  size(800,400);
}

void draw()
{
  s32Counter++;

  if(s32Counter == 10)
  {
    s32Counter = 0;

    /* The main train */

    /* Offset the drawing by the amount indicated */
    //translate(s32X_, s32Y_);
    translate(300,200);
    //scale(2.0);
    /* The gold parts of the train */
    fill(gold);
    quad(0,0, 35,0, 35,5, 0,5);
    quad(0,30, 30,30, 30,35, 0,35);
    quad(60,0, 75,0, 74,5, 61,5);
    quad(80,25, 83,25, 83,35, 80,35); 
    triangle(80,40, 90,62, 80,62);
    
    /* The red parts of the train */
    fill(red);
    quad(5,5, 30,5, 25,30, 10,30);
    quad(0,35, 80,35, 80,52, 0,52);
    fill(dark_red);
    quad(10,10, 25,10, 22,25, 13,25);
    
    /* The blue parts of the train */
    fill(blue);
    quad(30,20, 80,20, 80,40, 30,40);
    quad(74,5, 61,5, 65,20, 70,20);

    /* The common train wheels */
    fill(black);
    circle(17,52,24);
    circle(40,58,12);
    circle(55,58,12);
    circle(70,58,12);
  
    fill(gray);
    circle(17,52,20);
    circle(40,58,9);
    circle(55,58,9);
    circle(70,58,9);
      
    /* Mode-specific train wheel spokes */
    strokeWeight(2);
    //s8Mode = 3;
    switch(s8Mode)
    {
      case 1:
      {
        /* Train large wheel */
        line(17,41, 17,63);
        line(5,52, 29,52);

        /* Train small wheels */
        strokeWeight(1);
        line(40,53, 40,63);
        line(35,58, 45,58);

        line(55,53, 55,63);
        line(50,58, 60,58);

        line(70,53, 70,63);
        line(65,58, 75,58);
        break;
      } /* end case 1 */
  
      case 2:
      {
        line(21,44, 13,60);
        line(9,48, 25,56);

        strokeWeight(1);
        line(42,54, 38,62);
        line(37,56, 43,60);

        line(57,54, 53,62);
        line(52,56, 58,60);

        line(72,54, 68,62);
        line(67,56, 73,60);
        break;
        
      } /* end case 2 */
  
      case 3:
      {
        line(21,60, 13,44);
        line(9,56, 25,48);

        strokeWeight(1);
        line(42,62, 38,55);
        line(37,60, 44,55);

        line(57,62, 53,55);
        line(52,60, 59,55);

        line(72,62, 68,55);
        line(67,60, 74,55);
        break;
        
      } /* end case 3 */
      
      default:
      {
        /* Don't print anything */
        break;
      }

    } /* end switch(s8Mode) */

    /* The train car */
    translate(-150,0);
    fill(green);
    rect(0,35,130,17);
    fill(black);
    rect(130,48, 20,3);

    /* The common train car wheels */
    fill(black);
    circle(20,58,12);
    circle(110,58,12);
  
    fill(gray);
    circle(20,58,9);
    circle(110,58,9);
    
    /* Mode-specific train car wheel spokes */
    strokeWeight(1);
    //s8Mode = 1;
    switch(s8Mode)
    {
      case 1:
      {
        line(20,53, 20,63);
        line(15,58, 25,58);

        line(110,53, 110,63);
        line(105,58, 115,58);
        break;
      } /* end case 1 */
  
      case 2:
      {
        line(22,54, 18,62);
        line(17,56, 23,60);

        line(112,54, 108,62);
        line(107,56, 113,60);
        break;
        
      } /* end case 2 */
  
      case 3:
      {
        line(22,62, 18,55);
        line(17,60, 24,55);

        line(112,62, 108,55);
        line(107,60, 114,55);
        break;
        
      } /* end case 3 */
      
      default:
      {
        /* Don't print anything */
        break;
      }

    } /* end switch(s8Mode) */
    
     /* Increment mode and wrap if necessary */
    s8Mode++;
    if(s8Mode == 4)
    {
      s8Mode = 1;
    }
    
  } /* end if(s32Counter) */
  
} /* end setup() */

/*
void draw()
{
  background(100);
  translate(50,100);
  shape(shapeTrain1);
  
*/
