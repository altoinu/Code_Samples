package com.altoinu.glass.glass_inputtest;

import java.util.ArrayList;
import java.util.List;

import com.google.android.glass.app.Card;
import com.google.android.glass.timeline.TimelineManager;
import com.google.android.glass.touchpad.Gesture;
import com.google.android.glass.touchpad.GestureDetector;

import android.location.Criteria;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.speech.RecognizerIntent;
import android.speech.SpeechRecognizer;
import android.util.Log;
import android.view.KeyEvent;
import android.view.Menu;
import android.view.MotionEvent;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.TextView;

public class MainActivity extends Activity {

	private static final String LOGTAG = "GlassInputTest";
	
	private GestureDetector mGestureDetector;
	
	private LocationManager mLocationManager;
	private List<String> providers;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		
		//this.requestWindowFeature(Window.FEATURE_NO_TITLE);
		//this.getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN, WindowManager.LayoutParams.FLAG_FULLSCREEN);
		
		mGestureDetector = createGestureDetector(this);
		
		// location
		mLocationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
		Criteria criteria = new Criteria();
		criteria.setAccuracy(Criteria.ACCURACY_FINE);
		criteria.setAltitudeRequired(true);
		providers = mLocationManager.getProviders(criteria, true);
		
	}

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		//getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}

	/* for services
	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		
		ArrayList<String> voiceResults = getIntent().getExtras().getStringArrayList(RecognizerIntent.EXTRA_RESULTS);
		
	}
	*/
	
	@Override
	protected void onResume() {
		
		super.onResume();
		
		Log.d(LOGTAG, "onResume");
		
		// Whatever was entered through initial voice input
		ArrayList<String> voiceResults = getIntent().getExtras().getStringArrayList(RecognizerIntent.EXTRA_RESULTS);
		if (!voiceResults.isEmpty()) {
			
			TextView textVoice = (TextView) findViewById(R.id.textInitialVoiceInput);
			textVoice.setText(voiceResults.get(0));
			
		}
		
		// start location update
		for (String provider : providers) {
			
			Log.d(LOGTAG, "provider: " + String.valueOf(provider));
			
			Location lastLocation = mLocationManager.getLastKnownLocation(provider);
			if (lastLocation != null) {
				mLocationListener.onLocationChanged(lastLocation);
			}
			
			mLocationManager.requestLocationUpdates(provider, 0, 0, mLocationListener);
			
		}
		
		
	}
	
	@Override
	protected void onPause() {
		
		super.onPause();
		
		Log.d(LOGTAG, "onPause");
		
		mLocationManager.removeUpdates(mLocationListener);
		
	}
	
	private static Location currentLocation;
	
	private LocationListener mLocationListener = new LocationListener() {

		@Override
		public void onStatusChanged(String provider, int status, Bundle extras) {
			// TODO Auto-generated method stub
			Log.d(LOGTAG, "onStatusChanged - " + provider + ", " + String.valueOf(status));
		}
		
		@Override
		public void onProviderEnabled(String provider) {
			// TODO Auto-generated method stub
			Log.d(LOGTAG, "onProviderEnabled - " + provider);
		}
		
		@Override
		public void onProviderDisabled(String provider) {
			// TODO Auto-generated method stub
			Log.d(LOGTAG, "onProviderDisabled - " + provider);
		}
		
		@Override
		public void onLocationChanged(Location location) {
			// TODO Auto-generated method stub
			
			Log.d(LOGTAG, "onLocationChanged");
			
			if (isBetterLocation(location, currentLocation))
			{
				
				String message = String.valueOf(location.getLatitude()) + ", " + String.valueOf(location.getLongitude());
				
				TextView textLocation = (TextView) findViewById(R.id.textLocation);
				textLocation.setText(message);
				
				currentLocation = location;
				
				Log.d(LOGTAG, "location - " + message);
				
			}
			
		}
		
	};
	
	private static final int TWO_MINUTES = 1000 * 60 * 2;

	/**
	 * Determines whether one Location reading is better than the current
	 * Location fix
	 * 
	 * @param location
	 *            The new Location that you want to evaluate
	 * @param currentBestLocation
	 *            The current Location fix, to which you want to compare the new
	 *            one
	 */
	protected boolean isBetterLocation(Location location, Location currentBestLocation) {
		if (currentBestLocation == null) {
			// A new location is always better than no location
			return true;
		}

		// Check whether the new location fix is newer or older
		long timeDelta = location.getTime() - currentBestLocation.getTime();
		boolean isSignificantlyNewer = timeDelta > TWO_MINUTES;
		boolean isSignificantlyOlder = timeDelta < -TWO_MINUTES;
		boolean isNewer = timeDelta > 0;

		// If it's been more than two minutes since the current location, use
		// the new location
		// because the user has likely moved
		if (isSignificantlyNewer) {
			return true;
			// If the new location is more than two minutes older, it must be
			// worse
		} else if (isSignificantlyOlder) {
			return false;
		}

		// Check whether the new location fix is more or less accurate
		int accuracyDelta = (int) (location.getAccuracy() - currentBestLocation
				.getAccuracy());
		boolean isLessAccurate = accuracyDelta > 0;
		boolean isMoreAccurate = accuracyDelta < 0;
		boolean isSignificantlyLessAccurate = accuracyDelta > 200;

		// Check if the old and new location are from the same provider
		boolean isFromSameProvider = isSameProvider(location.getProvider(),
				currentBestLocation.getProvider());

		// Determine location quality using a combination of timeliness and
		// accuracy
		if (isMoreAccurate) {
			return true;
		} else if (isNewer && !isLessAccurate) {
			return true;
		} else if (isNewer && !isSignificantlyLessAccurate && isFromSameProvider) {
			return true;
		}
		return false;
	}

	/** Checks whether two providers are the same */
	private boolean isSameProvider(String provider1, String provider2) {
		if (provider1 == null) {
			return provider2 == null;
		}
		return provider1.equals(provider2);
	}
	
	@Override
	public boolean onKeyDown(int keycode, KeyEvent event) {
		
		TextView touchAction = (TextView) findViewById(R.id.textTouchAction);
		
		switch (keycode) {
		/*
		case KeyEvent.KEYCODE_DPAD_CENTER:
			touchAction.setText("Tap");
			break;
			*/

		case KeyEvent.KEYCODE_CAMERA:
			touchAction.setText("Camera");
			return true;
			
		case KeyEvent.KEYCODE_BACK:
			touchAction.setText("back (swipe down) overridden, two finger tap to exit");
			
			return true;
			
		default:
			break;
		}
		
		return false;
		
	}
	
	private GestureDetector createGestureDetector(Context context) {
		
		GestureDetector gestureDetector = new GestureDetector(context);
		
		gestureDetector.setBaseListener(new GestureDetector.BaseListener() {
			
			@Override
			public boolean onGesture(Gesture gesture) {
				
				TextView touchAction = (TextView) findViewById(R.id.textTouchAction);
				
				switch (gesture) {
				
				case TAP:
					touchAction.setText("tap");
					return false;

				case TWO_TAP:
					touchAction.setText("two finger tap");
					finish();
					return true;
					
				case SWIPE_RIGHT:
					touchAction.setText("swipe right");
					return true;
					
				case SWIPE_LEFT:
					touchAction.setText("swipe left");
					return true;
					
				default:
					break;
				}
				
				
				return false;
				
			}
			
		});
		
		/*
		gestureDetector.setFingerListener(new GestureDetector.FingerListener() {
			
			@Override
			public void onFingerCountChanged(int prev, int current) {

				TextView touchAction = (TextView) findViewById(R.id.textTouchAction);
				touchAction.setText(String.valueOf(prev) + " -> " + String.valueOf(current));
				
			}
			
		});
		*/
		
		gestureDetector.setScrollListener(new GestureDetector.ScrollListener() {
			
			@Override
			public boolean onScroll(float displacement, float delta, float velocity) {

				TextView touchAction = (TextView) findViewById(R.id.textTouchAction);
				touchAction.setText("displacement: " + String.valueOf(displacement) + " delta: " + String.valueOf(delta) + " velocity: " + String.valueOf(velocity));
				
				return false;
				
			}
			
		});
		
		return gestureDetector;
		
	}
	
	@Override
	public boolean onGenericMotionEvent(MotionEvent event) {
		
		if (mGestureDetector != null) {
			return mGestureDetector.onMotionEvent(event);
		}
		
		return false;
		
	}
	
	private static final int SPEECH_REQUEST = 0;
	public void onSpeakClick(View view) {
		
		Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);
		startActivityForResult(intent, SPEECH_REQUEST);
		
	}
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		
		if ((requestCode == SPEECH_REQUEST) && (resultCode == RESULT_OK)) {
			
			List<String> results = data.getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);
			String spokenText = results.get(0);
			
			EditText textVoice = (EditText) findViewById(R.id.editText1);
			textVoice.setText(spokenText);
			
		}
		
	}
	
	public void onWriteCardClick(View view) {
		
		EditText textVoice = (EditText) findViewById(R.id.editText1);
		String message = textVoice.getText().toString();
		
		if (message.length() > 0) {
			
			Card card1 = new Card(this);
			card1.setText(message);
			card1.setFootnote("This is what you said");
			//View card1View = card1.toView();
			
			TimelineManager timelineManager = TimelineManager.from(this);
			timelineManager.insert(card1);
			finish();
			
		}
		
	}
	
}
