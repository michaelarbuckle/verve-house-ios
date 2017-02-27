package house.verve.model;
import java.util.Date;

import java.util.List;
import lombok.Data;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.DBRef;

/*
 *  {
                        "$group" : {
                                "_id" : {
                                        "year" : {
                                                "$year" : [
                                                        "$created_on"
                                                ]
                                        },
                                        "dayOfYear" : {
                                                "$dayOfYear" : [
                                                        "$created_on"
                                                ]
                                        },
                                        "hour" : {
                                                "$hour" : [
                                                        "$created_on"
                                                ]
                                        },
                                        "minute" : {
                                                "$minute" : [
                                                        "$created_on"
                                                ]
                                        },
                                        "second" : {
                                                "$second" : [
                                                        "$created_on"
                                                ]
                                        }
                                },
                                "count" : {
                                        "$sum" : {
                                                "$const" : 1
                                        }
                                },
                                "avg" : {
                                        "$avg" : "$value"
                                },
                                "min" : {
                                        "$min" : "$value"
                                },
                                "max" : {
                                        "$max" : "$value"
                                }  
    private void saveStatistics(MeterEvent event){
        long trim = event.getDate().getTime()%86400000;
        DBObject query = BasicDBObjectBuilder.start()
                .append("date", new Date(event.getDate().getTime()-trim))
                .append("source", event.getSource())
                .get();
        DBObject inc = BasicDBObjectBuilder.start()
                .append("daily", 1)
                .append("hourly."+((Integer)event.getDate().getHours()).toString(),1)
                .append("minutely."+event.getDate().getHours()+"."+((Integer)event.getDate().getMinutes()).toString(),1)
                .get();
        BasicDBObject update = new BasicDBObject("$inc", inc);
        statistics.update(query, update, true, false);
    }
 */
@Data
public class Timeseries {

	public Sensor getSensor() {
		return sensor;
	}

	public void setSensor(Sensor sensor) {
		this.sensor = sensor;
	}

	@DBRef(lazy=true)
	Sensor sensor;
	@Id private String id;
	// use id = device +":"+sensor +":" + timestamp to handle range queries   ie   "1001:161101"  for november first
	
	Date start; 
	//List<Float> values ;
	day day;
	
	public class day {
		
		float h0;
		float h1;
		float h2;
		float h3;
		float h4;
		float h5;
		float h6;
		float h7;
		float h8;
		float h9;
		float h10;
		float h11;
		float h12;
		float h13;
		float h14;
		float h15;
		float h16;
		float h17;
		float h18;
		float h19;
		float h20;
		float h21;
		float h22;
		float h23;	
		float max;
		float min;
		float avg;
	}
	
}
