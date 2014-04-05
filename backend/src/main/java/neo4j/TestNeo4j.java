package neo4j;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.neo4j.config.EnableNeo4jRepositories;

/**
 * Application launcher and config class at the same time.
 */
@Configuration
//@EnableJpaRepositories
@EnableAutoConfiguration
@ComponentScan
@EnableNeo4jRepositories
//@EnableJpaAuditing
public class TestNeo4j {

    public static void main(String[] args) {
        //  Run the application. We an also get the app context out of the method.
//        ApplicationContext ctx = SpringApplication.run(TestNeo4j.class, args);

//        final BuddyRepository buddyRepository = ctx.getBean(BuddyRepository.class);
//
//        Buddy b1 = new Buddy("dude");
//        Buddy b2 = new Buddy("b2");
//        Buddy b3 = new Buddy("b3");
//
//        b1.addBuddy(b2);
//        b2.addBuddy(b3);
//
//        buddyRepository.save(b1);
    }

}
