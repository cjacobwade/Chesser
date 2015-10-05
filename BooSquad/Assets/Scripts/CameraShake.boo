import UnityEngine

class CameraShake (MonoBehaviour):

	public static instance as CameraShake

	public _defaultShakeStrength = 6f
	[SerializeField] _returnToCenterTime = 3f
	
	[HideInInspector] public _transform as Transform
	[HideInInspector] public _rigidbody as Rigidbody

	def Awake ():
		instance = self
		_transform = GetComponent of Transform()
		_rigidbody = GetComponent of Rigidbody()

	def FixedUpdate():
		if Input.GetButtonDown( "Jump" ):
			ShakeScreen()
		
		_transform.localPosition = Vector3.Lerp( _transform.localPosition, Vector3.zero, Time.deltaTime * _returnToCenterTime )

	public static def ShakeScreen():
		instance._rigidbody.velocity += instance._transform.TransformDirection( Random.insideUnitCircle * instance._defaultShakeStrength )

	public static def ShakeScreen( strength as single ):
		instance._rigidbody.velocity += instance._transform.TransformDirection( Random.insideUnitCircle * strength )

	public static def ShakeScreen( direction as Vector2 ):
		instance._rigidbody.velocity += instance._transform.TransformDirection( direction * instance._defaultShakeStrength )

	public static def ShakeScreen( direction as Vector2, strength as single ):
		instance._rigidbody.velocity += instance._transform.TransformDirection( direction * strength )