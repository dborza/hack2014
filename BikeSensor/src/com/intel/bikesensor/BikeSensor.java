package com.intel.bikesensor;

import android.app.Activity;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;
import android.widget.Toast;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

import java.io.IOException;
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
     * Hardcoded (for now) id of bike that is associated with this app (sensor).
     */
    private final long bikeId = 1l;

    /**
     * Http client used for Internet awesomeness.
     */
    final DefaultHttpClient defaultHttpClient = new DefaultHttpClient();

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        setContentView(R.layout.main);

        LocationManager locManager = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
        LocationListener locListener = new MyLocationListener();
        locManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 3000, 5.0f, locListener);
    }

    public class MyLocationListener implements LocationListener
    {
        TextView tv = (TextView) findViewById(R.id.geoText);

        @Override
        public void onLocationChanged(Location loc){
            double lat = loc.getLatitude();
            double lon = loc.getLongitude();
            String Text = "My current location is: " + random.nextInt(100000) +
            "\nLatitude = " + lat +
            "\nLongitude = " + lon;

            // Display location
            tv.setText(Text);

            new UpdateLocationToserverAsyncTask(bikeId, lat, lon).execute();

        }

        @Override
        public void onProviderDisabled(String provider){
            Toast.makeText(getApplicationContext(), "Gps Disabled", Toast.LENGTH_SHORT ).show();
        }

        @Override
        public void onProviderEnabled(String provider){
            Toast.makeText(getApplicationContext(), "Gps Enabled", Toast.LENGTH_SHORT).show();
        }

        @Override
        public void onStatusChanged(String provider, int status, Bundle extras){
        }

    }

    class UpdateLocationToserverAsyncTask extends AsyncTask<Void, Void, Void> {

        private final double lat;

        private final double lon;

        private final long bikeId;

        UpdateLocationToserverAsyncTask(long bikeId, double lat, double lon) {
            this.bikeId = bikeId;
            this.lat = lat;
            this.lon = lon;
        }

        @Override
        protected Void doInBackground(Void... urls) {

            final HttpPut put = new HttpPut(getString(R.string.server_bike_url) + bikeId + "?lat=" + lat + "&lon=" + lon);

            HttpResponse response = null;

            try {
                response = defaultHttpClient.execute(put);
                final long responseCode = response.getStatusLine().getStatusCode();
                final String responseBody = EntityUtils.toString(response.getEntity());
                Log.i("tag", "Received response " + responseCode + ", body: " + responseBody);
            } catch (ClientProtocolException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (response != null) {
                    try {
                        response.getEntity().consumeContent();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }

                }
            }

            return null;
        }

        @Override
        protected void onPostExecute(Void feed) {
        }

    }

}
