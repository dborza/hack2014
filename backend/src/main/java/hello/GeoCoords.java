package hello;

/**
 * Just represent two geo coordinates.
 *
 * Created by gborza on 03/04/2014.
 */
public class GeoCoords {

    public double lon;

    public double lat;

    @Override
    public String toString() {
        return "GeoCoords{" +
                "lon=" + lon +
                ", lat=" + lat +
                '}';
    }
}
