package neo4j;

import org.neo4j.graphdb.Direction;
import org.springframework.data.neo4j.annotation.Fetch;
import org.springframework.data.neo4j.annotation.GraphId;
import org.springframework.data.neo4j.annotation.NodeEntity;
import org.springframework.data.neo4j.annotation.RelatedTo;

import java.util.HashSet;
import java.util.Set;

/**
 * Created by gborza on 05/04/2014.
 */
@NodeEntity
public class Buddy {

    @GraphId
    private Long id;

    private String name;

    @RelatedTo(type="BUDDY", direction = Direction.BOTH)
    @Fetch
    public Set<Buddy> buddies = new HashSet<Buddy>();

    public Buddy() {}

    public Buddy(String name) {
        this.name = name;
    }

    public void addBuddy(Buddy newBuddy) {
        if (newBuddy == null) {
            return;
        }
        buddies.add(newBuddy);
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Buddy{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", buddies=" + buddies +
                '}';
    }
}
