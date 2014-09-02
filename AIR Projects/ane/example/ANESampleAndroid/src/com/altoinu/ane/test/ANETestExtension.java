package com.altoinu.ane.test;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;
import com.altoinu.ane.test.context.ANETestExtensionContext;

public class ANETestExtension implements FREExtension {
	
	@Override
	public FREContext createContext(String arg0) {
		
		return new ANETestExtensionContext();
		
	}

	@Override
	public void dispose() {
		// Clean up when native extension is not needed anymore by app

	}

	@Override
	public void initialize() {
		// Native extension ready

	}

}
