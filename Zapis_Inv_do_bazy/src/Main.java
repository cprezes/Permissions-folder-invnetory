
import java.util.List;
import java.util.Properties;
import java.util.concurrent.TimeUnit;

public class Main {

	private static Properties seetings;
	private static MysqlModel mysqlModel;

	public static void main(String[] args) throws Exception {

		Proerties proerties = new Proerties("config.txt");
		if (proerties.check()) {
			seetings = proerties.load(true);
		} else {
			proerties.make();
			System.exit(0);
		}

		mysqlModel = new MysqlModel(seetings);
		mysqlModel.init();

		FolderReder folderReader = new FolderReder(proerties.getFolder());

		for (int iter = 0; iter < 10; iter++) {
			List<String> folderList = folderReader.list();

			if (folderList.size() > 2) {
				fileMainUtil(folderList);
				fileDeleteList(folderList);
				iter = 0;
			} else {
				System.out.println("Czekam na pliki w katalogu  " + proerties.getFolder());
				TimeUnit.SECONDS.sleep(5);

			}
		}
		mysqlModel.disconnect();
	}

	private static void fileMainUtil(List<String> fileList) throws Exception {

		for (String file : fileList) {

			sendToDB(FileOperator.readFile(file));
		}

	}

	private static void fileDeleteList(List<String> fileList) {
		for (String file : fileList) {
			FileOperator.deleteFile(file);
		}
	}

	private static void sendToDB(List<String> fileRows) {
		boolean headFlag = false;
		String head = "";

		for (String elem : fileRows) {
			if (elem.length() > 0) {
				if (headFlag) {
					mysqlModel.save(head, elem);
					// System.out.println(head + "------" + elem);

				} else {
					headFlag = true;
					head = elem;
				}
			}

		}
	}

}
