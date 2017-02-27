package house.verve.model;

import org.springframework.data.annotation.Id;

public class TopicSubscription {

	@Id private String id;
	 private String topic;
	 private String active;

}
