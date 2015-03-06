using UnityEngine;
using System.Collections;

public class CameraRotateUsingAccelerometer : MonoBehaviour
{
	
	Vector3 gravity = new Vector3 (0, -1, 0);
	
	bool accelerometerAvailable = false;
	
	Camera targetCamera;
	
	// Use this for initialization
	void Start ()
	{
	
		if (SystemInfo.supportsAccelerometer) {
			
			accelerometerAvailable = true;
			
		}
		
		targetCamera = Camera.main;
		
	}
	
	// Update is called once per frame
	void Update ()
	{
		
		// Using accelerometer, rotate camera
		if (accelerometerAvailable) {

			Vector3 acceleration = Input.acceleration;
			acceleration.x *= 1;
			acceleration.y *= 1;
			acceleration.z *= -1;
			float lowPassFilterFactor = 1.0f;
			targetCamera.transform.rotation = Quaternion.Slerp(targetCamera.transform.rotation, Quaternion.FromToRotation (gravity, acceleration), lowPassFilterFactor);

			targetCamera.transform.Rotate(new Vector3(0, 180, 0));

		}
		
	}
	
}
