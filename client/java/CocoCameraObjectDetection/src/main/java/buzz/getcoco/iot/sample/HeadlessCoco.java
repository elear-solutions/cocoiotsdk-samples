package buzz.getcoco.iot.sample;

import buzz.getcoco.iot.CapabilitySnapshot;
import buzz.getcoco.iot.CocoClient;
import buzz.getcoco.iot.Device;
import buzz.getcoco.iot.Network;
import buzz.getcoco.iot.PlatformInterface;
import buzz.getcoco.iot.Resource;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicBoolean;

public class HeadlessCoco implements PlatformInterface {
  private final Inferrer inferrer;
  private final AtomicBoolean condition;

  public HeadlessCoco(Inferrer inferrer) {
    this.inferrer = inferrer;
    this.condition = new AtomicBoolean(true);
  }

  public void startDetection(String networkId, String inviteUrl, long nodeId) {
    // Configuring Cococlient
    new CocoClient.Configurator().withPlatform(this).configure();

    // CocoClient.getInstance().getSavedNetworks()

    // Connecting to network using invite url, networkId and nodeId
    new Network.ConnectArgs()
        .setNetworkId(networkId)
        .setInviteUrl(inviteUrl)
        .setNodeId(nodeId)
        .setNetworkName("S R K")
        .setNetworkType(Network.NetworkType.IOT)
        .setUserRole(Network.UserRole.ADMIN)
        .setAccessType(Network.AccessType.REMOTE)
        .connect();

    Network network = CocoClient.getInstance().getNetwork(networkId);

    // Waiting for connected state
    while (network.getState().isConnecting()) {
      System.out.println("Network state: " + network.getState());
      Utils.sleep(1_000);
    }

    assert network.getState().isConnected();

    condition.set(true);

    // Searches for camera resource and fetches capability of first camera found
    CapabilitySnapshot capability = waitAndGetCamera(network);

    if (null == capability) {
      System.out.println("no camera found");
      return;
    }

    // Start the model for object detection.
    inferrer.start();

    System.out.println("Starting Detection, network status: " + network.getState());

    // Captures snapshots for every 60 seconds
    while (condition.get()) {
      Utils.sleep(60_000);
      String uuid = UUID.randomUUID().toString();
      capability.captureSnapshot(String.format("/tmp/coco/snapshots/%s", uuid), 0, 0, 10_000, inferrer); // TODO: update resolution 320x240/640x360/ 1920x1080
    }

    inferrer.close();
  }

  // Stops capturing
  public void stopDetection() {
    condition.set(false);
  }

  private CapabilitySnapshot waitAndGetCamera(Network network) {
    while (condition.get()) {
      System.out.println("waiting for resources");

      for (Device device : network) {
        for (Resource resource : device) {
          if (resource.containsCapability(CapabilitySnapshot.ID)) {
            return resource.getCapability(CapabilitySnapshot.ID);
          }
        }
      }

      Utils.sleep(1_000);
    }

    return null;
  }

  @Override
  public String getCwdPath() {
    return "/tmp/coco/data";
  }

  @Override
  public String getClientId() {
    return "dummy";
  }

  @Override
  public String getAppAccessList() {
    return  "{\"appCapabilities\": [0, 1, 2]}";
  }

  @Override
  public void authCallback(String authorizationEndpoint, String tokenEndpoint) {

  }
}
