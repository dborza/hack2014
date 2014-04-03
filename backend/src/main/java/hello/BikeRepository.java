package hello;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.List;

@RepositoryRestResource(collectionResourceRel = "bikes", path = "bikes")
public interface BikeRepository extends PagingAndSortingRepository<Bike, Long> {

	List<Bike> findByCity(@Param("city") String city);

    List<Bike> findByStatus(@Param("status") Bike.Status status);

    @Modifying
    @Query(value = "update hello.Bike b set b.status = ?1 where b.id = ?2")
    int setFixedFirstnameFor(String status, Long id);

}
