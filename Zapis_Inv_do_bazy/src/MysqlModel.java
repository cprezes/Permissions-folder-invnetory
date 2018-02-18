import java.sql.SQLException;
import java.sql.Statement;
import java.util.Properties;

public class MysqlModel {
	private Properties connectionSetting;
	private MysqlConnect mysqlConnect;
	private Statement statement;
	private String guery;
	private int queryCount;

	public MysqlModel(Properties connection) {
		super();
		this.connectionSetting = connection;

	}

	public void init() {
		queryCount = 0;
		guery = "";
		mysqlConnect = new MysqlConnect();
		mysqlConnect.setConnection(connectionSetting);
		try {
			statement = mysqlConnect.connect().createStatement();
			initDb();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	private void execute(String sql) {
			try {
			statement.executeUpdate(sql);
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	public void save(String patch, String acl) {
		patch= patch.replace("\\","/");
		acl= acl.replace("\\","/");
		guery = guery + " INSERT INTO `acl` ( `path`, `acl`) VALUES ( \"" + patch + "\", \"" + acl + "\"); \n";

		queryCount++;

		if (queryCount > 100) {
			this.execute(guery);
			queryCount = 0;
			guery = "";
		}
	}

	private void initDb() {
		String sql = "CREATE TABLE IF NOT EXISTS `acl` "
				+ "(`id` bigint AUTO_INCREMENT PRIMARY KEY , `path` text COLLATE utf32_bin NOT NULL,"
				+ " `acl` text COLLATE utf32_bin NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf32 COLLATE=utf32_bin ; ";

		this.execute(sql);
		sql = "TRUNCATE TABLE `acl` ";

		this.execute(sql);
	}

	public void disconnect() {
		if (guery.length()>5) this.execute(guery);
		mysqlConnect.disconnect();
	}

}
