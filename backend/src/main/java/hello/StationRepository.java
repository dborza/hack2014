package hello;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.transaction.annotation.Transactional;

@RepositoryRestResource(collectionResourceRel = "stations", path = "stations")
public interface StationRepository extends PagingAndSortingRepository<Station, Long> {

    @Modifying
    @Transactional
    @Query("update hello.Station s set s.availableBikes = s.availableBikes + ?2 where s.id = ?1")
    void updateAvailableBikesForStation(long stationId, int delta);

}
