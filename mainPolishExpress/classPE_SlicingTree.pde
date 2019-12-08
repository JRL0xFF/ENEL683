/* 
POLISH EXPRESSion TreeNode Class

A TreeNode is an element of a Slicing tree built for the Polish Expression game. Each node represents
a segment of the tree (either a cut or the number of a basic rectangle of a floorplan).  If the node is
a cut, then it will have data about its children.  If the node is a leaf, it will have data about the
size of the element at that location (width and height).

It holds the following data:
int s32NodeType:
  > -1 for vertical cut
  > -2 for horizontal cut
  > 0 undefined
  > 1...2B for the node number
  > -3 error

int s32LeafWidth: 
  > child: the horizontal size of the leaf
  > parent: 0
  > -3 error
  
int s32LeafHeight: 
  > child: the vertical size of the leaf
  > parent: 0
  > -3 error
  
int s32ChildRight:
  > child: -1 (no connection)
  > parent: index of the TreeNode on the right branch
  > -3 error
  
int s32ChildLeft:
  > child: -1 (no connection)
  > parent: index of the TreeNode on the left branch
  > -3 error
*/

class PE_TreeNode
{
  private int m_s32NodeType;
  private int m_s32LeafWidth;
  private int m_s32LeafHeight;
  private int m_s32ChildRight;
  private int m_s32ChildLeft;

  /* Default constructor: create an empty node - this should not be used */
  public PE_TreeNode() 
  {
    m_s32NodeType   = 0;
    m_s32LeafWidth  = 0;
    m_s32LeafHeight = 0;
    m_s32ChildRight = -1;
    m_s32ChildLeft  = -1;
  } /* end public PE_TreeNode() default constructor */

  /* Constructor: create a valid PE_TreeNode */
  public PE_TreeNode(int s32NodeType_, int s32LeafWidth_,int s32LeafHeight_, 
                     int s32ChildRight_, int s32ChildLeft_) 
  {
    m_s32NodeType   = s32NodeType_;
    m_s32LeafWidth  = s32LeafWidth_;
    m_s32LeafHeight = s32LeafHeight_;
    m_s32ChildRight = s32ChildRight_;
    m_s32ChildLeft  = s32ChildLeft_;
  } /* end public PE_TreeNode() constructor */

  /* Copy Constructor */
  public PE_TreeNode(PE_TreeNode Source_) 
  {
    this.m_s32NodeType   = Source_.m_s32NodeType;
    this.m_s32LeafWidth  = Source_.m_s32LeafWidth;
    this.m_s32LeafHeight = Source_.m_s32LeafHeight;
    this.m_s32ChildRight = Source_.m_s32ChildRight;
    this.m_s32ChildLeft  = Source_.m_s32ChildLeft;
  } /* end PE_TreeNode copy constructor */


  /* Get and set member access */
  public int getNodeType() 
  {
    return m_s32NodeType;
    
  } /* end getNodeType() */ 

  public void setNodeType(int s32NodeType_) 
  {
    /* Should ASSERT and range check the input */
    m_s32NodeType = s32NodeType_;
    
  } /* end setNodeType() */ 


  public int getLeafWidth() 
  {
     return m_s32LeafWidth;

  } /* end getLeafWidth() */ 

  public void setLeafWidth(int s32LeafWidth_) 
  {
    /* Should ASSERT and range check the input */
    m_s32LeafWidth = s32LeafWidth_;
    
  } /* end setLeafWidth() */ 


  public int getLeafHeight() 
  {
    return m_s32LeafHeight;

  } /* end getLeafHeight() */ 

  public void setLeafHeight(int s32LeafHeight_) 
  {
    /* Should ASSERT and range check the input */
    m_s32LeafHeight = s32LeafHeight_;
    
  } /* end setLeafHeight() */ 


  public int getChildRight() 
  {
    return m_s32ChildRight;
    
  } /* end getNodeChildRight() */ 

  public void setChildRight(int s32ChildRight_) 
  {
    /* Should ASSERT and range check the input */
    m_s32ChildRight = s32ChildRight_;
    
  } /* end setChildRight() */ 


  public int getChildLeft() 
  {
    return m_s32ChildLeft;

  } /* end getNodeChildLeft() */ 

  public void setChildLeft(int s32ChildLeft_) 
  {
    /* Should ASSERT and range check the input */
    m_s32ChildLeft = s32ChildLeft_;
    
  } /* end setChildLeft() */ 

} /* end class PE_TreeNode */



/* 
POLISH EXPRESSion SlicingTree Class

A Slicing Tree is the main game structure in the Polish Expression that is used to translate PEs to 
ShapeGrids.  The tree is built from PE_TreeNodes using information provided in a standard set of 
arrays which hold all of the node information. These arrays can be hard-coded or generated and input
in a standard form.  

The parent-child links are based on array indexes rather than pointers/references for easier 
visualization in the debugger.

The format of the input arrays is as follows:

int as32NodeType[]: see PE_TreeNode for allowed values
int as32LeafWidth[]: horizontal height of a leaf node (if applicable, otherwise 0);
int as32LeafHeight[]:
int as32ChildRight[]: see PE_TreeNode for allowed values
int as32ChildLeft[]: see PE_TreeNode for allowed values
*/

class PE_SlicingTree
{
  private PE_TreeNode[] m_aTreeNodes;
  private int m_s32TreeSize;

  /* Default constructor: create an empty tree of size 1 */
  public PE_SlicingTree() 
  {
    m_aTreeNodes  = new PE_TreeNode[1];
    m_s32TreeSize = 1;
    
    m_aTreeNodes[0].setNodeType(0);
    m_aTreeNodes[0].setLeafWidth(0);
    m_aTreeNodes[0].setLeafHeight(0);
    m_aTreeNodes[0].setChildRight(-1);
    m_aTreeNodes[0].setChildLeft(-1);    

  } /* end public PE_SlicingTree() default constructor */

  /* Constructor: create a new empty PE_SlicingTree of the required size */
  public PE_SlicingTree(int s32TreeSize_) 
  {
    /* Create and initialize all the nodes to the empty state */
    m_aTreeNodes  = new PE_TreeNode[s32TreeSize_];
    m_s32TreeSize = s32TreeSize_;

    for(int i = 0; i < s32TreeSize_; i++)
    {
      m_aTreeNodes[i].setNodeType(0);
      m_aTreeNodes[i].setLeafWidth(0);
      m_aTreeNodes[i].setLeafHeight(0);
      m_aTreeNodes[i].setChildRight(-1);
      m_aTreeNodes[i].setChildLeft(-1);    
    }
    
  } /* end public PE_SlicingTree() constructor */

  /* Copy Constructor */
  public PE_SlicingTree(PE_SlicingTree Source_) 
  {
    /* Create and initialize all the nodes to the empty state */
    this.m_aTreeNodes  = new PE_TreeNode[Source_.getTreeSize()];
    this.m_s32TreeSize = Source_.getTreeSize();

    for(int i = 0; i < this.m_s32TreeSize; i++)
    {
      this.m_aTreeNodes[i].setNodeType(Source_.getNodeType(i) );
      this.m_aTreeNodes[i].setLeafWidth(Source_.getNodeLeafWidth(i) );
      this.m_aTreeNodes[i].setLeafHeight(Source_.getNodeLeafHeight(i) );
      this.m_aTreeNodes[i].setChildRight(Source_.getNodeChildRight(i) );
      this.m_aTreeNodes[i].setChildLeft(Source_.getNodeChildLeft(i) );    
    }
       
  } /* end PE_SlicingTree copy constructor */


  /* Member variable access functions */
  public int getTreeSize() 
  {
    return m_s32TreeSize;
  } /* end getTreeSize() */ 

  
  public int getNodeType(int s32NodeIndex_) 
  {
    if(s32NodeIndex_ < m_s32TreeSize)
    {
      return m_aTreeNodes[s32NodeIndex_].getNodeType();
    }
    else
    {
      return -3;
    }
  } /* end getNodeType() */ 


  public int getNodeLeafWidth(int s32NodeIndex_) 
  {
    if(s32NodeIndex_ < m_s32TreeSize)
    {
      return m_aTreeNodes[s32NodeIndex_].getLeafWidth();
    }
    else
    {
      return -3;
    }
  } /* end getNodeLeafWidth() */ 


  public int getNodeLeafHeight(int s32NodeIndex_) 
  {
    if(s32NodeIndex_ < m_s32TreeSize)
    {
      return m_aTreeNodes[s32NodeIndex_].getLeafHeight();
    }
    else
    {
      return -3;
    }
  } /* end getNodeLeafHeight() */ 


  public int getNodeChildRight(int s32NodeIndex_) 
  {
    if(s32NodeIndex_ < m_s32TreeSize)
    {
      return m_aTreeNodes[s32NodeIndex_].getChildRight();
    }
    else
    {
      return -3;
    }
  } /* end getNodeChildRight() */ 


  public int getNodeChildLeft(int s32NodeIndex_) 
  {
    if(s32NodeIndex_ < m_s32TreeSize)
    {
      return m_aTreeNodes[s32NodeIndex_].getChildLeft();
    }
    else
    {
      return -3;
    }
  } /* end getNodeChildLeft() */ 

} /* end class PE_SlicingTree */



/* 
POLISH EXPRESSion Seed Data

*/

/* Easy level floor plans are 5 x 4 in size.  They could have up to 20 elements if all were 1x1. */

  PE_GameData[] m_aTreeNodes;
  private int m_s32TreeSize;


    m_aTreeNodes  = new PE_TreeNode[1];
