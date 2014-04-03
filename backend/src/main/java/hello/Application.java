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
import java.util.Arrays;
import java.util.Collection;
import java.util.Random;
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

        Bike b1 = new Bike();
        b1.setCity("Cluj");
        b1.setStatus(Bike.Status.Free);
        b1.setLat(45.0);
        b1.setLon(25.0);

        Bike b2 = new Bike();
        b2.setCity("Pitesti");
        b2.setStatus(Bike.Status.Free);
        b2.setLat(46.0);
        b2.setLon(23.0);

        bikeRepository.save(b1);
        bikeRepository.save(b2);

        Station s1 = new Station();
        s1.setCity("Cluj");
        s1.setLat(46.776476);
        s1.setLon(23.606685);
        s1.setAvailableBikes(5);
        stationRepository.save(s1);

        for (int i = 0; i < 5; i++) {
            Bike bike = new Bike();
            bike.setCity("Cluj");
            bike.setLat(46.776476);
            bike.setLon(23.606685);
            bike.setStatus(Bike.Status.Free);
            bikeRepository.save(bike);
        }



	}

    static class MoveBikesAroundRunnable implements Runnable {

        final BikeRepository bikeRepository;

        final double deltaMax = 0.01;

        MoveBikesAroundRunnable(BikeRepository bikeRepository) {
            this.bikeRepository = bikeRepository;
        }

        @Override
        public void run() {

            System.out.println("Moving bikes...");

            final Random random = new Random();
            final Iterable<Bike> bikesCollection = bikeRepository.findAll();


            for (final Bike b : bikesCollection) {
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
            }

            bikeRepository.save(bikesCollection);
        }


    }

}
