import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Properties;

public class Proerties {

	private static String fileName;
	private static Properties prop;

	public Proerties(String fileName) {
		Proerties.fileName = fileName;
	}

	
	
	public boolean check() {

		File file = new File(fileName);
		if (!file.exists()) {

			return false;
		} else {
			return true;

		}

	}

	public void make() {

		prop = new Properties();
		OutputStream output = null;

		try {

			output = new FileOutputStream(fileName);

			// set the properties value
			prop.setProperty("dbname", "test");
			prop.setProperty("dbserwer", "localhost");
			prop.setProperty("dbuser", "root");
			prop.setProperty("dbpassword", "");
			prop.setProperty("port", "3306");
			prop.setProperty("info", "Baza danych musi istniec, tabela zostanie utwoorzona bedzie nazywac sie acl");
			prop.setProperty("scanPaht", "C:/tmp");

			// save properties to project root folder
			prop.store(output, null);

		} catch (IOException io) {
			io.printStackTrace();
		} finally {
			if (output != null) {
				try {
					output.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

		}
	}

	public  Properties load(boolean show) {

		prop = new Properties();
		InputStream input = null;

		try {

			input = new FileInputStream(fileName);

			// load a properties file
			prop.load(input);
			if (show) {
			// get the property value and print it out
			System.out.println(prop.getProperty("dbserwer"));
			System.out.println(prop.getProperty("dbname"));
			System.out.println(prop.getProperty("dbuser"));
			System.out.println(prop.getProperty("dbpassword"));
			System.out.println(prop.getProperty("port"));
			System.out.println(prop.getProperty("scanPaht"));
			}
		} catch (IOException ex) {
			ex.printStackTrace();
		} finally {
			if (input != null) {
				try {
					input.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return prop;

	}
	public String getFolder() {
	return	prop.getProperty("scanPaht");

	}
}
