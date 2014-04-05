package hello;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.util.*;

@Entity
@EntityListeners(value = { AuditingEntityListener.class } )
public class Person {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private long id;

	private String firstName;

	private String lastName;

    private String email;

    private long personId;

    @OneToOne(cascade=CascadeType.ALL)
    @JoinColumn(name="PBIKE_ID")
    private Bike lastBike;

    @CreatedDate
    private Date createDate;

    @LastModifiedDate
    private Date updateDate;



    @ManyToMany(cascade={CascadeType.ALL})
    @JoinTable(name="BUDDIES",
            joinColumns={@JoinColumn(name="PERSON_ID")},
            inverseJoinColumns={@JoinColumn(name="BUDDY_ID")})
    private Set<Person> buddies = new HashSet<Person>();

    @ManyToMany(mappedBy="buddies")
    private Set<Person> mates = new HashSet<Person>();

    public Long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Date updateDate) {
        this.updateDate = updateDate;
    }

    public Bike getLastBike() {
        return lastBike;
    }

    public void setLastBike(Bike lastBike) {
        this.lastBike = lastBike;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Set<Person> getBuddies() {
        return buddies;
    }

    public void setBuddies(Set<Person> buddies) {
        this.buddies = buddies;
    }

    public Set<Person> getMates() {
        return mates;
    }

    public void setMates(Set<Person> mates) {
        this.mates = mates;
    }

    public long getPersonId() {
        return id;
    }

    public void setPersonId(long personId) {
    }

    /**
     *  Just generate a random {@link Person}.
     */
    public static Person rand() {
        final int i = Math.abs(new Random().nextInt());
        final Person p = new Person();
        p.setFirstName("cucu-" + i);
        p.setLastName("mucu-" + i);
        return p;
    }

}
