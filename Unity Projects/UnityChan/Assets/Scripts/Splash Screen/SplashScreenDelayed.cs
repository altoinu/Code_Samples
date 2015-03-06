/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2015 Kaoru Kawashima @altoinu http://altoinu.com
 */
using UnityEngine;
using System.Collections;

public class SplashScreenDelayed : MonoBehaviour {

	//public Texture imageToDisplay;
	public float timeToDisplayImage;

	private float timeForNextLevel;

	// Use this for initialization
	void Start () {
	
		timeForNextLevel = Time.time + timeToDisplayImage;
		
	}

	public void OnGUI() {

		//GUI.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), imageToDisplay);

		if (Time.time >= timeForNextLevel)
			Application.LoadLevel("main");

	}
}
