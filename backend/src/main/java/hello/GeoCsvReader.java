package hello;

import java.io.*;
import java.net.URI;
import java.net.URL;
import java.util.Collection;
import java.util.LinkedList;
import java.util.List;
import java.util.Vector;

/**
 * Read an input file located at the root of the classpath (either on the file system or in the final jar) and return
 * a list of {@link hello.GeoCoords} from it.
 *
 * This stuff can be used to build tracks for the bicycles to ride on. Useful for demo purposes, but not only.
 *
 * Created by gborza on 03/04/2014.
 */
public class GeoCsvReader {

    /**
     * Input filename that is going to be read from the classpath (just place in the resource folder and call the
     * method with "/fileName" where fileName is the file placed in the resource folder.
     * @param fileName
     * @return
     */
    public List<GeoCoords> run(String fileName) {

        System.out.println("File name: " + new File(fileName).getAbsolutePath() + ", exists: " + new File(fileName).exists());

        List<GeoCoords> list = new LinkedList<GeoCoords>();

        BufferedReader br = null;
        InputStream is = null;
        String line = "";
        String cvsSplitBy = ",";

        try {

            File f = null;

            URL resource = GeoCsvReader.class.getResource(fileName);

            String newFilePath = resource.getFile();

            System.out.println("Found URL " + resource + ", and file " + newFilePath + ", exists: " + new File(newFilePath).exists());

            //br = new BufferedReader(new FileReader(newFilePath));
            br = new BufferedReader(new InputStreamReader(GeoCsvReader.class.getResourceAsStream(fileName)));

            while ((line = br.readLine()) != null) {

                    // use comma as separator
                String [] elements = line.split(cvsSplitBy);

                GeoCoords gc = new GeoCoords();
                gc.lat = Double.valueOf(elements[1].trim());
                gc.lon = Double.valueOf(elements[0].trim());

                //System.out.println("Read geo " + gc);

                list.add(gc);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

        System.out.println("Done");

        return list;
    }

}
