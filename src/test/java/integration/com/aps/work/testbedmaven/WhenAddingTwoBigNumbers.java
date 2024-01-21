package integration.com.aps.work.testbedmaven;

import com.aps.work.testbeddocker.Calculator;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

@DisplayName("when adding two big numbers")
class WhenAddingTwoBigNumbers {

	@Test
	@DisplayName("10 + 10 = 20")
	void addsTwoNumbers() {

        // Given
        int a = 10;
        int b = 10;
		Calculator calculator = new Calculator();

        // When
        int sum = calculator.add(a, b);

        // Then
		assertEquals(20, sum, "10 + 10 should equal 20");
	}

}
