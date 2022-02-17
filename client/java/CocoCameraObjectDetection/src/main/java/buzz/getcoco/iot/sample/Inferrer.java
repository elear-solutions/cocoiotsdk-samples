package buzz.getcoco.iot.sample;

import ai.djl.Application;
import ai.djl.MalformedModelException;
import ai.djl.inference.Predictor;
import ai.djl.modality.cv.Image;
import ai.djl.modality.cv.ImageFactory;
import ai.djl.modality.cv.output.DetectedObjects;
import ai.djl.repository.zoo.Criteria;
import ai.djl.repository.zoo.ModelNotFoundException;
import ai.djl.repository.zoo.ZooModel;
import ai.djl.translate.TranslateException;
import buzz.getcoco.iot.CapabilitySnapshot;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Objects;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;

public class Inferrer implements CapabilitySnapshot.SnapshotListener, AutoCloseable {

  private Criteria<Image, DetectedObjects> criteria;
  private ExecutorService service;
  private AtomicBoolean stop;

  // Sets up necessary model criteria and executor service
  public void start() {
    if (null != criteria) {
      throw new RuntimeException("already started");
    }

    this.stop = new AtomicBoolean(false);

    this.criteria = Criteria.builder()
        .optApplication(Application.CV.OBJECT_DETECTION)
        .setTypes(Image.class, DetectedObjects.class)
        .optFilter("backbone", "resnet50")
        .build();

    service = Executors.newWorkStealingPool(5);
  }

  @Override
  public void onSnapshotCaptured(String filePath, int status) {
    if (CapabilitySnapshot.SnapshotStatus.SUCCESS != status) {
      System.out.println("snapshot status: " + status);
      return;
    }

    if (!stop.get()) {
      service.submit(() -> infer(filePath));
    }
  }

  // Uses JDL for object detection
  private void infer(String imagePath) {
    Objects.requireNonNull(imagePath);

    File imageFile = new File(imagePath);

    try (ZooModel<Image, DetectedObjects> model = criteria.loadModel();
         Predictor<Image, DetectedObjects> predictor = model.newPredictor()) {

      Image image = ImageFactory.getInstance()
          .fromInputStream(new FileInputStream(imagePath));

      DetectedObjects result = predictor.predict(image);

      System.out.println("result: " + result);
      imageFile.delete();
    } catch (TranslateException | IOException | ModelNotFoundException | MalformedModelException | NullPointerException e) {
      e.printStackTrace();
    }
  }

  // Shuts down the service
  @Override
  public void close() {
    stop.set(true);

    if (null != service) {
      service.shutdown();
    }
  }
}
