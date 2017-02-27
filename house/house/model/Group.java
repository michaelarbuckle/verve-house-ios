package house.verve.model;

import java.util.Set;

import org.springframework.data.annotation.Id;

public class Group {
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
	private Set<String> objectSet;
}
