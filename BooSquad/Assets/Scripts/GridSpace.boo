import UnityEngine

class GridSpace (MonoBehaviour):
	
	public piece as Piece
	public trap as Trap
	
	public north as GridSpace
	public south as GridSpace
	public east as GridSpace
	public west as GridSpace
	
	_material as Material
	
	_currentTeam as Team
	[SerializeField] _teamHighlightColors as (Color)
	_defaultRimColor = Color.white
	
	[SerializeField] _hitWaveTime = 1f
	[SerializeField] _hitWaveHeight = 2f
	
	[SerializeField] _scaleNoiseOffset = 5f
	[SerializeField] _scaleWaveSpeed = 1f
	
	_hasFallen = false
	_shouldFall = false
	_isHighlighted = false
	public isWaving = false
	
	_transform as Transform
	_rigidbody as Rigidbody
	
	def Awake():
		_transform = GetComponent of Transform()
		_rigidbody = GetComponent of Rigidbody()
		_material = GetComponent of Renderer().material
	
	def FixedUpdate():
		newScale = _transform.localScale
		noiseOffset = Mathf.PerlinNoise( _transform.position.x, _transform.position.z )
		newScale.x = newScale.z = ( Mathf.Sin( ( Time.timeSinceLevelLoad * _scaleWaveSpeed + noiseOffset * _scaleNoiseOffset ) * Mathf.PI ) * 0.08f + 1f )
		_transform.localScale = newScale
	
	public def GetNeighbor( direction as Direction ) as GridSpace:
		if direction == Direction.North:
			return north
		elif direction == Direction.South:
			return south
		elif direction == Direction.East:
			return east
		elif direction == Direction.West:
			return west
	
	public def SetHighlighted( setHighlighted as bool, team as Team ):
		_isHighlighted = setHighlighted
		_currentTeam = team
		_material.SetColor( "_Color", ( _teamHighlightColors[ cast( int, team ) ] if setHighlighted else _defaultRimColor ) )
	
	public def SetToFall():
		_shouldFall = true
	
	public def CanMoveTo() as bool:
		return not _hasFallen
	
	public def CheckIfNeighborShouldFall( gridSpace as GridSpace, direction as Direction ):
		neighborGridSpace = gridSpace.GetNeighbor( direction )
		if neighborGridSpace:
			if direction == Direction.North:
				neighborGridSpace.south = null
			elif direction == Direction.South:
				neighborGridSpace.north = null
			elif direction == Direction.East:
				neighborGridSpace.west = null
			elif direction == Direction.West:
				neighborGridSpace.east = null
			
			if not neighborGridSpace.north and not neighborGridSpace.east and not neighborGridSpace.south and not neighborGridSpace.west:
				neighborGridSpace.ForceFall()
	
	public def MoveFrom():
		if _shouldFall:
			_hasFallen = true
			_rigidbody.isKinematic = false
			CheckIfNeighborShouldFall( self, Direction.North )
			CheckIfNeighborShouldFall( self, Direction.East )
			CheckIfNeighborShouldFall( self, Direction.South )
			CheckIfNeighborShouldFall( self, Direction.West )
			gameObject.layer = LayerMask.NameToLayer( "Falling" )
			
	public def ForceFall():
		if piece:
			piece.FallToDeath()
		_hasFallen = true
		_rigidbody.isKinematic = false
		CheckIfNeighborShouldFall( self, Direction.North )
		CheckIfNeighborShouldFall( self, Direction.East )
		CheckIfNeighborShouldFall( self, Direction.South )
		CheckIfNeighborShouldFall( self, Direction.West )
		gameObject.layer = LayerMask.NameToLayer( "Falling" )
		
	public def Wave( waveStartPiece as Piece ):
		StartCoroutine( WaveRoutine( waveStartPiece ) )
	
	public def WaveRoutine( waveStartPiece as Piece ) as IEnumerator:
		isWaving = true
		wasHighlighted = _isHighlighted
		SetHighlighted( false, _currentTeam )
		pieceStartGridPos = waveStartPiece.gridSpace
		
		startPos = _transform.position
		waveTimer = 0f
		while waveTimer < _hitWaveTime:
			waveTimer += Time.deltaTime
			_transform.position = startPos + Vector3.up * Mathf.Sin( Mathf.Clamp01( waveTimer/_hitWaveTime ) * Mathf.PI ) * _hitWaveHeight
			if piece:
				piece.GetComponent of Transform().position = _transform.position
				if waveTimer > _hitWaveTime/2f:
					piece.Explode()
			yield null

		isWaving = false
		if waveStartPiece.gridSpace == pieceStartGridPos and not waveStartPiece.IsMoving():
			SetHighlighted( wasHighlighted, _currentTeam )
		_transform.position = startPos