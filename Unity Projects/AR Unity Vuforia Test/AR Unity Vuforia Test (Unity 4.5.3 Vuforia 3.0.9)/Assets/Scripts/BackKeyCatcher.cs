using UnityEngine;
using System.Collections;

/**
 * Catch back key tap on Android
 */
public class BackKeyCatcher : MonoBehaviour {
	
	//private bool isKeyDown = false;
	
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		
#if UNITY_ANDROID
		if (Input.GetKeyUp(KeyCode.Escape)) {
			
			onBackKeyPress();
			
		}
		
		/*
		if (!isKeyDown) {
			
			if (Input.GetKeyDown(KeyCode.Escape)) {
				
				//Application.Quit();
				onBackKeyPress();
				isKeyDown = true;
				
			}
			
		} else {
			
			if (Input.GetKeyUp(KeyCode.Escape)) {
				
				isKeyDown = false;
				
			}
			
		}
		*/
#endif
		
	}
	
	void onBackKeyPress () {
		
#if UNITY_ANDROID
		if (Application.platform == RuntimePlatform.Android) {

			// Tell Android activity that back key was pressed
			AndroidJavaClass unityPlayerClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
			AndroidJavaObject currentActivity = unityPlayerClass.GetStatic<AndroidJavaObject>("currentActivity");
			
			currentActivity.Call("onBackKeyPress");
			
		}
#endif
		
	}
	
}
