package hello;

/**
 * Created by gborza on 05/04/2014.
 */

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;

@Service
public class CustomService {

    @Autowired
    private BikeRepository bikeRepository;

    @Autowired
    private PersonRepository personRepository;

    @Autowired
    private StationRepository stationRepository;

    @Transactional
    public void bindPersonAndBike(final long bikeId, final long personId) {
        final Bike bike = bikeRepository.findOne(bikeId);
        final Person person = personRepository.findOne(personId);
        person.setLastBike(bike);
        personRepository.save(person);
    }

    @Transactional
    public void takeOrLeaveBikeAtStation(long bikeId, long stationId, int delta, long userId) {

        BikeStatus status = null;

        if (delta > 0) {
            status = BikeStatus.Free;
        } else {
            status = BikeStatus.Taken;
        }

        bikeRepository.updateStatusForBikeId(bikeId, status);

        stationRepository.updateAvailableBikesForStation(stationId, delta);

        //  Take away the bike from the station => add the bike to the user
        if (status == BikeStatus.Taken) {
            bindPersonAndBike(userId, bikeId);
        }
    }

}
