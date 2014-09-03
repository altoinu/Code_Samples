using UnityEngine;
using System.Collections;

public class LicenseText : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
		string licenseWords = "These contents are licensed under the \"Unity-Chan\" License Terms and";
		licenseWords += "\n" + "Conditions (http://unity-chan.com/download/license_en.html). You are";
		licenseWords += "\n" + "allowed to use these contents only if you follow the Character Use";
		licenseWords += "\n" + "Guidelines (http://unity-chan.com/download/guideline_en.html) set by";
		licenseWords += "\n" + "Unity Technologies Japan G.K., for the usage of its characters.";

		guiText.text = licenseWords;

		/*
		string[] words = licenseWords.Split(" "[0]);
		string result = "";
		Rect textArea = new Rect();

		for (int i = 0; i < words.Length; i++) {

			guiText.text = (result + words[i] + " ");
			textArea = guiText.GetScreenRect();
			if (textArea.width > Screen.width / 2)
				result += ("\n" + words[i] + " ");
			else
				result = guiText.text;

		}
		*/

	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
