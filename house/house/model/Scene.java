package house.verve.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import java.util.Set;
import java.util.Map;
import lombok.Data;

@Data
@Document(collection = "scenes")
public class Scene {
	 public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	 
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	@Id private String id;

	private String name;
	private Set<Action> actionSet;
	private Map<String,Action> actionSequence;
}
