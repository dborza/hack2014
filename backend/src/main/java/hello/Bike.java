package hello;

import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.util.Date;
import java.util.Random;

@Entity
@EntityListeners(value = {AuditingEntityListener.class})
public class Bike {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private long id;

    private String city;

    private BikeStatus status;

    private double lat;

    private double lon;

    private boolean shoppingBasket;

    private boolean childrenSeat;

    private Gender gender;

    private Type type;

    private Color color;

    @OneToOne(mappedBy = "lastBike", cascade = CascadeType.ALL)
    private Person lastUser;

    @CreatedDate
    private Date createDate;

    @LastModifiedDate
    private Date updateDate;

    static enum Color {
        //Red, Cyan, Blue, Purple, Yellow, Lime, Magenta, White, Silver, Gray, Black, Orange, Brown, Green
        DarkBlue, Blue, Orange, Red, Yellow, Green
    }

    static enum Gender {
        Male,
        Female,
        Unisex
    }

    static enum Type {
        CityBike, MountainBike, CruiserBike
    }

    private long bikeId;

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

    public BikeStatus getStatus() {
        return status;
    }

    public void setStatus(BikeStatus status) {
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

    public double getLat() {
        return lat;
    }

    public void setLat(double lat) {
        this.lat = lat;
    }

    public double getLon() {
        return lon;
    }

    public void setLon(double lon) {
        this.lon = lon;
    }

    public long getBikeId() {
        return id;
    }

    public void setBikeId(long bikeId) {

    }

    public boolean isShoppingBasket() {
        return shoppingBasket;
    }

    public void setShoppingBasket(boolean shoppingBasket) {
        this.shoppingBasket = shoppingBasket;
    }

    public boolean isChildrenSeat() {
        return childrenSeat;
    }

    public void setChildrenSeat(boolean childrenSeat) {
        this.childrenSeat = childrenSeat;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public Type getType() {
        return type;
    }

    public void setType(Type type) {
        this.type = type;
    }

    public Person getLastUser() {
        return lastUser;
    }

    public void setLastUser(Person lastUser) {
        this.lastUser = lastUser;
    }

    public Color getColor() {
        return color;
    }

    public void setColor(Color color) {
        this.color = color;
    }

    /**
     * Just generate a random {@link hello.Bike}.
     */
    public static Bike rand() {
        final Bike b = new Bike();
        b.city = "Cluj";
        b.status = BikeStatus.Free;
        b.lat = 46.778337;
        b.lon = 23.606102;
        return b;
    }

    private static Random random = new Random();

    public static Bike rand(double lat, double lon) {
        final Bike b = new Bike();
        b.city = "Cluj";
        b.status = BikeStatus.Free;
        b.lat = lat;
        b.lon = lon;
        b.childrenSeat = random.nextBoolean();
        b.shoppingBasket = random.nextBoolean();
        b.setColor(Color.values()[random.nextInt(Color.values().length)]);
        b.setType(Type.values()[random.nextInt(Type.values().length)]);
        b.setGender(Gender.values()[random.nextInt(Gender.values().length)]);

        return b;
    }


}
