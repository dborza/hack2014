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
	}

}
