import UnityEngine

static class WadeUtils (MonoBehaviour):

	def Start ():
		pass

	def Update ():
		pass

[System.Serializable]
public struct MinMaxF:
	min as single
	max as single
	
	def constructor( inMin as single, inMax as single ):
		min = inMin
		max = inMax
	
	def Lerp( alpha as single ) as single:
		return Mathf.Lerp( min, max, alpha )
		
	def UnclampedLerp( alpha as single ) as single:
		return min + ( max - min ) * alpha
		
	def Random() as single:
		return UnityEngine.Random.Range( min, max )