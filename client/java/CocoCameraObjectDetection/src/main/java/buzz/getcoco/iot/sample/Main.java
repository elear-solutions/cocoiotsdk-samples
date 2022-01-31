package buzz.getcoco.iot.sample;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.Timer;
import java.util.TimerTask;

public class Main {
  public static void main(String[] args) throws Exception {
    String networkId = args[0];
    String inviteJsonFile = args[1];
    String inviteUrl;
    long nodeId;

    // retrieves the nodeId and invite Url from generated invite json.
    try(FileInputStream fis = new FileInputStream(inviteJsonFile);
        Reader reader = new InputStreamReader(fis)) {

      JsonObject jo = JsonParser.parseReader(reader).getAsJsonObject();

      inviteUrl = jo.get("nodeInvite").getAsString();
      nodeId = jo.get("nodeId").getAsLong();
    }

    System.out.println("inviteUrl: " + inviteUrl + "\nnodeId: " + nodeId);

    Inferrer inferrer = new Inferrer();
    HeadlessCoco coco = new HeadlessCoco(inferrer);

    new Timer().schedule(new TimerTask() {
      @Override
      public void run() {
        coco.stopDetection();
      }
    }, 1000 * 60 * 60);

    coco.startDetection(networkId, inviteUrl, nodeId);
  }
}
