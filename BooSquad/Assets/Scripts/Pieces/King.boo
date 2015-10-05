import UnityEngine

class King (Piece):

	_teamMaterialLocations = ( "PieceMaterials/PinkKing", "PieceMaterials/BlueKing" )

	protected override def Awake():
		super.Awake()
		
	public override def Initialize():
		super.Initialize()
		_materials[ 1 ] = Material.Instantiate( Resources.Load( _teamMaterialLocations[ cast( int, team ) ] ) as Material )
		_renderer.materials = _materials
		
	public override def FallToDeath():
		super.FallToDeath()
		GameManager.MatchLost( team )
		
	public override def Kill():
		GameManager.MatchLost( team )
		super.Kill()