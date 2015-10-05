
import UnityEngine
import System.Collections.Generic

class GridGenerator (MonoBehaviour): 
	
	_transform as Transform
	_entityHolder as Transform
	_gridSpaceHolder as Transform
	
	[SerializeField] _gridSpacePrefab as GameObject
	
	[SerializeField] _kingPrefab as GameObject
	[SerializeField] _queenPrefab as GameObject
	[SerializeField] _pawnPrefab as GameObject
	
	[SerializeField] _arrowTrapPrefab as GameObject
	
	_spacing = 1.2f
	
	[SerializeField] _width = 9
	[SerializeField] _depth = 9
	
	_gridSpaces as List of GridSpace = List of GridSpace()
	
	def Awake():
		_transform = GetComponent of Transform()
		
		_entityHolder = GameObject( "Entities" ).GetComponent of Transform()
		_entityHolder.parent = _transform
		
		_gridSpaceHolder = GameObject( "GridSpaces" ).GetComponent of Transform()
		_gridSpaceHolder.parent = _transform
		
		for x in range( 0, _width ):
			for y in range( 0, _depth ):
				spawnPos = Vector3( x * _spacing, 0f, y * _spacing )
				newGridSpace = SpawnGridSpace( spawnPos )
					
				if y == 0:
					if x == 2:
						SpawnKing( spawnPos, newGridSpace, Team.Two )
					elif x == 3:
						SpawnQueen( spawnPos, newGridSpace, Team.Two )
					else:
						SpawnPawn( spawnPos, newGridSpace, Team.Two )
				if y == _depth - 1:
					if x == 3:
						king = SpawnKing( spawnPos, newGridSpace, Team.One )
						king.GetComponent of Transform().rotation *= Quaternion.Euler( 0f, 180f, 0f )
					elif x == 2:
						queen = SpawnQueen( spawnPos, newGridSpace, Team.One )
						queen.GetComponent of Transform().rotation *= Quaternion.Euler( 0f, 180f, 0f )
					else:
						pawn =  SpawnPawn( spawnPos, newGridSpace, Team.One )
						pawn.GetComponent of Transform().rotation *= Quaternion.Euler( 0f, 180f, 0f )
				if y == 2 and x == 2:
					trapTransform = SpawnArrowTrap( spawnPos, newGridSpace, AxisDirection.Vertical ).GetComponent of Transform()
					trapTransform.parent = newGridSpace.GetComponent of Transform()
				elif y == 3 and x == 3:
					trapTransform = SpawnArrowTrap( spawnPos, newGridSpace, AxisDirection.Vertical ).GetComponent of Transform()
					trapTransform.parent = newGridSpace.GetComponent of Transform()

	def SpawnGridSpace( spawnPos as Vector3 ) as GridSpace:
		newGridSpaceObj = Instantiate( _gridSpacePrefab, spawnPos, Quaternion.identity ) as GameObject
		newGridSpaceObj.GetComponent of Transform().parent = _gridSpaceHolder
		newGridSpace = newGridSpaceObj.GetComponent of GridSpace()
		_gridSpaces.Add( newGridSpace )
		
		if _gridSpaces.Count > 1 and (_gridSpaces.Count - 1) % _width != 0:
			newGridSpace.west = _gridSpaces[ _gridSpaces.Count - 2 ] # Assign left grid space
			newGridSpace.west.east = newGridSpace # Assign this to right of left grid space
		
		if _gridSpaces.Count > _width:
			newGridSpace.north = _gridSpaces[ _gridSpaces.Count - _width - 1 ] # Assign upper grid space
			newGridSpace.north.south = newGridSpace # Assign this to left of right grid space
			
		return newGridSpace

	def SpawnArrowTrap( spawnPos as Vector3, newGridSpace as GridSpace, axisDirection as AxisDirection ) as ArrowTrap:
		arrowTrapTransform = Instantiate( _arrowTrapPrefab, spawnPos, Quaternion.identity ).GetComponent of Transform()
		arrowTrapTransform.parent = _entityHolder		
		if axisDirection == axisDirection.Vertical:
			arrowTrapTransform.rotation *= Quaternion.Euler( 0f, 90f, 0f )
		
		arrowTrap = arrowTrapTransform.GetComponent of ArrowTrap()
		
		newGridSpace.trap = arrowTrap
		arrowTrap.gridSpace = newGridSpace
		arrowTrap.axisDirection = axisDirection
		
		return arrowTrap

	def SpawnKing( spawnPos as Vector3, newGridSpace as GridSpace, team as Team ) as King:
		kingObj = Instantiate( _kingPrefab, spawnPos, Quaternion.identity ) as GameObject
		kingObj.GetComponent of Transform().parent = _entityHolder
		king = kingObj.GetComponent of King()
		
		newGridSpace.piece = king
		king.gridSpace = newGridSpace
		
		king.team = team
		king.Initialize()
		return king

	def SpawnQueen( spawnPos as Vector3, newGridSpace as GridSpace, team as Team ) as Queen:
		queenObj = Instantiate( _queenPrefab, spawnPos, Quaternion.identity ) as GameObject
		queenObj.GetComponent of Transform().parent = _entityHolder
		queen = queenObj.GetComponent of Queen()
		
		newGridSpace.piece = queen
		queen.gridSpace = newGridSpace
		
		queen.team = team
		queen.Initialize()
		return queen
		
	def SpawnPawn( spawnPos as Vector3, newGridSpace as GridSpace, team as Team ) as Pawn:
		pawnObj = Instantiate( _pawnPrefab, spawnPos, Quaternion.identity ) as GameObject
		pawnObj.GetComponent of Transform().parent = _entityHolder
		pawn = pawnObj.GetComponent of Pawn()
		
		newGridSpace.piece = pawn
		pawn.gridSpace = newGridSpace
		
		pawn.team = team
		pawn.Initialize()
		return pawn