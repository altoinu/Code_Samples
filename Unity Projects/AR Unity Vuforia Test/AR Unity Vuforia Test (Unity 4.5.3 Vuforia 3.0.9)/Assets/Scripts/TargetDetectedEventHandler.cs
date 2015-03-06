using UnityEngine;
using System.Collections;

/**
 * Attach this to image target to detect when it is seen by camera
 */
public class TargetDetectedEventHandler : MonoBehaviour, ITrackableEventHandler {
	
	private TrackableBehaviour mTrackableBehaviour;
     
    private bool mShowGUIButton = false;
    private Rect mButtonRect = new Rect(50,50,120,60);
	
	// Use this for initialization
	void Start () {
		mTrackableBehaviour = GetComponent<TrackableBehaviour>();
        if (mTrackableBehaviour)
        {
            mTrackableBehaviour.RegisterTrackableEventHandler(this);
        }
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	public void OnTrackableStateChanged(
                                    TrackableBehaviour.Status previousStatus,
                                    TrackableBehaviour.Status newStatus)
    {

        if (newStatus == TrackableBehaviour.Status.DETECTED ||
		    newStatus == TrackableBehaviour.Status.TRACKED ||
		    newStatus == TrackableBehaviour.Status.EXTENDED_TRACKED)
        {

			#if UNITY_ANDROID
			if (Application.platform == RuntimePlatform.Android) {
				
				AndroidJavaClass unityPlayerClass = new AndroidJavaClass("com.unity3d.player.UnityPlayer");
				AndroidJavaObject currentActivity = unityPlayerClass.GetStatic<AndroidJavaObject>("currentActivity");

				//transform.name
				object[] paramsToPass = {"Hatsune Miku Detected", 4649};
				currentActivity.Call("hello", paramsToPass);
				
				currentActivity.CallStatic("helloStatic");
				
			}
			#endif

        }

    }
	
}
