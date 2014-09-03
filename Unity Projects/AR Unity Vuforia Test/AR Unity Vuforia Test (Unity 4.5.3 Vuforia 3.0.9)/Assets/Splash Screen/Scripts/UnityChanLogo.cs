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
