import UnityEngine

class Pawn (Piece):

	_teamMaterialLocations = ("PieceMaterials/PinkPawn", "PieceMaterials/BluePawn")

	protected override def Awake():
		super.Awake()
	
	public override def Initialize():
		super.Initialize()
		_materials[ 1 ] = Material.Instantiate( Resources.Load( _teamMaterialLocations[ cast( int, team ) ] ) as Material )
		_renderer.materials = _materials

	# Recursive function to select all grid spaces within a given range
	public override def IterateInDirection( startGridSpace as GridSpace, direction as Direction, iterCount as int ):
		if direction == Direction.North:
			gridSpaceIter = startGridSpace.north
		elif direction == Direction.East:
			gridSpaceIter = startGridSpace.east
		elif direction == Direction.South:
			gridSpaceIter = startGridSpace.south
		elif direction == Direction.West:
			gridSpaceIter = startGridSpace.west
			
		if iterCount < _moveRange and gridSpaceIter and gridSpaceIter != gridSpace and gridSpaceIter.CanMoveTo() and not gridSpaceIter.isWaving:
			if not _moveSpaces.Contains( gridSpaceIter ):
				if not gridSpaceIter.piece:
					gridSpaceIter.SetHighlighted( true, team )
					_moveSpaces.Add( gridSpaceIter )
				elif not gridSpaceIter.piece.GetComponent of King() or gridSpaceIter.piece.team != team:
					gridSpaceIter.SetHighlighted( true, team )
					_moveSpaces.Add( gridSpaceIter )
				else:
					return
			if not gridSpaceIter.piece:
				iterCount++
				IterateInDirection( gridSpaceIter, direction, iterCount )
	
	protected override def ShowMoveSpaces():
		HideMoveSpaces()
		
		IterateInDirection( gridSpace, Direction.North, 0 )
		IterateInDirection( gridSpace, Direction.East, 0 )
		IterateInDirection( gridSpace, Direction.South, 0 )
		IterateInDirection( gridSpace, Direction.West, 0 )