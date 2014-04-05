package neo4j;

import org.springframework.data.neo4j.repository.GraphRepository;
import org.springframework.stereotype.Repository;

/**
 * Created by gborza on 05/04/2014.
 */
@Repository
public interface BuddyRepository extends GraphRepository<Buddy> {

    Buddy findByName(String name);

    Iterable<Buddy> findByTeammatesName(String name);

}