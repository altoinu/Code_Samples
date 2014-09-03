using UnityEngine;
using System.Collections;

public class TouchMaterialColorChange : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
	
	void onMouseDown() {
		
		float r = Random.Range(0f,1f);
		float g = Random.Range(0f,1f);
		float b = Random.Range(0f,1f);
		Color randomColour = new Color(r,g,b,1f);
		
		//renderer.material.color = Color.green;
		doChangeColor(randomColour);
		
	}
	
	void doChangeColor(Color newColor) {
		
		renderer.material.color = newColor;
		
	}
	
	void changeMaterialColor(string hexColorValue) {
		
		byte r = byte.Parse(hexColorValue.Substring(0, 2), System.Globalization.NumberStyles.HexNumber);
		byte g = byte.Parse(hexColorValue.Substring(2, 2), System.Globalization.NumberStyles.HexNumber);
		byte b = byte.Parse(hexColorValue.Substring(4, 2), System.Globalization.NumberStyles.HexNumber);
		
		doChangeColor(new Color(r, g, b, 1f));
		
	}
	
}
