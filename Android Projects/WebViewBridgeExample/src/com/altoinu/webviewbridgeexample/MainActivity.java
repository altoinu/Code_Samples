/**
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this file,
 * You can obtain one at http://mozilla.org/MPL/2.0/.
 * 
 * Copyright (c) 2014 Kaoru Kawashima @altoinu http://altoinu.com
 */
package com.altoinu.webviewbridgeexample;

import java.lang.reflect.Method;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.TextView;

import com.altoinu.java.android.webkit.WebViewBridge;
import com.altoinu.java.android.webkit.WebViewBridge.CallbackDelegate;

public class MainActivity extends Activity {

	private WebViewBridge bridgeWebView;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		// WebViewBridge set up
		// WebViewBridge will load assets/html/index.html by default
		bridgeWebView = (WebViewBridge) findViewById(R.id.webView1);
		bridgeWebView.setCallbackDelegate(callbackDelegate);
		
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		//getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	@Override
	protected void onResume() {

		super.onResume();
		
	}
	
	/**
	 * Methods to be called (either directly or as callback) from HTML page
	 */
	private WebViewBridge.CallbackDelegate callbackDelegate = new CallbackDelegate() {
		
		public void helloWorldFunc() {
			
		}
		
		public void awesomeFunction(String text1, String text2) {
			
			Log.d(WebViewBridge.LOG_TAG, "I got something from HTML: " + text1 + " " + text2);
			
			TextView textView = (TextView) findViewById(R.id.textFromJS);
			textView.setText(text1 + " " + text2);
			
		}
		
		public void processReturnedData(Double returnValue1, String returnValue2) {
			
			Log.d(WebViewBridge.LOG_TAG, "I got something from HTML: " + String.valueOf(returnValue1) + " " + returnValue2);
			TextView textView = (TextView) findViewById(R.id.textFromJS);
			textView.setText(String.valueOf(returnValue1) + " " + returnValue2);
			
		}
		
	};
	
	public void triggerJavaScript(View view) {
		
		Object[] args = {"Hello world", "I like curry rice"};
		bridgeWebView.execJavaScript("sayHello", args);
		
		Object[] args2 = {"Good morning world", "I like katsu curry rice"};
		bridgeWebView.execJavaScript("sayHello", args2);
		
	}
	
	public void triggerJSAndCallback(View view) {
		
		try {
			
			Class<?>[] parameterTypes = {Double.class, String.class};
			Method callback = callbackDelegate.getClass().getMethod("processReturnedData", parameterTypes);
			
			Object[] args1 = {3, "Blah"};
			bridgeWebView.execJavaScript("giveMeData", args1, callback);
			Object[] args2 = {5, "Hello world..."};
			bridgeWebView.execJavaScript("giveMeData", args2, callback);
			
		} catch (NoSuchMethodException e) {
			
			throw new RuntimeException("processReturnedData not defined");
			
		}

	}
	
}
