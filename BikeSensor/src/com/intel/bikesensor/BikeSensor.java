package com.intel.bikesensor;

import android.app.Activity;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Random;

/**
 * Get/display/send current geo location.
 * <p>
 * </p>
 * Specials thanks to {@code http://stackoverflow.com/questions/8235385/display-gps-location-on-screen-android}.
 */
public class BikeSensor extends Activity {

    private final Random random = new Random();

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {

        Log.i("tag", "Start Activity");

        super.onCreate(savedInstanceState);

        Log.i("tag", "After onCreate");

        setContentView(R.layout.main);

        Log.i("tag", "After setContentView");

        LocationManager locManager = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
        Log.i("tag", "Found location manager " + locManager);
        LocationListener locListener = new MyLocationListener();
        locManager.requestLocationUpdates( LocationManager.GPS_PROVIDER, 1000, 0.1f, locListener);

        Log.i("tag", "End create Activity");
    }

    public class MyLocationListener implements LocationListener
    {
        TextView tv = (TextView) findViewById(R.id.geoText);

        @Override
        public void onLocationChanged(Location loc){
            Log.i("tag", "Finding Latitude");
            double lat = loc.getLatitude();
            Log.i("tag", "Lat: "+String.valueOf(lat));
            Log.i("tag", "Finding Longitude");
            double lon = loc.getLongitude();
            Log.i("tag", "Lon: "+String.valueOf(lon));
            String Text = "My current location is: " + random.nextInt(100000) +
            "\nLatitude = " + lat +
            "\nLongitude = " + lon;

            // Display location
            tv.setText(Text);
        }

        @Override
        public void onProviderDisabled(String provider){
            Log.i("tag", "onProviderDisabled " + provider);
            Toast.makeText(getApplicationContext(), "Gps Disabled", Toast.LENGTH_SHORT ).show();
        }

        @Override
        public void onProviderEnabled(String provider){
            Log.i("tag", "onProviderEnabled " + provider);
            Toast.makeText(getApplicationContext(), "Gps Enabled", Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onStatusChanged(String provider, int status, Bundle extras){
            Log.i("tag", "onStatusChanged " + provider + ", status: " + status);
        }

    }
}
