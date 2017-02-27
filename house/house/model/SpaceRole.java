package house.verve.model;
import java.util.Date;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.TextScore;

@Data
public class SpaceRole {

 
	public User getUser() {
		return user;
	}
	public void setUser(User user) {
		this.user = user;
	}
	public Space getSpace() {
		return space;
	}
	public void setSpace(Space space) {
		this.space = space;
	}
	public String getId() {
		return id;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	@Id private String id;

	@DBRef(lazy = true)
//	@JsonDeserialize(using = DBRefDeserializer.class)
//	@JsonSerialize(using = DBRefSerializer.class)
	private User user;
	
	@DBRef(lazy = true)
//	@JsonDeserialize(using = SpaceDeserializer.class)
//	@JsonSerialize(using = SpaceSerializer.class)
	private Space space;
	private String role;
	private Date endDate;

}
