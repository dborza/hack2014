package hello;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 *  A custom REST controller for our API, jut in case we don't want to rely only on the auto generated stuff.
 */
@RestController
@RequestMapping("/api")
public class CustomController {

    @Autowired
    private PersonRepository personRepository;

    @Autowired
    private BikeRepository bikeRepository;

    @RequestMapping(
            value="/addRandomPerson",
            method= RequestMethod.GET,
            produces={"application/json"})
    @ResponseStatus(HttpStatus.OK)
    public Person addRandomPerson() {

        //  Save a randomly generated entity and also return it from the controller method.
        //  The controller will automatically return the json form for this entity.
        return personRepository.save(Person.rand());
    }

    @RequestMapping(
            value="/addRandomBike",
            method= RequestMethod.GET,
            produces={"application/json"})
    @ResponseStatus(HttpStatus.OK)
    public Bike addRandomBike() {

        //  Save a randomly generated entity and also return it from the controller method.
        //  The controller will automatically return the json form for this entity.
        return bikeRepository.save(Bike.rand());
    }

    @RequestMapping(
            value="/nearest/{lon}/{lat}",
            method= RequestMethod.GET,
            produces={"application/json"})
    @ResponseStatus(HttpStatus.OK)
    public Bike getNearestBike(@PathVariable("lon") double lon, @PathVariable("lat") double lat) {

        List<Bike> bikes = bikeRepository.getNearestBike(lon, lat);
        if (bikes.size() > 0) {
            return bikes.get(0);
        } else {
            return null;
        }
    }

    @RequestMapping(
            value="/updateCoordinates/{bikeId}",
            method= RequestMethod.PUT,
            produces={"application/json"})
    @ResponseStatus(HttpStatus.OK)
    public void updateGeoCoordinates(@PathVariable("bikeId") long bikeId, @RequestParam("lon") double lon, @RequestParam("lat") double lat) {

        bikeRepository.updateGeoCoordinates(bikeId, lon, lat);
    }

}
