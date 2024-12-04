public class SimpleCalculator {
    public Integer add(Integer a, Integer b) {
        return a + b;
    }

    public Integer subtract(Integer a, Integer b) {
        return a - b;
    }

    public Integer divide(Integer a, Integer b)   {
        if (b == 0) {
            return 0;
        }
        return a / b;
    }
}