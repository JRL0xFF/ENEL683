/* 
POLISH EXPRESSion Quadrilateral Shape Class

This class provides the size and location definition for the rectangles used in "The Polish Expression" game.
The class includes functions to print out the shape according to its dimensional size and the block size.
Each Quadrilateral is built by squares that are s8Width x s8Height x s32BlockSize² pixels.

*/
class PE_QuadShape 
{
  private int m_s32CurrentLocationX;
  private int m_s32CurrentLocationY;
  private int m_s32Width;
  private int m_s32Height;
  private int m_s32Rotation;
  private int m_s32Label;
  
  //private int m_s32BlockSize = 10; 

  /* Default constructor: create a valid shape at 0,0 but this should not be used */
  public PE_QuadShape() 
  {
    m_s32CurrentLocationX = 0;
    m_s32CurrentLocationY = 0;
    m_s32Width  = 1;
    m_s32Height = 1;
    m_s32Rotation = 0;
    m_s32Label = 0;
  } /* end public PE_QuadShape() default constructor */

  /* Constructor: create a valid shape of specified size, location, and rotation */
  public PE_QuadShape(int s32CurrentLocationX_, int s32CurrentLocationY_,
                      int s32Width_, int s32Height_, 
                      int s32Rotation_, int s32Label_) 
  {
    m_s32CurrentLocationX = s32CurrentLocationX_;
    m_s32CurrentLocationY = s32CurrentLocationY_;
    m_s32Width  = s32Width_;
    m_s32Height = s32Height_;
    m_s32Rotation = s32Rotation_;
    m_s32Label = s32Label_;
  } /* end public PE_QuadShape() constructor */

  /* Copy Constructor */
  public PE_QuadShape(PE_QuadShape Source_) 
  {
    this.m_s32CurrentLocationX = Source_.m_s32CurrentLocationX;
    this.m_s32CurrentLocationY = Source_.m_s32CurrentLocationY;
    this.m_s32Width = Source_.m_s32Width;
    this.m_s32Height = Source_.m_s32Height;
    this.m_s32Rotation = Source_.m_s32Rotation;
    this.m_s32Label = Source_.m_s32Label;
  }
  
  
  /* Public functions to access members */
  public int getLocX() 
  {
    return m_s32CurrentLocationX;
  } /* end getLocX() */

  
  public int getLocY() 
  {
    return m_s32CurrentLocationY;
  } /* end getLocY() */

  
  public int getWidth() 
  {
    return m_s32Width;
  } /* end getWidth() */


  public int getHeight() 
  {
    return m_s32Height;
  } /* end getHeight() */
    
  
  public int getRotation() 
  {
    return m_s32Rotation;
  } /* end getRotation() */  

  
  public int getLabel() 
  {
    return m_s32Label;
  } /* end getLabel() */  


  public void printQuadShape(color colorFillBlock)
  {
    /* Draw a filled box and add the font if the block is large enough */ 
   
    if(s32GridBoxSize >= 10)
    {
      textSize(s32GridBoxSize - 4);
    }
    
    if(s32GridBoxSize > 52)
    {
      textSize(48);
    }

    textAlign(CENTER, CENTER);
    for(int i = 0; i < m_s32Height; i++)
    {
      for(int j = 0; j < m_s32Width; j++)
      {
         fill(colorFillBlock);
         rect(m_s32CurrentLocationX + (s32GridBoxSize * j), 
              m_s32CurrentLocationY - (s32GridBoxSize * i), 
              s32GridBoxSize, s32GridBoxSize);
             
        if(s32GridBoxSize > 10)
        {
          fill(255);
          text(m_s32Label, m_s32CurrentLocationX + (s32GridBoxSize * j) + 10,
               m_s32CurrentLocationY - (s32GridBoxSize * i) + 8 );
        }  
      }
    }
  } /* end printQuadShape() */


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
