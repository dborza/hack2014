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

        Station s1 = new Station();
        s1.setCity("Cluj");
        s1.setLat(46.776476);
        s1.setLon(23.606685);
        s1.setAvailableBikes(5);
        stationRepository.save(s1);

        Station s2 = new Station();
        s2.setCity("Cluj");
        s2.setLat(46.762813);
        s2.setLon(23.577983);
        s2.setAvailableBikes(0);

        stationRepository.save(s2);

        for (int i = 0; i < 5; i++) {
            Bike bike = new Bike();
            bike.setCity("Cluj");
            bike.setLat(46.776476 + 0.00001 * i);
            bike.setLon(23.606685);
            bike.setStatus(Bike.Status.Free);
            bike.setGender(Bike.Gender.Female);
            bike.setType(Bike.Type.CityBike);
            bike.setColor(Bike.Color.Red);
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

        for (int i = 8; i <= 9; i++) {
            Bike bike = new Bike();
            bike.setCity("Cluj");
            bike.setLat(0);
            bike.setLon(0);
            bike.setStatus(Bike.Status.Taken);
            bike.setGender(Bike.Gender.Male);
            bike.setType(Bike.Type.CityBike);
            bike.setColor(Bike.Color.Blue);
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

            geoCoordinates.put(8L, new GeoCsvReader().run("/geo1.csv"));
            geoCoordinates.put(9L, new GeoCsvReader().run("/geo2.csv"));
            currentPositions.put(8L, 0);
            currentPositions.put(9L, 0);

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
