import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class FolderReder {
private  String path;


	public FolderReder(String path) {
	super();
	this.path = path;
}


	public  List<String> list() throws Exception {
		 List<String> list = new ArrayList<String>();
			File folder = new File(path);
			File[] listOfFiles = folder.listFiles();
			for (File file : listOfFiles) {
			    if (file.isFile()) {
				        list.add(path+"/"+ file.getName());
			    }
			}
			
		return list;
			}
			
}
