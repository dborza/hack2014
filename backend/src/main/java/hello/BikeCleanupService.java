package hello;

/**
 * A scheduler that makes sure that bikes have the proper status
 *
 * Created by gborza on 05/04/2014.
 */

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.LinkedList;

@Service
public class BikeCleanupService {

    @Autowired
    private BikeRepository bikeRepository;

    //  10 minutes
    private final long TEN_MINUTES_IN_MILLIS = 10 * 60 * 1000;

//    @Scheduled(fixedDelay = 10000)
    public void run() {

        final long currentTime = System.currentTimeMillis();

        System.out.println(">>>> Cleaning up bike status @" + currentTime);

        final Collection<Bike> reservedBikes = bikeRepository.findByStatus(BikeStatus.Reserved);

        final Collection<Bike> bikesToUpdate = new LinkedList<Bike>();

        for (final Bike b : reservedBikes) {
            //  If we reserved the bike more than 10 minutes ago
            if (b.getUpdateDate().getTime() + TEN_MINUTES_IN_MILLIS <= currentTime) {
                System.out.println(">>>> This bike will be marked as free: " + b.getId());
                b.setStatus(BikeStatus.Free);
                bikesToUpdate.add(b);
            }
        }

        bikeRepository.save(bikesToUpdate);
    }

}
