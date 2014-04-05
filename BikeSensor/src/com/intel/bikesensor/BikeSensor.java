package com.intel.bikesensor;

import android.app.Activity;
import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
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
 *
 * @author Dan Borza [brz]
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
    private final DefaultHttpClient defaultHttpClient = new DefaultHttpClient();

    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        setContentView(R.layout.main);

        setupLocationManager();

        setupButtons();
    }

    private void setupButtons() {
        final Button markFreeAndIncCount = (Button) findViewById(R.id.btn_MarkFreeIncCount);
        final Button markTakenAndDecCount = (Button) findViewById(R.id.btn_markTakenDecCount);
        markFreeAndIncCount.setOnClickListener(new TakeOrLeaveBikeAtStationOnClickListener(1));
        markTakenAndDecCount.setOnClickListener(new TakeOrLeaveBikeAtStationOnClickListener(-1));
    }

    private void setupLocationManager() {
        LocationManager locManager = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
        LocationListener locListener = new MyLocationListener();
        locManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 3000, 5.0f, locListener);
    }

    /**
     * Code for triggering the action to take / return a bike from a station.
     */
    class TakeOrLeaveBikeAtStationOnClickListener implements View.OnClickListener {

        private final int delta;

        /**
         * Delta {@code +1} means we are returning the bike to the station and delta {@code -1}
         * means we are taking it away from the station.
         *
         * @param delta The amount with which we increase the number of bikes from the station.
         */
        TakeOrLeaveBikeAtStationOnClickListener(int delta) {
            this.delta = delta;
        }

        @Override
        public void onClick(View view) {

            final EditText bikeIdEditText = (EditText) findViewById(R.id.text_bikeId);
            final EditText stationIdEditText = (EditText) findViewById(R.id.text_stationId);
            final Long bikeId = Long.valueOf(bikeIdEditText.getText().toString());
            final Long stationId = Long.valueOf(stationIdEditText.getText().toString());

            Log.i("tag", "delta: " + delta + ", bikeId: " + bikeId + ", stationId: " + stationId);

            String baseUrl = getString(R.string.take_or_leave_bike_at_station_url);

            new TakeOrLeaveBikeAtStationAsyncTask(bikeId, stationId, delta, baseUrl).execute();
        }
    }

    /**
     * Make sure the server knows that the Bike is being parked / unparked from a station
     * by modifying the bike number that are being parked at the given station.
     */
    class TakeOrLeaveBikeAtStationAsyncTask extends AsyncTask<Void, Void, Void> {

        private final long bikeId;
        private final long stationId;
        private final int delta;
        private final String baseUrl;

        TakeOrLeaveBikeAtStationAsyncTask(long bikeId, long stationId, int delta, String baseUrl) {
            this.bikeId = bikeId;
            this.stationId = stationId;
            this.delta = delta;
            this.baseUrl = baseUrl;
        }

        @Override
        protected Void doInBackground(Void... voids) {

            final HttpPut put = new HttpPut(baseUrl + "?bikeId=" + bikeId + "&stationId=" + stationId + "&delta=" + delta);

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
    }

    /**
     * Handle the change of location event.
     */
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
