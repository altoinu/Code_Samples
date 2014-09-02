package com.altoinu.ane.test.context;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.altoinu.ane.test.functions.ShowAlert;
import com.altoinu.ane.test.functions.ShowNativeView;

public class ANETestExtensionContext extends FREContext {

	@Override
	public void dispose() {
		// Clean up when this FREContext is not needed anymore

	}

	@Override
	public Map<String, FREFunction> getFunctions() {
		// Map functions to FREFunction
		
		Map<String, FREFunction> functions = new HashMap<String, FREFunction>();
		
		functions.put("showAlertMessage", new ShowAlert());
		functions.put("showNativeView", new ShowNativeView());
		
		return functions;
		
	}

}
