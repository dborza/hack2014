package hello;

import com.sun.istack.internal.NotNull;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.annotation.LastModifiedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import javax.persistence.*;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Random;

@Entity
@EntityListeners(value = { AuditingEntityListener.class } )
public class Person {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private long id;

    @NotNull
	private String firstName;

    @NotNull
	private String lastName;

    @CreatedDate
    private Date createDate;

    @LastModifiedDate
    private Date updateDate;

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
