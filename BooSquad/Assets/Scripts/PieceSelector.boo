import UnityEngine

class PieceSelector (MonoBehaviour):

	public static instance as PieceSelector
	
	_transform as Transform
	_selectedPiece as Piece

	_currentTeam as Team

	[SerializeField] _checkLayer as LayerMask
	
	[SerializeField] _failSelectAudio as AudioSource
	[SerializeField] _selectAudio as AudioSource
	[SerializeField] _deselectAudio as AudioSource
	
	[SerializeField] _pivotTransform as Transform
	[SerializeField] _rotateTime = 1f
	[SerializeField] _rotateAmount = 90
	
	_rotateRoutine as Coroutine

	def Awake():
		instance = self
		_currentTeam = Team.One
		_transform = GetComponent of Transform()

	def Update():
		if Input.GetMouseButtonDown( 0 ):
			hit as RaycastHit
			
			Physics.Raycast( Camera.main.ScreenPointToRay( Input.mousePosition ), hit, Mathf.Infinity, _checkLayer )
			if hit.transform:
				hitPiece = hit.transform.GetComponent of Piece()
				if _selectedPiece:
					if hitPiece:
						if hitPiece != _selectedPiece:
							if _selectedPiece.TryAndMoveToSpace( hitPiece.gridSpace ):
								EndTurn()
							else:
								_failSelectAudio.Play()
						elif not _selectedPiece.IsMoving():
							Deselect()
					else:
						hitGridSpace = hit.transform.GetComponent of GridSpace()
						if hitGridSpace and hitGridSpace != _selectedPiece.gridSpace:
							if _selectedPiece.TryAndMoveToSpace( hitGridSpace ):
								EndTurn()
							else:
								_failSelectAudio.Play()
								
						else:
							Deselect()
				elif hitPiece:
					if hitPiece.team == _currentTeam:
						Select( hitPiece )
					else:
						_failSelectAudio.Play()
			elif _rotateRoutine == null and _selectedPiece:
				Deselect()

	public def IsSelection( piece as Piece ) as bool:
		return piece == _selectedPiece
	
	public def Select( piece as Piece ):
		_selectAudio.Play()
		piece.Select()
		_selectedPiece = piece
	
	public def Deselect():
		_deselectAudio.Play()
		_selectedPiece.Deselect()
		_selectedPiece = null
	
	def EndTurn():
		if _currentTeam == Team.One:
			_currentTeam = Team.Two
		else:
			_currentTeam = Team.One
			
		Deselect()
	
	public def Rotate( left as bool ):
		if _rotateRoutine == null:
			_rotateRoutine = StartCoroutine( RotateRoutine( left ) )

	def RotateRoutine( left as bool ) as IEnumerator:
		startRotation = _pivotTransform.rotation
		endRotation = startRotation
		if left:
			endRotation *= Quaternion.Euler( 0f, _rotateAmount, 0f )
		else:
			endRotation *= Quaternion.Euler( 0f, -_rotateAmount, 0f )

		rotateTimer = 0f
		while rotateTimer < _rotateTime:
			rotateTimer += Time.deltaTime
			_pivotTransform.rotation = Quaternion.Lerp( startRotation, endRotation, Mathf.Clamp01( rotateTimer/_rotateTime ) )
			yield null

		_rotateRoutine = null