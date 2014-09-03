using UnityEngine;
using System.Collections;

public class CameraFocus : MonoBehaviour {

	private bool autoFocusAvailable = false;
	
	// Use this for initialization
	void Start () {
	
		// Set camera auto focus
		doCameraFocus();
		Debug.Log("YAAAAAAAY  DEBUG Log!!!!!" + autoFocusAvailable);
		
		if (autoFocusAvailable) {
			
			// we need to reset continuous auto focus since it stops after a while
			StartCoroutine("resetContinuousAutoFocus");
			
		}
		
	}
	
	// Update is called once per frame
	void Update () {
	
		if (!autoFocusAvailable && Input.GetMouseButtonUp(0)) {
			
			doCameraFocus();
			
		}
		
	}
	
	private IEnumerator resetContinuousAutoFocus() {
		
		while (true) {
			
			yield return new WaitForSeconds(10.0f);
			
			doCameraFocus();
			
		}
		
	}
	
	void doCameraFocus() {
		
		autoFocusAvailable = CameraDevice.Instance.SetFocusMode(CameraDevice.FocusMode.FOCUS_MODE_CONTINUOUSAUTO);
		
		if (!autoFocusAvailable) {
			
			// If auto focus is not available for this device, we will do focus with screen tap
			CameraDevice.Instance.SetFocusMode(CameraDevice.FocusMode.FOCUS_MODE_TRIGGERAUTO);
			
		}
		
	}
	
}
