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
public boolean AddQuadShape(PE_QuadShape InputQuadShape_, int s32TopLeftX_, int s32TopLeftY_)
public boolean RemoveQuadShape(char s8Name_)
public void DrawShapeGrid(int s32TopLeftX_, int s32TopLeftX_, int s32BlockSize_) 
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
  private int[] m_as32EntryListWidths;
  private int[] m_as32EntryListHeights;
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
    m_acEntryListNames     = new char[1];
    m_as32EntryListWidths  = new int[1];
    m_as32EntryListHeights = new int[1];
    
    m_acEntryListNames[0]  = '\0';
    m_as32EntryListWidths[0]  = 0;
    m_as32EntryListHeights[0] = 0;
    
  } /* end public PE_ShapeGrid() default constructor */


  /* Constructor: create an empty grid of specified size */
  public PE_ShapeGrid(int s32Width_, int s32Height_) 
  {
    int s32EntryCounter = 0;
    
    /* Create private members */
    m_s32GridWidth  = s32Width_;
    m_s32GridHeight = s32Height_;
    m_aacGrid = new char[m_s32GridHeight][m_s32GridWidth];

    m_acEntryListNames     = new char[m_s32GridHeight * m_s32GridWidth];
    m_as32EntryListWidths  = new int[m_s32GridHeight * m_s32GridWidth];
    m_as32EntryListHeights = new int[m_s32GridHeight * m_s32GridWidth];
       
    /* Initialize grid and grid tracking values */
    m_s32TotalEntries = 0;
    for(int i = 0; i < m_s32GridHeight; i++)
    {
      for(int j = 0; j < m_s32GridWidth; j++)
      {
        m_aacGrid[i][j] = '\0';
        m_acEntryListNames[s32EntryCounter]  = '\0';
        m_as32EntryListWidths[s32EntryCounter]  = 0;
        m_as32EntryListHeights[s32EntryCounter] = 0;
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
    this.m_as32EntryListWidths  = new int[this.m_s32GridHeight * this.m_s32GridWidth];
    this.m_as32EntryListHeights = new int[this.m_s32GridHeight * this.m_s32GridWidth];
    
    /* Initialize grid and grid tracking values */
    for(int i = 0; i < this.m_s32GridHeight; i++)
    {
      for(int j = 0; j < this.m_s32GridWidth; j++)
      {
        this.m_aacGrid[i][j] = Source_.m_aacGrid[i][j];
        this.m_acEntryListNames[s32EntryCounter]     = Source_.m_acEntryListNames[s32EntryCounter];
        this.m_as32EntryListWidths[s32EntryCounter]  = Source_.m_as32EntryListWidths[s32EntryCounter];
        this.m_as32EntryListHeights[s32EntryCounter] = Source_.m_as32EntryListHeights[s32EntryCounter];
        s32EntryCounter++;
      }
    }  
  } /* end public PE_ShapeGrid copy constructor */
  
  
  /* Public functions to access members */
  public int getWidth() 
  {
    return m_s32GridWidth;
  } /* end getWidth() */


  public int getHeight() 
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
    int i = s32TopLeftY_;
    int j = s32TopLeftX_;
    
    while( (i < (s32TopLeftY_ + InputQuadShape_.getHeight() )) && (!bOccupied))
    {
      while( (j < (s32TopLeftX_ + InputQuadShape_.getWidth() )) && (!bOccupied))
      {
        if(m_aacGrid[i][j] != '\0')
        {
          bOccupied = true;
        }
        j++;
      }
      i++;
      j = s32TopLeftX_;
    }
    
    /* If at least one space was occupied, the QuadShapeCannot be added */
    if(!bOccupied)
    {
      return false;
    }
    
    /* Otherwise, change all corresponding spaces in m_aacGrid to the QuadShape name.  
    Debate if it's more efficient to do this on a copy of m_aacGrid in the search loop above... */
    i = s32TopLeftX_;
    j = s32TopLeftX_;
    
    while( i < (s32TopLeftX_ + InputQuadShape_.getHeight()))
    {
      while( j < (s32TopLeftX_ + InputQuadShape_.getWidth())) 
      {
        m_aacGrid[i][j] = InputQuadShape_.getLabel();
        j++;
      }
      i++;
      j = s32TopLeftX_;
    }
    
    /* Find an empty location in the tracking struct */
    i = 0;
    while(m_acEntryListNames[i] != '\0')
    {
      i++;
    }
    
    /* Update the entry tracking struct */
    m_as32EntryListWidths[i]  = InputQuadShape_.getWidth();
    m_as32EntryListHeights[i] = InputQuadShape_.getHeight();
    m_acEntryListNames[i]     = InputQuadShape_.getLabel();
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
      m_as32EntryListWidths and m_as32EntryListHeights are set to 0
    > m_s32TotalEntries decremented
    > m_aacGrid values corresponding to the Quadshape are set to '\0'
  @returns FALSE if the QuadShape was not in ShapeGrid; ShapeGrid and list entries unchanged

  */
  public boolean RemoveQuadShape(char s8Name_)
  {
    boolean bFoundEntry = false;
    int s32EntryListIndex = 0;
    int s32EntryWidth;
    int s32EntryHeight;
    
    int s32GridLocationWidth  = 0;
    int s32GridLocationHeight = 0;
    
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
    s32EntryWidth = m_as32EntryListWidths[s32EntryListIndex];
    s32EntryHeight = m_as32EntryListHeights[s32EntryListIndex];

    /* Remove the QuadShape from the grid starting by finding the first instance of s8Name_ */
    s32GridLocationWidth = 0;
    s32GridLocationHeight = 0;
    bFoundEntry = false;
    
    /* Loop through the whole grid until the first instance of s8Name_ is found which leaves
    s32GridLocationWidth and s32GridLocationHeight as the index of the QuadShape to remove in ShapeGrid */ 
    while( (s32GridLocationHeight < m_s32GridHeight) && (!bFoundEntry) )
    {
      while( (s32GridLocationWidth < m_s32GridWidth) && (!bFoundEntry) )
      {
        if(m_aacGrid[s32GridLocationHeight][s32GridLocationWidth] == s8Name_)
        {
          bFoundEntry = true;
        }
        else
        {
          s32GridLocationWidth++;
        }
      }
      
      /* Only increment indicies if the entry hasn't been found yet */
      if(!bFoundEntry)
      {
        s32GridLocationHeight++;
        s32GridLocationWidth = 0;
      }
    }    
    
    /* Now we know where in ShapeGrid the start of QuadShape is, and we have the size of the QuadShape
    from the entry list.  Loop through m_aacGrid and reset the values to '\0'. */
    int i = s32GridLocationHeight;
    int j = s32GridLocationWidth;
    
    while( i < (s32GridLocationHeight + m_as32EntryListHeights[s32EntryListIndex]) )
    {
      while( j < (s32GridLocationWidth + m_as32EntryListWidths[s32EntryListIndex]) ) 
      {
        m_aacGrid[i][j] = '\0';
        j++;
      }
      i++;
      j = s32GridLocationWidth;
    }    
        
    /* Remove the entry from the tracking struct */
    m_acEntryListNames[s32EntryListIndex]    = '\0';
    m_as32EntryListWidths[s32EntryListIndex]  = 0;
    m_as32EntryListHeights[s32EntryListIndex] = 0;
    m_s32TotalEntries--;
    
    return true;
    
  } /* end public boolean RemoveQuadShape(char s8Name_) */
  

  /*!************************************************************************************************
  @fn public void DrawShapeGrid(int s32TopLeftX_, int s32TopLeftX_, int s32BlockSize_) 
  @brief The ShapeGrid is printed with the top left corner specifed at TopLeftX, TopLeftY.
  
  Each ShapeGrid matrix entry is printed as a box of size s32BlockSize x s32BlockSize. 
  For empty locations in ShapeGrid, the printed box will appear as a white square with a black outline.  
  For locations in ShapeGrid where a QuadShape element is present, the box will be a purple square with 
  a black outline and white letter showing the name of the QuadShape.  If s32BlockSize is too small,
  the letter will not be printed.
  
  Requires
  @param s32TopLeftX_  Starting X coordinate of top left pixel of the ShapeGrid
  @param s32TopLeftX_  Starting Y coordinate of top left pixel of the ShapeGrid
  @param s32BlockSize Size of the edge of a box; boxes are always square and should be at least 10 pixels  
  
  Promises
  The full ShapeGrid is printed at the location specifed
  */
  public void DrawShapeGrid(int s32TopLeftX_, int s32TopLeftY_, int s32BlockSize_) 
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
