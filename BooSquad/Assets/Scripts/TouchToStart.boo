import UnityEngine

class TouchToStart (MonoBehaviour):

	def Update():
		if Input.GetMouseButtonDown( 0 ):
			Application.LoadLevel( "GameScene" )