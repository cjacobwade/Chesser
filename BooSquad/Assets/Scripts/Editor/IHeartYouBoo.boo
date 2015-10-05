
import UnityEngine
import UnityEditor
import System.Reflection

class IHeartYouBoo (MonoBehaviour):
	[MenuItem("Assets/Create/Boo Script")]
	public static def CreateBooScript():
		method = typeof( ProjectWindowUtil ).GetMethod ('CreateScriptAsset', BindingFlags.Static | BindingFlags.NonPublic )
		method.Invoke ( null, ( of object: 'Assets/Scripts/Editor/NewBehaviourScript.boo.txt', 'NewBehaviourScript.boo' ) )
