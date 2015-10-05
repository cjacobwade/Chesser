import UnityEngine

public enum AxisDirection:
	Vertical
	Horizontal

class ArrowTrap (Trap):

	public axisDirection as AxisDirection
	[SerializeField] _iterateTime = 0.2f

	public override def Activate( piece as Piece ):
		if axisDirection == AxisDirection.Vertical:
			StartCoroutine( CheckVerticalRoutine( piece ) )
		elif axisDirection == AxisDirection.Horizontal:
			StartCoroutine( CheckHorizontalRoutine( piece ) )
		
		super.Activate( piece )
	
	def CheckVerticalRoutine( piece as Piece ) as IEnumerator:
		northGridSpaceIter = gridSpace
		southGridSpaceIter = gridSpace
		GetComponent of Renderer().enabled = false
		while northGridSpaceIter or southGridSpaceIter:
			if northGridSpaceIter:
				northGridSpaceIter = northGridSpaceIter.north
				if northGridSpaceIter:
					northGridSpaceIter.Wave( piece )
			
			if southGridSpaceIter:
				southGridSpaceIter = southGridSpaceIter.south
				if southGridSpaceIter:
					southGridSpaceIter.Wave( piece )
				
			yield WaitForSeconds( _iterateTime )
		Destroy( gameObject )
	
	def CheckHorizontalRoutine( piece as Piece ) as IEnumerator:
		eastGridSpaceIter = gridSpace
		westGridSpaceIter = gridSpace
		GetComponent of Renderer().enabled = false
		while eastGridSpaceIter or westGridSpaceIter:
			if eastGridSpaceIter:
				eastGridSpaceIter = eastGridSpaceIter.east
				if eastGridSpaceIter:
					eastGridSpaceIter.Wave( piece )
			
			if westGridSpaceIter:	
				westGridSpaceIter = westGridSpaceIter.west
				if westGridSpaceIter:
					westGridSpaceIter.Wave( piece )
				
			yield WaitForSeconds( _iterateTime )
		Destroy( gameObject )
		