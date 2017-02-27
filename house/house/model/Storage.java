package house.verve.model;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.geo.GeoJsonPoint;
/*
 * Storage Containers, Shelving, Baskets and Organizers
 */
public class Storage {

	@Id private String id;
	private String name;
	GeoJsonPoint location;
}
