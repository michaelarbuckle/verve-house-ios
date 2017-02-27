package house.verve.model;
 
import org.springframework.data.annotation.Id;

import com.google.common.base.Objects;

 

public class Thing {

	@Id private String id;

	private String  uuid;
    private String  name;
    private String  annotation;
    private String  landmark;
    private String  category;
    private String  imageUrl;
    private String  thumbnailUrl;
 //   private Image  thumbnail;
    private byte[] thumbnail;



	/**
	 * Two Things will generate the same hashcode if they have exactly the same
	 * values for their name and uuid.
	 * 
	 */
	@Override
	public int hashCode() {
		// Google Guava provides great utilities for hashing
		return Objects.hashCode(name, uuid);
	}

	/**
	 * Two Things are considered equal if they have exactly the same values for
	 * their name and uuid.
	 * 
	 */
	@Override
	public boolean equals(Object obj) {
		if (obj instanceof Thing) {
			Thing other = (Thing) obj;
			// Google Guava provides great utilities for equals too!
			return Objects.equal(name, other.name)
					&& Objects.equal(uuid, other.uuid);
		} else {
			return false;
		}
	}
}
