package com.altoinu.unity.android.unitychanandroidintegration;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import com.altoinu.unity.UnityChan.UnityPlayerNativeActivity;
import com.altoinu.unity.android.unitychanandroidintegration.supportClasses.DebugValues;
import com.unity3d.player.UnityPlayer;

public class UnityChanViewActivity extends UnityPlayerNativeActivity {

	private static final String ACTIVITY_NAME = "UnityChanViewActivity";

	@Override
	protected void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);

		Log.d(DebugValues.LOG_TAG, ACTIVITY_NAME + " onCreate");

	}

	@Override
	protected void onStart() {

		super.onStart();
		Log.d(DebugValues.LOG_TAG, ACTIVITY_NAME + " onStart");

	}

	@Override
	protected void onResume() {

		super.onResume();
		Log.d(DebugValues.LOG_TAG, ACTIVITY_NAME + " onResume");

	}

	@Override
	protected void onPause() {

		super.onPause();
		Log.d(DebugValues.LOG_TAG, ACTIVITY_NAME + " onPause");
		
		// must quit Unity player here or app crashes
		this.mUnityPlayer.quit();

	}

	@Override
	protected void onStop() {

		super.onStop();
		Log.d(DebugValues.LOG_TAG, ACTIVITY_NAME + " onStop");

	}

	@Override
	protected void onRestart() {

		super.onStart();
		Log.d(DebugValues.LOG_TAG, ACTIVITY_NAME + " onRestart");

	}

	@Override
	protected void onDestroy() {

		super.onDestroy();
		Log.d(DebugValues.LOG_TAG, ACTIVITY_NAME + " onDestroy");

	}

	public void objectTouched(String message, int messageNum) {

		Log.d(DebugValues.LOG_TAG, ACTIVITY_NAME + " objectTouched called, args: " + message + String.valueOf(messageNum));

	}

	public void onBackKeyPress() {

		Log.d(DebugValues.LOG_TAG, ACTIVITY_NAME + " onBackKeyPress");
		
		//UnityPlayer.currentActivity.finish();
		finish();

	}

}
