import UnityEngine
import UnityEngine.UI

class GameManager (MonoBehaviour):

	public static instance as GameManager
	
	[SerializeField] _gameOverText as Text
	[SerializeField] _winningVerbs as (string)
	
	[SerializeField] _winTextBaseColors as (Color)
	[SerializeField] _winTextShadowColors as (Color)

	_matchOverRoutine as Coroutine
	_gameOver = false

	def Awake ():
		instance = self

	def Update():
		if _gameOver and ( Input.anyKey or Input.touchCount > 0 or Input.GetMouseButtonDown( 0 ) ):
			Application.LoadLevel( "TitleScene" )

	public static def MatchLost( losingTeam as Team ):
		if not instance._gameOver and not instance._matchOverRoutine:
			instance._matchOverRoutine = instance.StartCoroutine( instance.MatchLostRoutine( losingTeam ) )
		
	def MatchLostRoutine( losingTeam as Team ) as IEnumerator:
		winningTeam = ( Team.One if losingTeam == Team.Two else Team.Two )
		verbNumber = Random.Range( 0, _winningVerbs.Length )
		writeText = "Team " + winningTeam.ToString() + " " + _winningVerbs[ verbNumber ]
		_gameOverText.text = writeText
		_gameOverText.color = _winTextShadowColors[ cast( int, winningTeam ) ]
		
		childText = _gameOverText.transform.GetChild( 0 ).GetComponent of Text()
		childText.text = writeText
		childText.color = _winTextBaseColors[ cast( int, winningTeam ) ]
		
		_gameOverText.GetComponent of Animator().Play( "SlideIn" )
		
		yield WaitForSeconds( 1.5f )
		
		_gameOver = true
		_matchOverRoutine = null