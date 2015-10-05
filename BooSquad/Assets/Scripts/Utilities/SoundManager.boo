import UnityEngine

class SoundManager (MonoBehaviour):

	public static instance as SoundManager
	
	def Awake():
		instance = self
		
	public static def PlaySound( source as AudioSource ) as AudioSource:
		newSource = Instantiate( source ) as AudioSource
		newSource.Play()
		return newSource