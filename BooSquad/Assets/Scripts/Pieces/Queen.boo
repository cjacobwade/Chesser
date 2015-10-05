import UnityEngine

class Queen (Piece):

	_teamMaterialLocations = ( "PieceMaterials/PinkQueen", "PieceMaterials/BlueQueen" )

	protected override def Awake():
		super.Awake()
		
	public override def Initialize():
		super.Initialize()
		_materials[ 1 ] = Material.Instantiate( Resources.Load( _teamMaterialLocations[ cast( int, team ) ] ) as Material )
		_renderer.materials = _materials

#	# Recursive function to select all grid spaces within a given range
#	public virtual def IterateInDirection( startGridSpace as GridSpace, direction as Direction, iterCount as int ):
#		if direction == Direction.North:
#			gridSpaceIter = startGridSpace.north
#		elif direction == Direction.East:
#			gridSpaceIter = startGridSpace.east
#		elif direction == Direction.South:
#			gridSpaceIter = startGridSpace.south
#		elif direction == Direction.West:
#			gridSpaceIter = startGridSpace.west
#		elif direction == Direction.NorthEast:
#			gridSpaceIter = startGridSpace.north
#			if gridSpaceIter:
#				gridSpaceIter = gridSpaceIter.east
#			else:
#				return
#		elif direction == Direction.NorthWest:
#			gridSpaceIter = startGridSpace.north
#			if gridSpaceIter:
#				gridSpaceIter = gridSpaceIter.west
#			else:
#				return
#		elif direction == Direction.SouthEast:
#			gridSpaceIter = startGridSpace.south
#			if gridSpaceIter:
#				gridSpaceIter = gridSpaceIter.east
#			else:
#				return
#		elif direction == Direction.SouthWest:
#			gridSpaceIter = startGridSpace.south
#			if gridSpaceIter:
#				gridSpaceIter = gridSpaceIter.west
#			else:
#				return
#			
#		if iterCount < _moveRange and gridSpaceIter and gridSpaceIter != gridSpace and gridSpaceIter.CanMoveTo():
#			if not _moveSpaces.Contains( gridSpaceIter ):
#				gridSpaceIter.SetHighlighted( true )
#				_moveSpaces.Add( gridSpaceIter )
#			if not gridSpaceIter.piece:
#				iterCount++
#				IterateInDirection( gridSpaceIter, direction, iterCount )
#
#	protected virtual def ShowMoveSpaces():
#		HideMoveSpaces()
#		
#		IterateInDirection( gridSpace, Direction.North, 0 )
#		IterateInDirection( gridSpace, Direction.East, 0 )
#		IterateInDirection( gridSpace, Direction.South, 0 )
#		IterateInDirection( gridSpace, Direction.West, 0 )
#		IterateInDirection( gridSpace, Direction.NorthWest, 0 )
#		IterateInDirection( gridSpace, Direction.NorthEast, 0 )
#		IterateInDirection( gridSpace, Direction.SouthEast, 0 )
#		IterateInDirection( gridSpace, Direction.SouthWest, 0 )