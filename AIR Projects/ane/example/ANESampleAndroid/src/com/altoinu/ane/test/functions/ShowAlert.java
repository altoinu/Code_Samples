package com.altoinu.ane.test.functions;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.altoinu.ane.test.ANETestConstants;

public class ShowAlert implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] arg) {
		
		//Context appContext = context.getActivity().getApplicationContext();
		//
		
		// arguments specified in AIR will be available in arg
		String message;
		
		try {
			
			message = arg[0].getAsString();
			
		} catch (Exception e) {
			
			message = "";
			
		}
		
		Log.d(ANETestConstants.LOG_TAG, "Message received by ANESampleAndroid.ANETestExtension.ShowAlert: " + message);
		
		final FREContext context_alertHandler = context;
		
		AlertDialog.Builder alertBuilder = new AlertDialog.Builder(context.getActivity());
		alertBuilder.setTitle("Alert via ANE");
		alertBuilder.setMessage(message);
		alertBuilder.setCancelable(false);
		alertBuilder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				
				Log.d(ANETestConstants.LOG_TAG, "OK clicked");
				dialog.cancel();
				
				// Dispatch event to AIR
				context_alertHandler.dispatchStatusEventAsync("okClicked", "okLevel");
				
			}
			
		});
		alertBuilder.setNegativeButton("CANCEL", new DialogInterface.OnClickListener() {
			
			@Override
			public void onClick(DialogInterface dialog, int which) {
				
				Log.d(ANETestConstants.LOG_TAG, "CANCEL clicked");
				dialog.cancel();

				// Dispatch event to AIR
				context_alertHandler.dispatchStatusEventAsync("cancelClicked", "cancelLevel");
				
			}
			
		});
		
		AlertDialog alertMsg = alertBuilder.create();
		alertMsg.show();
		
		// Return value to AIR
		String returnMessage = "Hello back from ANESampleAndroid.ANETestExtension.ShowAlert!";
		FREObject returnObj;
		
		try {
			
			returnObj = FREObject.newObject(returnMessage);
			
		} catch (Exception e) {
			
			returnObj = null;
			
		}
		
		return returnObj;
		
	}

}
