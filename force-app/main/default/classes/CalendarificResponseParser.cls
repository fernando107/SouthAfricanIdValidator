public class CalendarificResponseParser {
    public cls_meta meta;
	public cls_response response;
	public class cls_meta {
		public Integer code;
	}
	public class cls_response {
		public cls_holidays[] holidays;
	}
	public class cls_holidays {
		public String name;	
		public String description;	
		public cls_country country;
		public date_z date_z;
		public String[] type;
		public String locations;
		public String states;
	}
	public class cls_country {
		public String id;
		public String name;
	}
	public class date_z {
		public String iso;
		public datetime_z datetime_z;
	}
	public class datetime_z {
		public Integer year;
		public Integer month;
		public Integer day;
	}
	public static CalendarificResponseParser parse(String json){
        system.debug('response4-->');
		return (CalendarificResponseParser) System.JSON.deserialize(json, CalendarificResponseParser.class); 
	}
}
