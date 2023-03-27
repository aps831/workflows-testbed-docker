package com.aps.work.testbeddocker;

public class Calculator {

    public static void main(String[] args) {
        Calculator calculator = new Calculator();
        System.out.println("Calculator: 2 + 1 = " + calculator.add(2, 1));
    }

	public int add(int a, int b) {
		return a + b;
	}

}
