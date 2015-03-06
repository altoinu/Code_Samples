/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2015 Kaoru Kawashima @altoinu http://altoinu.com
 */
using UnityEngine;
using System.Collections;

/**
 * Catch back key tap on Android. Attach this to camera.
 * 
 * On Android end, create an activity that extends activity
 * that holds on to Unity view (usually UnityPlayerNativeActivity
 * which is created in exported Android project) and add
 * public method "onBackKeyPress."
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

			// Get current Android Activity holding Unity view
			AndroidJavaClass unityPlayerClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
			AndroidJavaObject currentActivity = unityPlayerClass.GetStatic<AndroidJavaObject>("currentActivity");

			// Tell corresponding public method in this
			// Android activity that back key was pressed
			currentActivity.Call("onBackKeyPress");
			
		}
#endif
		
	}
	
}
