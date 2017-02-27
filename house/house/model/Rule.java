package house.verve.model;

import org.springframework.data.annotation.Id;
import java.util.List;
import java.util.Map;

public class Rule {

	@Id private String id;

	 private String name;
	 private String description;
	 private List<String> whenList;
	 private List<String> thenList;
	 
/*
 * import com.sample.DroolsTest.Message;
 
rule "Hello World"
    when
        m : Sensor( units == Message.HELLO, myMessage : message )
    then
        System.out.println( myMessage );
        m.setMessage( "Goodbye cruel world" );//#message.setMessage
        m.setStatus( Message.GOODBYE );
        update( m );
end


space  inside, outside, underneath, on top, 
 */
	 
	 public String toString()
	 {
		 StringBuilder sb = new StringBuilder();
		 sb.append("rule \"").append(name).append("\" \n");
		 sb.append("	when \n");
		 for (String line: whenList)
				 sb.append(line).append("\n");
		 sb.append("	then \n");
		 for (String line: thenList)
			 sb.append(line).append("\n");		 
		 sb.append("end \n");

		 return sb.toString();		 
	 }
}
