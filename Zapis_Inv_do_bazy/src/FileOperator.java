
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;


public class FileOperator {

	
	/**
	 * @param path
	 * @return List - line by line
	 * @throws IOException
	 * 
	 * Read file by line with setup code page. 
	 */
	public static List<String> readFile(String path) throws IOException {
		List<String> list = new ArrayList<String>();
		BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(path), "Cp1250"));
		try {
			String line = br.readLine();

			while (line != null) {
				list.add(line);
				line = br.readLine();
			}

		} finally {
			br.close();
		}
		return list;
	}

	/**
	 * @param path
	 * @return List - line by line 
	 * @throws Exception
	 * 
	 * Read file by name with use  Scanner and default code page.
	 */
	public static List<String> readFileScanner(String path) throws Exception {
		List<String> list = new ArrayList<String>();
		File file = new File(path);
		Scanner sc = new Scanner(file);
		while (sc.hasNextLine()) {

			list.add(sc.nextLine());
		}
		sc.close();

		return list;
	}

	/**
	 * @param path
	 * @return
	 * 
	 * Try true delete file.
	 * Warning if you try delete actual use file.   
	 * I have nether used System.gc(). But here, in my case, it is absolutely crucial. 
	 */
	public static boolean deleteFile(String path) {
		File file = new File(path);
		if (file.exists()) {
			if (file.delete()) {
				return true;

			} else {
				try {
			    System.gc(); // sometime file is opened in JAVA we need run garbage collector to cut connection
				deleteFile(path);  // recursive delete
				}catch (Exception e) {
					System.out.println(e);
				}

				}
		} else {
			return true;
		}
		return false;

	}
}
