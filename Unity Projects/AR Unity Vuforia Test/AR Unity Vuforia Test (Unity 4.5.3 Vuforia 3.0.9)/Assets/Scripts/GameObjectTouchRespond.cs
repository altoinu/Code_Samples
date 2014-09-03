using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

/**
 * Object touch handler to integrate with native Android/iOS code
 */ 
public class GameObjectTouchRespond : MonoBehaviour {

	[DllImport("__Internal")]
	private static extern void objectTouched(string message, int message2);

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
	
	void onMouseUp() {
		
		//this.transform;
		object[] paramsToPass = {transform.name, 4649};

		#if UNITY_ANDROID
		if (Application.platform == RuntimePlatform.Android) {

			// For Android, get reference to current activity and call method in it

			AndroidJavaClass unityPlayerClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
			AndroidJavaObject currentActivity = unityPlayerClass.GetStatic<AndroidJavaObject>("currentActivity");
			
			currentActivity.Call("objectTouched", paramsToPass); // call activity instance method
			currentActivity.CallStatic("helloStatic"); // call static method of activity class
			
		}
		#elif UNITY_IPHONE
		if (Application.platform == RuntimePlatform.IPhonePlayer) {

			// For iOS, method is directly called

			objectTouched(paramsToPass[0].ToString(), int.Parse(paramsToPass[1].ToString()));

		}
		#endif
		
	}
	
}
