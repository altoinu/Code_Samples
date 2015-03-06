using UnityEngine;
using System.Collections;

public class CameraRotateUsingGyroscope : MonoBehaviour
{
	
	bool gyroAvailable = false;
	
	Gyroscope gyro;
	Quaternion cameraBase;
	
	//Quaternion quatMult;
	//Quaternion quatMap;
	
	Camera targetCamera;
	
	// Use this for initialization
	void Start ()
	{
	
		if (SystemInfo.supportsGyroscope) {
			
			gyroAvailable = true;
			gyro = Input.gyro;
			gyro.enabled = true;
			
			/*
			#if UNITY_IPHONE
			if (Screen.orientation == ScreenOrientation.LandscapeLeft) {
				quatMult = new Quaternion(0, 0, 0.7071, 0.7071);
			} else if (Screen.orientation == ScreenOrientation.LandscapeRight) {
				quatMult = new Quaternion(0, 0, -0.7071, 0.7071);
			} else if (Screen.orientation == ScreenOrientation.Portrait) {
				quatMult = new Quaternion(0, 0, 1, 0);
			} else if (Screen.orientation == ScreenOrientation.PortraitUpsideDown) {
				quatMult = new Quaternion(0, 0, 0, 1);
			}
			#endif
			#if UNITY_ANDROID
			if (Screen.orientation == ScreenOrientation.LandscapeLeft) {
				quatMult = new Quaternion(0, 0, 0.7071f, -0.7071f);
			} else if (Screen.orientation == ScreenOrientation.LandscapeRight) {
				quatMult = new Quaternion(0,0, -0.7071f, -0.7071f);
			} else if (Screen.orientation == ScreenOrientation.Portrait) {
				quatMult = new Quaternion(0, 0, 0, 1);
			} else if (Screen.orientation == ScreenOrientation.PortraitUpsideDown) {
				quatMult = new Quaternion(0, 0, 1, 0);
			}
			#endif
			*/
			
			// camera look direction to base off of
			// Which direction is camera facing when gyroscope is neutral (screen facing up into sky, top pointing north)?
			// -Mobile device back camera is looking at -z-axis
			// -Coordinate system is x-axis - west->east, y-axis south->north, z-axis ground->sky
			
			// z-axis point towards sky (looking down on ground), y-axis towards north
			// This has no effect on camera look direction (neutral position)
			//cameraBase = Quaternion.LookRotation(new Vector3(0, 0, 1), new Vector3(0, 1, 0));
			
			// z-axis point towards ground (looking up towards sky), y-axis towards north
			//cameraBase = Quaternion.LookRotation(new Vector3(0, 0, -1), new Vector3(0, 1, 0));
			
			cameraBase = Quaternion.LookRotation(new Vector3(0, -1, 0), new Vector3(0, 0, 1));

		}
		
		targetCamera = Camera.main;
		
	}
	
	// Update is called once per frame
	void Update ()
	{
		
		// Using gyroscope, rotate camera
		if (gyroAvailable) {
			
			/*
			#if UNITY_IPHONE
				quatMap = gyro.attitude;
			#endif
			#if UNITY_ANDROID
				quatMap = new Quaternion(gyro.attitude.w, gyro.attitude.x, gyro.attitude.y, gyro.attitude.z);
			#endif
			
			targetCamera.transform.localRotation = quatMap * quatMult;
			*/
			
			// Copy gyroscope values to camera rotation
			Quaternion attitude = new Quaternion(gyro.attitude.x, gyro.attitude.y, -gyro.attitude.z, -gyro.attitude.w);
			targetCamera.transform.rotation = cameraBase * attitude;
			
		}
		
	}
	
}
