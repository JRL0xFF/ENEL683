/* 
POLISH EXPRESSion ShapeGrid Class

A ShapeGrid is a 2D matrix container that keeps track of spaces that are filled.
It does not have a location on the screen, and it only stores chars.  A NULL is stored
for any empty location.  The class includes printing functions to display the matrix
contents.  Only when it is printed will it be realized at a specific location with a specific
size of each square.

A new object must be created with an overall x by y size. 
A rectangle of the full matrix is always shown as a wireframe, and any square that is occupied is indicated 
in color with the name of the object (e.g. QuadShape 'A' 2 x 3 blocks with blocksize 10 would appear as 
2 x 3 blocks of 10x10 pixels with the letter 'A' inside them).

API
public boolean AddQuadShape(byte s8TopLeftX_, byte s8TopLeftY_, byte s8SizeX_, byte s8SizeY_, char s8Name_)
public boolean RemoveQuadShape(char s8Name_)
public void DrawShapeGrid(byte s8TopLeftX_, byte s8TopLeftY_, int s32BlockSize_) 
*/

color colorFilledBlock = color(63,2,178);

//PFont fontBlock = createFont("Arial", 20, true);

class PE_ShapeGrid 
{
  private int m_s32GridWidth;
  private int m_s32GridHeight;
  private char[][] m_aacGrid;
  
  /* Track entries in the grid with a trio of data points (a sparse matrix); maximum entries when Width x Height 1x1 entries.
  This is redundant to the m_aacGrid which we don't really need if we have the entry data but 
  it makes it easier to visualize so we'll keep both the grid 2D array and the entry list */
  private char[] m_acEntryListNames;
  private byte[] m_as8EntryListWidths;
  private byte[] m_as8EntryListHeights;
  private int m_s32TotalEntries;

  /* Default constructor: create and initialize a 1x1 grid (default constructor should not be used) */
  public PE_ShapeGrid() 
  {
    /* Initialize grid size */
    m_s32GridWidth  = 1;
    m_s32GridHeight = 1;
    m_aacGrid = new char[m_s32GridHeight][m_s32GridWidth];
    m_aacGrid[0][0] = '\0';

    /* Initialize grid tracking values */
    m_s32TotalEntries = 0;
    m_acEntryListNames    = new char[1];
    m_as8EntryListWidths  = new byte[1];
    m_as8EntryListHeights = new byte[1];
    
    m_acEntryListNames[0]  = '\0';
    m_as8EntryListWidths[0]  = 0;
    m_as8EntryListHeights[0] = 0;
    
  } /* end public PE_ShapeGrid() default constructor */


  /* Constructor: create an empty grid of specified size */
  public PE_ShapeGrid(byte s8Width_, byte s8Height_) 
  {
    int s32EntryCounter = 0;
    
    /* Create private members */
    m_s32GridWidth  = s8Width_;
    m_s32GridHeight = s8Height_;
    m_aacGrid = new char[m_s32GridHeight][m_s32GridWidth];

    m_acEntryListNames    = new char[m_s32GridHeight * m_s32GridWidth];
    m_as8EntryListWidths  = new byte[m_s32GridHeight * m_s32GridWidth];
    m_as8EntryListHeights = new byte[m_s32GridHeight * m_s32GridWidth];
       
    /* Initialize grid and grid tracking values */
    m_s32TotalEntries = 0;
    for(int i = 0; i < m_s32GridHeight; i++)
    {
      for(int j = 0; j < m_s32GridWidth; j++)
      {
        m_aacGrid[i][j] = '\0';
        m_acEntryListNames[s32EntryCounter]  = '\0';
        m_as8EntryListWidths[s32EntryCounter]  = 0;
        m_as8EntryListHeights[s32EntryCounter] = 0;
        s32EntryCounter++;
      }
    }   
  } /* end public PE_ShapeGrid() constructor */


  /* Copy Constructor */
  public PE_ShapeGrid(PE_ShapeGrid Source_) 
  {
    int s32EntryCounter = 0;

    /* Create private members */
    this.m_s32GridWidth = Source_.m_s32GridWidth;
    this.m_s32GridHeight = Source_.m_s32GridHeight;
    this.m_aacGrid = new char[this.m_s32GridHeight][this.m_s32GridWidth];

    this.m_acEntryListNames    = new char[this.m_s32GridHeight * this.m_s32GridWidth];
    this.m_as8EntryListWidths  = new byte[this.m_s32GridHeight * this.m_s32GridWidth];
    this.m_as8EntryListHeights = new byte[this.m_s32GridHeight * this.m_s32GridWidth];
    
    /* Initialize grid and grid tracking values */
    for(int i = 0; i < this.m_s32GridHeight; i++)
    {
      for(int j = 0; j < this.m_s32GridWidth; j++)
      {
        this.m_aacGrid[i][j] = Source_.m_aacGrid[i][j];
        this.m_acEntryListNames[s32EntryCounter]    = Source_.m_acEntryListNames[s32EntryCounter];
        this.m_as8EntryListWidths[s32EntryCounter]  = Source_.m_as8EntryListWidths[s32EntryCounter];
        this.m_as8EntryListHeights[s32EntryCounter] = Source_.m_as8EntryListHeights[s32EntryCounter];
        s32EntryCounter++;
      }
    }  
  } /* end public PE_ShapeGrid copy constructor */
  
  
  /* Public functions to access members */
  public byte getWidth() 
  {
    return m_s32GridWidth;
  } /* end getWidth() */


  public byte getHeight() 
  {
    return m_s32GridHeight;
  } /* end getHeight() */
  
  /* API functions */
  /*!************************************************************************************************
  @fn public boolean AddQuadShape(PE_QuadShape InputQuadShape_, int s32TopLeftX_, int s32TopLeftY_)
  @brief This input QuadShape is added to the matrix with the top left corner specifed at TopLeftX, TopLeftY.
  
  Requires
  @param InputQuadShape_ is the PE_QuadShape object to be inserted into the ShapeGrid.
  @param s32TopLeftX_ is the proposed top left corner x-coordinate in the ShapeGrid 
         where the top left corner of the QuadShape will go
  @param s32TopLeftY_ is the proposed top left corner y-coordinate in the ShapeGrid 
         where the top left corner of the QuadShape will go
          
         
  Promises
  @returns TRUE and updates the ShapeGrid if the QuadShape will fit in ShapeGrid
  @returns FALSE and ShapeGrid is unchanged if QuadShape will not fit ShapeGrid
  */
  public boolean AddQuadShape(PE_QuadShape InputQuadShape_, int s32TopLeftX_, int s32TopLeftY_)
  {
    /* Boundary check: if input too large, exit immediately */
    if( ((s32TopLeftX_ + InputQuadShape_.getWidth())  > m_s32GridWidth) ||
        ((s32TopLeftY_ + InputQuadShape_.getHeight()) > m_s32GridHeight) ) 
    {
      return false;
    }
    
    /* Search the existing grid for any already occupied square */
    boolean bOccupied = false;
    byte i = s8TopLeftY_;
    byte j = s8TopLeftX_;
    
    while( (i < (s8TopLeftY_ + s8SizeY_)) && (!bOccupied))
    {
      while( (j < (s8TopLeftX_ + s8SizeX_)) && (!bOccupied))
      {
        if(m_aacGrid[i][j] != '\0')
        {
          bOccupied = true;
        }
        j++;
      }
      i++;
      j = s8TopLeftX_;
    }
    
    /* If at least one space was occupied, the QuadShapeCannot be added */
    if(!bOccupied)
    {
      return false;
    }
    
    /* Otherwise, change all corresponding spaces in m_aacGrid to the QuadShape name.  
    Debate if it's more efficient to do this on a copy of m_aacGrid in the search loop above... */
    i = s8TopLeftY_;
    j = s8TopLeftX_;
    
    while( i < (s8TopLeftY_ + s8SizeY_))
    {
      while( j < (s8TopLeftX_ + s8SizeX_)) 
      {
        m_aacGrid[i][j] = s8Name_;
        j++;
      }
      i++;
      j = s8TopLeftX_;
    }
    
    /* Find an empty location in the tracking struct */
    i = 0;
    while(m_acEntryListNames[i] != '\0')
    {
      i++;
    }
    
    /* Update the entry tracking struct */
    m_acEntryListNames[i]    = s8Name_;
    m_as8EntryListWidths[i]  = s8SizeX_;
    m_as8EntryListHeights[i] = s8SizeY_;
    m_s32TotalEntries++;
    
    return true;
    
  } /* end AddQuadShape() */


  /*!************************************************************************************************
  @fn public boolean RemoveQuadShape(char s8Name_)
  @brief Removes a QuadShape from the matrix if it exists in the matrix
  
  Requires
  @param s8Name_ Single char name of the QuadShape in ShapeGrid to be removed
  m_s32TotalEntries must be accurately kept
  
  Promises
  @returns TRUE if the QuadShape was present in ShapeGrid and now removed
    > s8Name is cleared from m_acEntryListNames and the corresponding values for 
      m_as8EntryListWidths and m_as8EntryListHeights are set to 0
    > m_s32TotalEntries decremented
    > m_aacGrid values corresponding to the Quadshape are set to '\0'
  @returns FALSE if the QuadShape was not in ShapeGrid; ShapeGrid and list entries unchanged

  */
  public boolean RemoveQuadShape(char s8Name_)
  {
    boolean bFoundEntry = false;
    int  s32EntryListIndex = 0;
    byte s8EntryWidth;
    byte s8EntryHeight;
    
    byte s8GridLocationWidth  = 0;
    byte s8GridLocationHeight = 0;
    
    /* Search for the entry; s32EntryListIndex will hold the index if found */
    while( (s32EntryListIndex < m_s32TotalEntries) && (!bFoundEntry) )
    {
      if(m_acEntryListNames[s32EntryListIndex] == s8Name_)
      {
        bFoundEntry = true;
      }
      else
      {
        s32EntryListIndex++;
      }
    }
   
    /* Return if the entry was not found */
    if(!bFoundEntry)
    {
      return false;
    }
    
    /* Save the entry info from the tracking struct */
    s8EntryWidth = m_as8EntryListWidths[s32EntryListIndex];
    s8EntryHeight = m_as8EntryListHeights[s32EntryListIndex];

    /* Remove the QuadShape from the grid starting by finding the first instance of s8Name_ */
    s8GridLocationWidth = 0;
    s8GridLocationHeight = 0;
    bFoundEntry = false;
    
    /* Loop through the whole grid until the first instance of s8Name_ is found which leaves
    s8GridLocationWidth and s8GridLocationHeight as the index of the QuadShape to remove in ShapeGrid */ 
    while( (s8GridLocationHeight < m_s32GridHeight) && (!bFoundEntry) )
    {
      while( (s8GridLocationWidth < m_s32GridWidth) && (!bFoundEntry) )
      {
        if(m_aacGrid[s8GridLocationHeight][s8GridLocationWidth] == s8Name_)
        {
          bFoundEntry = true;
        }
        else
        {
          s8GridLocationWidth++;
        }
      }
      
      /* Only increment indicies if the entry hasn't been found yet */
      if(!bFoundEntry)
      {
        s8GridLocationHeight++;
        s8GridLocationWidth = 0;
      }
    }    
    
    /* Now we know where in ShapeGrid the start of QuadShape is, and we have the size of the QuadShape
    from the entry list.  Loop through m_aacGrid and reset the values to '\0'. */
    int i = s8GridLocationHeight;
    int j = s8GridLocationWidth;
    
    while( i < (s8GridLocationHeight + m_as8EntryListHeights[s32EntryListIndex]) )
    {
      while( j < (s8GridLocationWidth + m_as8EntryListWidths[s32EntryListIndex]) ) 
      {
        m_aacGrid[i][j] = '\0';
        j++;
      }
      i++;
      j = s8GridLocationWidth;
    }    
        
    /* Remove the entry from the tracking struct */
    m_acEntryListNames[s32EntryListIndex]    = '\0';
    m_as8EntryListWidths[s32EntryListIndex]  = 0;
    m_as8EntryListHeights[s32EntryListIndex] = 0;
    m_s32TotalEntries--;
    
    return true;
    
  } /* end public boolean RemoveQuadShape(char s8Name_) */
  

  /*!************************************************************************************************
  @fn public void DrawShapeGrid(byte s8TopLeftX_, byte s8TopLeftY_, int s32BlockSize_) 
  @brief The ShapeGrid is printed with the top left corner specifed at TopLeftX, TopLeftY.
  
  Each ShapeGrid matrix entry is printed as a box of size s32BlockSize x s32BlockSize. 
  For empty locations in ShapeGrid, the printed box will appear as a white square with a black outline.  
  For locations in ShapeGrid where a QuadShape element is present, the box will be a purple square with 
  a black outline and white letter showing the name of the QuadShape.  If s32BlockSize is too small,
  the letter will not be printed.
  
  Requires
  @param s8TopLeftX_  Starting X coordinate of top left pixel of the ShapeGrid
  @param s8TopLeftY_  Starting Y coordinate of top left pixel of the ShapeGrid
  @param s32BlockSize Size of the edge of a box; boxes are always square and should be at least 10 pixels  
  
  Promises
  The full ShapeGrid is printed at the location specifed
  */
  public void DrawShapeGrid(byte s8TopLeftX_, byte s8TopLeftY_, int s32BlockSize_) 
  {
    /* Set font height based on the size of the block, but limit to a maximum size */    
    int s32FontHeight = 0;
    
    if(s32BlockSize_ >= 10)
    {
      s32FontHeight = s32BlockSize_ - 4;
    }
    
    if(s32BlockSize_ > 52)
    {
      s32FontHeight = 48;
    }

    //textFont(fontBlock, s32FontHeight);
    textAlign(CENTER, CENTER);

    /* Draw each box and fill in if the box contains a char. */
    for(int i = 0; i < m_s32GridHeight; i++)
    {
      for(int j = 0; j < m_s32GridWidth; j++)
      {
        if(m_aacGrid[i][j] == '\0')
        {
          /* Draw an empty box */
          fill(255);
          rect( (i * s32BlockSize_), (j * s32BlockSize_), s32BlockSize_, s32BlockSize_);
        }
        else
        {
          /* Draw a filled box and add the font if the block is large enough */ 
          fill(colorFilledBlock);
          rect( (i * s32BlockSize_), (j * s32BlockSize_), s32BlockSize_, s32BlockSize_);
          if(s32FontHeight > 8)
          {
            fill(255);
            text(m_aacGrid[i][j], i * s32BlockSize_, j * s32BlockSize_);
          }
        }
      }
    } /* end for(int i = 0; i < m_s32GridHeight; i++) */    
    
  } /* end DrawShapeGrid() */

} /* end class PE_ShapeGrid */
