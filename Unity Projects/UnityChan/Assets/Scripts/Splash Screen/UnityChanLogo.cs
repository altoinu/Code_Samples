/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2015 Kaoru Kawashima @altoinu http://altoinu.com
 */
using UnityEngine;
using System.Collections;

public class UnityChanLogo : MonoBehaviour {

	// Use this for initialization
	void Start () {

		float logoAspect = (float)this.guiTexture.texture.width / (float)this.guiTexture.texture.height;
		float logoWidth = 0.3f * Screen.width;
		float logoHeight = logoWidth / logoAspect;

		//this.guiTexture.pixelInset = new Rect(-logoWidth / 2, -logoHeight / 4, logoWidth, logoHeight);
		this.guiTexture.pixelInset = new Rect(-logoWidth / 2, 0, logoWidth, logoHeight);

	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
