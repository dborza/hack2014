package hello;

import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(collectionResourceRel = "stations", path = "stations")
public interface StationRepository extends PagingAndSortingRepository<Station, Long> {
}
