import UnityEngine
import System.Collections

public enum Direction:
	North
	South
	East
	West
	NorthEast
	NorthWest
	SouthEast
	SouthWest

public enum Team:
	One
	Two

class Piece (MonoBehaviour):
	_transform as Transform
	
	public team = Team.One
	public gridSpace as GridSpace

	[Header( "Movement" )]
	[SerializeField] protected _moveRange = 1
	protected _moveSpaces as List of GridSpace = List of GridSpace()

	[SerializeField] _moveTimeRange = MinMaxF( 0.4f, 1f )
	[SerializeField] _jumpHeightRange = MinMaxF( 1f, 3f )
	
	_maxMoveDistance = 13.57f
	[SerializeField] _squashAmount = 0.5f
	[SerializeField] _stretchAmount = 0.2f
	
	[SerializeField] _moveShakeStrength = 1f
	_moveRoutine as Coroutine
	
	[Header( "Stomp" )]
	[SerializeField] _killTimeAlpha = 0.95f
	[SerializeField] _smashShakeStrength = 10f
	
	[SerializeField] _sfxSource as AudioSource
	[SerializeField] _explodeClips as (AudioClip)
	[SerializeField] _landClip as AudioClip
	
	[SerializeField] _fallToDeathTime = 10f
	
	[SerializeField] _popCloud as ParticleSystem
	[SerializeField] _stompCloud as ParticleSystem
	_stompCloudKillEmitCount = 40
	
	[Header( "Rendering" )]
	protected _materials as (Material)
	protected _renderer as Renderer
	
	protected _teamBaseMaterialLocations = ("PieceMaterials/PinkBase", "PieceMaterials/BlueBase")
	
	[SerializeField] _teamSelectedRimColors as (Color)
	[SerializeField] _unselectedRimColor = Color.black

	protected virtual def Awake():
		_transform = GetComponent of Transform()
		_renderer = GetComponentInChildren of Renderer()
	
	public virtual def Initialize():
		_materials = _renderer.materials
		_materials[ 0 ] = Material.Instantiate( Resources.Load( _teamBaseMaterialLocations[ cast( int, team ) ] ) as Material )
		
	public def IsMoving() as bool:
		return _moveRoutine != null

	public def TryAndMoveToSpace( gridSpace as GridSpace ) as bool:
		if CanMoveToSpace( gridSpace ):
			MoveToSpace( gridSpace )
			return true
		else:
			return false

	def CanMoveToSpace( gridSpace as GridSpace ) as bool:
		return _moveRoutine == null and _moveSpaces.Contains( gridSpace ) and gridSpace.CanMoveTo()

	def MoveToSpace( newGridSpace as GridSpace ):
		if newGridSpace:
			_moveRoutine = StartCoroutine( MoveToSpaceRoutine( newGridSpace ) )

	def MoveToSpaceRoutine( newGridSpace as GridSpace ) as IEnumerator:

		HideMoveSpaces()
		
		startPos = gridSpace.transform.position
		endPos = newGridSpace.transform.position
		
		gridSpace.MoveFrom()
		if not newGridSpace.CanMoveTo():
			FallToDeath()

		startScale = Vector3.one
		moveDistance = Vector3.Distance( startPos, endPos )
		
		moveAlpha = moveDistance/_maxMoveDistance // Percent towards max travel distance
		moveTime = _moveTimeRange.Lerp( moveAlpha ) // How long should it take to move
		jumpHeight = _jumpHeightRange.Lerp( moveAlpha ) // How high should the piece jump
		
		hasKilledPiece = false
		hasActivatedTrap = false
		
		gridSpace.piece = null
		
		moveTimer = 0f
		while( moveTimer < moveTime ):
			moveTimer += Time.deltaTime
			alpha = Mathf.Clamp01( moveTimer/moveTime )
			
			startPos = gridSpace.transform.position
			endPos = newGridSpace.transform.position
			
			// Position
			newPos = Vector3.Lerp( startPos, endPos, alpha )
			newPos.y += Mathf.Sin( alpha * Mathf.PI ) * jumpHeight
			_transform.position = newPos
			
			// Scaling
			currentScale = startScale
			distanceMod = 1f - moveDistance/_maxMoveDistance			
			currentScale.y += Mathf.Sin( alpha * Mathf.PI ) * _stretchAmount * distanceMod
			currentScale.x -= Mathf.Sin( alpha * Mathf.PI ) * _squashAmount * distanceMod
			currentScale.z -= Mathf.Sin( alpha * Mathf.PI ) * _squashAmount * distanceMod

			_transform.localScale = currentScale
			
			yield null

		_transform.position = endPos
		_transform.localScale = Vector3.one

		if not hasKilledPiece and newGridSpace.piece:
			hasKilledPiece = true
			newGridSpace.piece.Kill() # TODO: Needs to be in coroutine
			newGridSpace.piece = null

		gridSpace = newGridSpace
		gridSpace.piece = self

		#ShowMoveSpaces()

		if not hasKilledPiece and newGridSpace.trap:
			hasActivatedTrap = true
			gridSpace.trap.Activate( self )
			gridSpace.trap = null

		if hasKilledPiece or hasActivatedTrap:
			CameraShake.ShakeScreen( _smashShakeStrength )
			_stompCloud.Emit( _stompCloudKillEmitCount )
			
			_sfxSource.clip = _explodeClips[ Random.Range( 0, _explodeClips.Length ) ]
			_sfxSource.Play()

			newGridSpace.SetToFall()
		else:
			CameraShake.ShakeScreen( _moveShakeStrength )
			_sfxSource.clip = _landClip
			_sfxSource.Play()

		_moveRoutine = null
	
	# Recursive function to select all grid spaces within a given range
	public virtual def IterateInDirection( startGridSpace as GridSpace, direction as Direction, iterCount as int ):
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
				if direction != Direction.South:
					IterateInDirection( gridSpaceIter, Direction.North, iterCount )
				if direction != Direction.West:
					IterateInDirection( gridSpaceIter, Direction.East, iterCount )
				if direction != Direction.North:
					IterateInDirection( gridSpaceIter, Direction.South, iterCount )
				if direction != Direction.East:
					IterateInDirection( gridSpaceIter, Direction.West, iterCount )
	
	protected virtual def ShowMoveSpaces():
		HideMoveSpaces()
		
		IterateInDirection( gridSpace, Direction.North, 0 )
		IterateInDirection( gridSpace, Direction.East, 0 )
		IterateInDirection( gridSpace, Direction.South, 0 )
		IterateInDirection( gridSpace, Direction.West, 0 )

	def HideMoveSpaces():
		for i in range( 0, _moveSpaces.Count ):
			_moveSpaces[ i ].SetHighlighted( false, team )
		
		_moveSpaces.Clear()

	public virtual def Select():
		_materials[0].SetColor( "_RimColor", _teamSelectedRimColors[ cast( int, team ) ] )
		_materials[1].SetColor( "_RimColor", _teamSelectedRimColors[ cast( int, team ) ] )
		ShowMoveSpaces()

	public virtual def Deselect():
		_materials[0].SetColor( "_RimColor", _unselectedRimColor )
		_materials[1].SetColor( "_RimColor", _unselectedRimColor )
		HideMoveSpaces()

	public def Explode():
		StartCoroutine( ExplodeRoutine() )
	
	def ExplodeRoutine() as IEnumerator:
		gridSpace.piece = null
		GetComponentInChildren of Renderer().enabled = false
		_popCloud.Play()
		_sfxSource.clip = _explodeClips[ Random.Range( 0, _explodeClips.Length ) ]
		_sfxSource.Play()
		yield WaitForSeconds( 1f )
		Kill()

	public virtual def Kill():
		Destroy( gameObject )
		
	public virtual def FallToDeath():
		if PieceSelector.instance.IsSelection( self ):
			PieceSelector.instance.Deselect()
		StartCoroutine( FallToDeathRoutine() )
		
	public def FallToDeathRoutine() as IEnumerator:
		GetComponent of Collider().enabled = false
		timer = 0f
		while timer < _fallToDeathTime:
			timer += Time.deltaTime
			if _moveRoutine == null:
				_transform.position = gridSpace.GetComponent of Transform().position
			yield null
		
		Kill()