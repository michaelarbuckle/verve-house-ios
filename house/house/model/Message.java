package house.verve.model;

import org.springframework.data.annotation.Id;

public class Message {

	@Id private String id;
	 private String message;
	 private String topic;
	 
	 private String level;
	 private String spaceId;
	 private String activity;	 
}
