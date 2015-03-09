/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2015 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.unity.android.unitychanandroidintegration;

import com.altoinu.unity.android.unitychanandroidintegration.supportClasses.DebugValues;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

public class MainActivity extends Activity {

	private static final String ACTIVITY_NAME = "MainActivity";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Log.d(DebugValues.LOG_TAG, ACTIVITY_NAME + " onCreate");
        setContentView(R.layout.activity_main);
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
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
	
    public void openUnityView(View view) {
    	
    	Intent unityStartIntent = new Intent(this, UnityChanViewActivity.class);
    	
    	startActivity(unityStartIntent);
    	
    }
    
}
