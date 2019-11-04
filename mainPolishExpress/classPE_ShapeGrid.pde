/* 
POLISH EXPRESSion ShapeGrid Class
A ShapeGrid is just a 2D matrix container that keeps track of spaces that are filled.
It does not have a location on the screen, and it only stores chars.  A NULL is stored
for any empty location.  The class includes printing functions to display the matrix
contents.  Only when it is printed it will be realized at a specific location with a specific
size of each square.

A new object must be created with an overall x by y size. Objects are added to the matrix one-by-one and 
each addition is checked if it will fit as specified.  The ShapeGrid.draw() draws the current matrix.  
A rectangle of the full matrix is always shown as a wireframe, and any square that is occupied is indicated 
in color with the name of the object (e.g. QuadShape 'A' 2 x 3 blocks with blocksize 10 would appear as 
2 x 3 blocks of 10x10 pixels with the letter 'A' inside them).

*/
class PE_ShapeGrid 
{
  private int m_s32GridWidth;
  private int m_s32GridHeight;
  private char[][];
  

  /* Default constructor: create a valid shape at 0,0
  This should not be used... */
  public PE_ShapeGrid() 
  {
    m_s32BlocksWidth  = 1;
    m_s8Height = 1;
    m_s32CurrentLocationX = 0;
    m_s32CurrentLocationY = 0;
    m_s32Rotation = 0;
    m_cName = '0';
  } /* end public PE_QuadShape() default constructor */

  /* Constructor: create a valid shape of specified size, location, and rotation */
  public PE_QuadShape(byte s8Width_, byte s8Height_, 
                      int s32CurrentLocationX_, int s32CurrentLocationY_,
                      int s32Rotation_, char cName_) 
  {
    m_s8Width  = s8Width_;
    m_s8Height = s8Height_;
    m_s32CurrentLocationX = s32CurrentLocationX_;
    m_s32CurrentLocationY = s32CurrentLocationY_;
    m_s32Rotation = s32Rotation_;
    m_cName = cName_;
  } /* end public PE_QuadShape() constructor */

  /* Copy Constructor */
  public PE_QuadShape(PE_QuadShape Source_) 
  {
    this.m_s8Width = Source_.wid;
    this.m_s8Height = Source_.m_s8Height;
    this.m_s32CurrentLocationX = Source_.m_s32CurrentLocationX;
    this.m_s32CurrentLocationY = Source_.m_s32CurrentLocationY;
    this.m_s32Rotation = Source_.m_s32Rotation;
    this.m_cName = Source_.m_cName;
  }
  
  
  /* Public functions to access members */
  public s8 getWidth() 
  {
    return m_s8Width;
  } /* end getWidth() */


  public s8 getHeight() 
  {
    return s8Height_;
  } /* end s8Height_() */
  
  
  public s32 getLocX() 
  {
    return m_s32CurrentLocationX;
  } /* end getLocX() */

  
  public s32 getLocY() 
  {
    return m_s32CurrentLocationY;
  } /* end getLocY() */
  
  
  public s32 getRotation() 
  {
    return m_s32Rotation;
  } /* end getRotation() */  

  /* Public functions to uppdate members */  
  public void setLocation(int s32NewX_, int s32NewY_) 
  {
    m_s32CurrentLocationX = s32NewX_;
    m_s32CurrentLocationY = s32NewY_;
  } /* end setLocation() */
  
  
  public void setRotation(int s32NewRot_) 
  {
    m_s32Rotation = s32NewRot_;
  } /* end setRotation() */  

} /* end class PE_QuadShape */
