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
