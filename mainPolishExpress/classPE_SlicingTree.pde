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
  > 1...2B for the node number

int s32Width: 
  > child: the horizontal size of the leaf
  > parent: 0
  
int s32Height: 
  > child: the vertical size of the leaf
  > parent: 0
  
int s32Right:
  > child: -1 (no connection)
  > parent: index of the TreeNode on the right branch
  
int s32Left:
  > child: -1 (no connection)
  > parent: index of the TreeNode on the left branch
   

API
public boolean AddQuadShape(PE_QuadShape InputQuadShape_, int s32TopLeftX_, int s32TopLeftY_)
public boolean RemoveQuadShape(char s8Name_)
public void DrawShapeGrid(int s32TopLeftX_, int s32TopLeftX_, int s32BlockSize_) 
*/
