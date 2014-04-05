package hello;

import org.apache.commons.dbcp.BasicDataSource;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.data.rest.webmvc.config.RepositoryRestMvcConfiguration;
import org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseBuilder;
import org.springframework.jdbc.datasource.embedded.EmbeddedDatabaseType;

import javax.annotation.PostConstruct;
import javax.sql.DataSource;
import java.util.*;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Application launcher and config class at the same time.
 */
@Configuration
@EnableJpaRepositories
@Import(RepositoryRestMvcConfiguration.class)
@EnableAutoConfiguration
@ComponentScan
@EnableJpaAuditing
public class Application {

    /**
     * Factory method for obtaining a data source created from code.
     *
     * @return {@link DataSource} - real deal
     */
    @Bean
    public DataSource dataSource() {
        EmbeddedDatabaseBuilder builder = new EmbeddedDatabaseBuilder();
        return builder.setType(EmbeddedDatabaseType.H2).build();
    }

//    @Bean
//    public DataSource mySqlDataSource() {
//        BasicDataSource basicDataSource = new BasicDataSource();
//        basicDataSource.setDriverClassName("");
//        basicDataSource.setUrl("");
//        basicDataSource.setUsername("");
//        basicDataSource.setPassword("");
//        basicDataSource.setMaxActive(10);
//        return basicDataSource;
//    }

    public static void main(String[] args) {
        //  Run the application. We an also get the app context out of the method.
        ApplicationContext ctx = SpringApplication.run(Application.class, args);

        //  Bootstrap the app with some fake data
        BikeRepository bikeRepository = ctx.getBean(BikeRepository.class);
        StationRepository stationRepository = ctx.getBean(StationRepository.class);
        PersonRepository personRepository = ctx.getBean(PersonRepository.class);

        Bike b1 = new Bike();
        b1.setCity("Cluj");
        b1.setStatus(Bike.Status.OutOfOrder);
        b1.setLat(45.0);
        b1.setLon(25.0);
        b1.setColor(Bike.Color.Green);

        Bike b2 = new Bike();
        b2.setCity("Pitesti");
        b2.setStatus(Bike.Status.OutOfOrder);
        b2.setLat(46.0);
        b2.setLon(23.0);
        b2.setColor(Bike.Color.Green);


        double lat[] = {46.776476, 46.762818, 46.773947, 46.772161, 46.767428, 46.755772};
        double lon[] = {23.606685, 23.578850, 23.588507, 23.584161, 23.586227, 23.591817};


        for (int i = 0; i < lat.length; i++) {

            Station s1 = new Station();
            s1.setCity("Cluj");
            s1.setLat(lat[i]);
            s1.setLon(lon[i]);
            s1.setAvailableBikes(1);
            stationRepository.save(s1);

            Bike bike = new Bike();
            bike.setCity("Cluj");
            bike.setLat(lat[i]);
            bike.setLon(lon[i]);
            bike.setStatus(Bike.Status.Free);
            bike.setGender(Bike.Gender.values()[i % 3]);
            bike.setType(Bike.Type.values()[i % 3]);
            bike.setColor(Bike.Color.values()[i % 6]);
            bike.setChildrenSeat(i % 2 == 0);
            bike.setShoppingBasket(i % 3 == 0);
            bikeRepository.save(bike);
        }


        Person person = new Person();
        person.setFirstName("James");
        person.setLastName("Kirk");
        person.setLastBike(b1);

        b1.setLastUser(person);
        personRepository.save(person);

        bikeRepository.save(b1);
        bikeRepository.save(b2);


        //bikes moving on route
        //ID-s start with 8

        for (int i = 0; i < 12; i++) {
            Bike bike = new Bike();
            bike.setCity("Cluj");
            bike.setLat(0);
            bike.setLon(0);
            bike.setStatus(Bike.Status.Taken);
            bike.setGender(Bike.Gender.Male);
            bike.setType(Bike.Type.CityBike);
            bike.setColor(Bike.Color.values()[i % 6]);
            bikeRepository.save(bike);
        }

        //  Move the bikes around
        final ScheduledExecutorService scheduledExecutorService = Executors.newScheduledThreadPool(1);
        scheduledExecutorService.scheduleWithFixedDelay(new MoveBikesAroundRunnable(bikeRepository), 0, 1, TimeUnit.SECONDS);
    }

    static class MoveBikesAroundRunnable implements Runnable {

        final BikeRepository bikeRepository;

        final double deltaMax = 0.01;

        Map<Long, List<GeoCoords>> geoCoordinates = new HashMap<Long, List<GeoCoords>>();
        Map<Long, Integer> currentPositions = new HashMap<Long, Integer>();


        MoveBikesAroundRunnable(BikeRepository bikeRepository) {
            this.bikeRepository = bikeRepository;
            System.out.println("Reading routes...");

            for (int i = 1; i <= 12; i++) {
                geoCoordinates.put(7L + i, new GeoCsvReader().run("/geo" + i + ".csv"));
                currentPositions.put(7L + i, 0);
            }
        }

        @Override
        public void run() {

            System.out.println("Moving bikes...");

            final Random random = new Random();
            final Iterable<Bike> bikesCollection = bikeRepository.findAll();

            for (final Bike b : bikesCollection) {
                if (geoCoordinates.containsKey(b.getId())) {
                    List<GeoCoords> geoCoords = geoCoordinates.get(b.getId());
                    int currentPosition = currentPositions.get(b.getId());
                    GeoCoords coords = geoCoords.get(currentPosition);
                    currentPosition++;
                    if (currentPosition >= geoCoords.size()) {
                        currentPosition = 0;
                    }
                    currentPositions.put(b.getId(), currentPosition);
                    b.setLat(coords.lat);
                    b.setLon(coords.lon);
                    b.setStatus(Bike.Status.Taken);
                    System.out.println("Moving bike " + b.getId() + " to " + coords.lon + ", " + coords.lat + " (position " + currentPosition + ")");
                }
            }

/*
            for (final Bike b : bikesCollection) {

                if (b.getId() < 5) {
                    continue;
                }

                //  Don't allow the bikes to get 'below' (0, 0)
                if (b.getLat() < 0) {
                    b.setLat(90);
                }
                if (b.getLon() < 0) {
                    b.setLon(90);
                }
                final int i = random.nextInt(11) - 5;
                final int j = random.nextInt(11) - 5;
                b.setLat(b.getLat() - i * deltaMax);
                b.setLon(b.getLon() - j * deltaMax);
                b.setStatus(Bike.Status.Taken);
            }
*/
            bikeRepository.save(bikesCollection);
        }

    }

}
