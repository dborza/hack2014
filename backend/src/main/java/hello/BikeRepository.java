package hello;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@RepositoryRestResource(collectionResourceRel = "bikes", path = "bikes")
public interface BikeRepository extends PagingAndSortingRepository<Bike, Long> {

	List<Bike> findByCity(@Param("city") String city);

    List<Bike> findByStatus(@Param("status") Bike.Status status);

    @Modifying
    @Transactional
    @Query(value = "update hello.Bike b set b.city = ?1 where b.id = ?2")
    int setCityFor(String city, Long id);

    @Transactional
    @Query(value = "select b from hello.Bike b order by (b.lon - ?1) * (b.lon - ?1) + (b.lat - ?2) * (b.lat - ?2) asc")
    List<Bike> getNearestBike(double lon, double lat);

    @Transactional
    @Query(value = "select b from hello.Bike b " +
            "where (b.status=:status or :status is null) " +
            "and (b.shoppingBasket=:shoppingBasket or :shoppingBasket is null)" +
            "and (b.childrenSeat=:childrenSeat or :childrenSeat is null) " +
            "and (b.gender=:gender or :gender is null) " +
            "and (b.type=:type or :type is null) " +
            "and (b.color=:color or :color is null) " +
            "order by (b.lon - :lon) * (b.lon - :lon) + (b.lat - :lat) * (b.lat - :lat) asc")
    List<Bike> getNearestMatchingBike(@Param("lon") double lon, @Param("lat") double lat,
          @Param("status") Bike.Status status, @Param("shoppingBasket") Boolean shoppingBasket,
          @Param("childrenSeat") Boolean childrenSeat, @Param("gender") Bike.Gender gender,
          @Param("type") Bike.Type type, @Param("color") Bike.Color color);


    @Modifying
    @Transactional
    @Query(value = "update hello.Bike b set b.lon = ?2, b.lat = ?3 where b.id = ?1")
    void updateGeoCoordinates(long bikeId, double lon, double lat);

    @Modifying
    @Transactional
    @Query(value = "update hello.Bike b set b.status = :status where b.id = :id")
    void updateStatusForBikeId(@Param("id") long bikeId, @Param("status") Bike.Status status);

    List<Bike> findByStatusAndShoppingBasketAndChildrenSeatAndGenderAndType(
            @Param("status") Bike.Status status, @Param("shoppingBasket") boolean shoppingBasket,
            @Param("childrenSeat") boolean childrenSeat, @Param("gender") Bike.Gender gender,
            @Param("type") Bike.Type type, @Param("color") Bike.Color color);
}
