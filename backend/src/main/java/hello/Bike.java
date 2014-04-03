package hello;

import com.sun.istack.internal.NotNull;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.util.Date;
import java.util.Random;

@Entity
@EntityListeners(value = { AuditingEntityListener.class } )
public class Bike {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private long id;

    @NotNull
    private String city;

    @NotNull
    private Status status;

    @NotNull
    private String lat;

    @NotNull
    private String lon;

    @CreatedDate
    private Date createDate;

    @LastModifiedDate
    private Date updateDate;

    static enum Status {
        Free,
        Taken,
        OutOfOrder
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
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

    public String getLat() {
        return lat;
    }

    public void setLat(String lat) {
        this.lat = lat;
    }

    public String getLon() {
        return lon;
    }

    public void setLon(String lon) {
        this.lon = lon;
    }

    /**
     *  Just generate a random {@link hello.Bike}.
     */
    public static Bike rand() {
        final int i = Math.abs(new Random().nextInt());
        final Bike b = new Bike();
        b.city = "Cluj-Napoca-" + i;
        b.status = Status.Free;
        b.lat = "lat";
        b.lon = "lon";
        return b;
    }

}
