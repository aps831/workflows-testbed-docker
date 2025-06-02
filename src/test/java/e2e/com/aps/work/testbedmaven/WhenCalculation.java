package e2e.com.aps.work.testbedmaven;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.testcontainers.containers.GenericContainer;
import org.testcontainers.containers.output.OutputFrame;
import org.testcontainers.containers.wait.strategy.Wait;
import org.testcontainers.utility.DockerImageName;

import static org.junit.jupiter.api.Assertions.assertEquals;

@DisplayName("when calculating")
class WhenCalculation {

    private static final String IMAGE_NAME = "registry.local:5000/workflows-testbed-docker/testbed-docker:latest";

    private GenericContainer<?> container;

    @BeforeEach
    void setUp() {
        container = new GenericContainer<>(DockerImageName.parse(getImageName()))
            .waitingFor(Wait.forLogMessage(".*", 1));;
        container.start();
    }

    @AfterEach
    void tearDown() {
        container.stop();
    }

    private static String getImageName() {
        String imageName = System.getenv("IMAGE_UNDER_TEST_NAME");
        return  (imageName != null) ? imageName : IMAGE_NAME;
    }

    @Test
	@DisplayName("should output calculation")
	void shouldOutputCalculation() throws InterruptedException {

        // Given

        // When
        String log = container.getLogs(OutputFrame.OutputType.STDOUT);

        // Then
		assertEquals("Calculator: 2 + 1 = 3\n", log, "should output calculation");
	}

}
