using UnityEngine;
using System.Collections;

public class ARCameraScreenTouchDetect : MonoBehaviour
{
	
	private float maxPickingDistance = 2000;
	
	private Transform pickedObject = null;
	private Vector3 lastPlanePoint;
	
	// Use this for initialization
	void Start ()
	{
	
	}
	
	// Update is called once per frame
	void Update ()
	{
	
		checkTouch();
		
	}
	
	protected virtual void checkTouch() {
		
		Debug.Log(Input.mousePosition.ToString());
		Debug.Log(Input.GetMouseButton(0) + " " + Input.GetMouseButtonDown(0).ToString() + " " + Input.GetMouseButtonUp(0).ToString());
		
		Plane targetPlane = new Plane(transform.up, transform.position);
		
		foreach (Touch touch in Input.touches) {
			
			//Gets the ray at position where the screen is touched
			Ray ray = Camera.main.ScreenPointToRay(touch.position);
			
			if (touch.phase == TouchPhase.Began) {
				
				Debug.Log("Touch phase began at: " + touch.position);
				
				RaycastHit hit = new RaycastHit();
				if (Physics.Raycast(ray, out hit, maxPickingDistance)) {
					
					pickedObject = hit.transform;
					pickedObject.gameObject.SendMessage("onMouseDown");
					
				} else {
					
					pickedObject = null;
					
				}
				
			} else if (touch.phase == TouchPhase.Moved) {
				
				/*
				Debug.Log("Touch phase Moved");
				
				if (pickedObject != null) {
					
					//hit.transform.gameObject.SendMessage("onMouseDown");
					//hit.transform.gameObject.SendMessage("onMouseDrag");
					
					Vector2 screenDelta = touch.deltaPosition;
					
					float halfScreenWidth = 0.5f * Screen.width;
					float halfScreenHeight = 0.5f * Screen.height;
					
					float dx = screenDelta.x / halfScreenWidth;
					float dy = screenDelta.y / halfScreenHeight;
					
					Vector3 objectToCamera = pickedObject.transform.position - Camera.main.transform.position;
					float distance = objectToCamera.magnitude;
					
					float fovRad = Camera.main.fieldOfView + Mathf.Deg2Rad;
					float motionScale = distance * Mathf.Tan(fovRad / 2);
					
					Vector3 translationInCameraRef = new Vector3(motionScale * dx, motionScale * dy, 0);
					
					Vector3 translationInWorldRef = Camera.main.transform.TransformDirection(translationInCameraRef);
					
					pickedObject.position += translationInWorldRef;
					
				}
				*/
				
			} else if (touch.phase == TouchPhase.Ended) {
				
				Debug.Log("Touch phase Ended");
				
				if (pickedObject != null) {
					
					pickedObject.gameObject.SendMessage("onMouseUp");
					pickedObject = null;
					
				}
				
			}
			
		}
		
	}
	
}

