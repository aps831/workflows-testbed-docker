package unit.com.aps.work.testbedmaven;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.aps.work.testbeddocker.Calculator;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

@DisplayName("when adding two numbers")
class WhenAddingTwoNumbers {

	@Test
	@DisplayName("1 + 1 = 2")
	void addsTwoNumbers() {

        // Given
        int a = 1;
        int b = 1;
		Calculator calculator = new Calculator();

        // When
        int sum = calculator.add(a, b);

        // Then
		assertEquals(2, sum, "1 + 1 should equal 2");
	}

}
