/* 
POLISH EXPRESSion Quadrilateral Shape Class

This class provides the size and location definition for the rectangles used in "The Polish Expression" game.
The class includes functions to print out the shape according to its dimensional size and the block size.
*/
class PE_QuadShape 
{
  private byte m_s8Width;
  private byte m_s8Height;
  private int  m_s32CurrentLocationX;
  private int  m_s32CurrentLocationY;
  private int  m_s32Rotation;
  private char m_cName;
  
  /* Each Quadrilateral is built by squares that are s8Width x s8Height x s32BlockSize² pixels */
  private int  m_s32BlockSize = 10; 

  /* Default constructor: create a valid shape at 0,0 but this should not be used */
  public PE_QuadShape() 
  {
    m_s8Width  = 1;
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
    this.m_s8Width = Source_.m_s8Width;
    this.m_s8Height = Source_.m_s8Height;
    this.m_s32CurrentLocationX = Source_.m_s32CurrentLocationX;
    this.m_s32CurrentLocationY = Source_.m_s32CurrentLocationY;
    this.m_s32Rotation = Source_.m_s32Rotation;
    this.m_cName = Source_.m_cName;
  }
  
  
  /* Public functions to access members */
  public byte getWidth() 
  {
    return m_s8Width;
  } /* end getWidth() */


  public byte getHeight() 
  {
    return m_s8Height;
  } /* end getHeight() */
  
  
  public int getLocX() 
  {
    return m_s32CurrentLocationX;
  } /* end getLocX() */

  
  public int getLocY() 
  {
    return m_s32CurrentLocationY;
  } /* end getLocY() */
  
  
  public int getRotation() 
  {
    return m_s32Rotation;
  } /* end getRotation() */  

  /* Public functions to update members */  
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
