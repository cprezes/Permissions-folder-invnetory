import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class MysqlConnect {
    private static final String DATABASE_DRIVER = "com.mysql.jdbc.Driver";
    private static  String DATABASE_URL ;
    private static  String USERNAME ;
    private static  String PASSWORD ;
    private static  String MAX_POOL = "500";

    private Connection connection;

    private Properties properties;

    public void setConnection(Properties connection) {
    	DATABASE_URL= "jdbc:mysql://" + connection.getProperty("dbserwer")+":"+connection.getProperty("port")+"/"+ connection.getProperty("dbname")+"?allowMultiQueries=true&useUnicode=true&characterEncoding=UTF-8&characterSetResults=UTF-8";
    	USERNAME =connection.getProperty("dbuser");
    	PASSWORD=connection.getProperty("dbpassword");
	}
    
    

    private Properties getProperties() {
        if (properties == null) {
            properties = new Properties();
            properties.setProperty("user", USERNAME);
            properties.setProperty("password", PASSWORD);
            properties.setProperty("MaxPooledStatements", MAX_POOL);
        }
        return properties;
    }


    public Connection connect() {
        if (connection == null) {
            try {
                Class.forName(DATABASE_DRIVER);
                connection = DriverManager.getConnection(DATABASE_URL, getProperties());
            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
            }
        }
        return connection;
    }


    public void disconnect() {
        if (connection != null) {
            try {
                connection.close();
                connection = null;
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}

