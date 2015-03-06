/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2015 Kaoru Kawashima @altoinu http://altoinu.com
 */
using UnityEngine;
using System.Collections;
using System.Runtime.InteropServices;

/**
 * Object touch handler to integrate with native Android/iOS code.
 * Attach this to game object that should respond to touch.
 */ 
public class GameObjectTouchRespond : MonoBehaviour {

	// Function in iOS Obj C code to be called
	[DllImport("__Internal")]
	private static extern void objectTouched(string message, int message2);

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
		
	}
	
	void onMouseUp() {

		Debug.Log("Unitychan touched");

		//this.transform;
		//object[] paramsToPass = {transform.name, 4649};
		object[] paramsToPass = {transform.name, 5963};

		#if UNITY_ANDROID
		if (Application.platform == RuntimePlatform.Android) {

			// Android

			// Get reference to current activity and call method in it
			AndroidJavaClass unityPlayerClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
			AndroidJavaObject currentActivity = unityPlayerClass.GetStatic<AndroidJavaObject>("currentActivity");

			// then call public java method in it (optionally with parameters)
			currentActivity.Call("objectTouched", paramsToPass); // call activity instance method
			//currentActivity.CallStatic("staticFunctionName"); // call static method of activity class
			
		}
		#elif UNITY_IPHONE
		if (Application.platform == RuntimePlatform.IPhonePlayer) {

			// iOS

			// Call Obj C method directly (optionally with corresponding parameters)
			objectTouched(paramsToPass[0].ToString(), int.Parse(paramsToPass[1].ToString()));

		}
		#endif
		
	}
	
}
