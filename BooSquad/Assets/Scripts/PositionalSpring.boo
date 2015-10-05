import UnityEngine

class PositionalSpring (MonoBehaviour):

	[SerializeField] _anchorPoint = Vector3.zero
	[SerializeField] _springConstant = 1.0f

	_transform as Transform
	_rigidbody as Rigidbody

	def Awake():
		_transform = GetComponent of Transform()
		_rigidbody = GetComponent of Rigidbody()

	def FixedUpdate():
		offset = _anchorPoint - _transform.localPosition
		_rigidbody.AddForce( offset * _springConstant )