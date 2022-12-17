import org.junit.*;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;
import java.io.*;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

public class Hw3Test1 {
  private int reg_sp = 0;
  private int reg_s0 = 0;
  private int reg_s1 = 0;
  private int reg_s2 = 0;
  private int reg_s3 = 0;
  private int reg_s4 = 0;
  private int reg_s5 = 0;
  private int reg_s6 = 0;
  private int reg_s7 = 0;

  @Rule
  public Timeout timeout = new Timeout(5000, TimeUnit.MILLISECONDS);

  @Before
  public void preTest() {
    this.reg_s0 = get(s0);
    this.reg_s1 = get(s1);
    this.reg_s2 = get(s2);
    this.reg_s3 = get(s3);
    this.reg_s4 = get(s4);
    this.reg_s5 = get(s5);
    this.reg_s6 = get(s6);
    this.reg_s7 = get(s7);
    this.reg_sp = get(sp);
  }

  @After
  public void postTest() {
    Assert.assertEquals("Register convention violated $s0", this.reg_s0, get(s0));
    Assert.assertEquals("Register convention violated $s1", this.reg_s1, get(s1));
    Assert.assertEquals("Register convention violated $s2", this.reg_s2, get(s2));
    Assert.assertEquals("Register convention violated $s3", this.reg_s3, get(s3));
    Assert.assertEquals("Register convention violated $s4", this.reg_s4, get(s4));
    Assert.assertEquals("Register convention violated $s5", this.reg_s5, get(s5));
    Assert.assertEquals("Register convention violated $s6", this.reg_s6, get(s6));
    Assert.assertEquals("Register convention violated $s7", this.reg_s7, get(s7));
    Assert.assertEquals("Register convention violated $sp", this.reg_sp, get(sp));
  }

  @Test
  public void verify_input_1() {
    int rows = 2;
    int cols = 3;
    int[] numbers = new int[] {82,212,3,34,56,1812};
    Label filename = asciiData(true, "inputs/input1.txt");
    Label buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, buffer);
    Assert.assertEquals(1, get(v0));
    Assert.assertEquals(rows, getWord(buffer, 0));
    Assert.assertEquals(cols, getWord(buffer, 4));
    for(int i = 2; i < 8; i++) {
      Assert.assertEquals(numbers[i-2], getWord(buffer, i*4));
    }
    for(int i = 8; i < 102; i++) {
      Assert.assertEquals(0, getWord(buffer, i*4));
    }
  }

  @Test
  public void verify_input_2() {
    int rows = 4;
    int cols = 5;
    int[] numbers = new int[] {129, 20, 1, 59, 109, 678, 223, 951, 99, 201, 9, 32, 731, 29, 49, 37, 393, 13332, 49, 33473};
    Label filename = asciiData(true, "inputs/input2.txt");
    Label buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, buffer);
    Assert.assertEquals(1, get(v0));
    Assert.assertEquals(rows, getWord(buffer, 0));
    Assert.assertEquals(cols, getWord(buffer, 4));
    for(int i = 2; i < 22; i++) {
      Assert.assertEquals(numbers[i-2], getWord(buffer, i*4));
    }
    for(int i = 22; i < 102; i++) {
      Assert.assertEquals(0, getWord(buffer, i*4));
    }
  }

  @Test
  public void verify_input_3() {
    int rows = 3;
    int cols = 10;
    int[] numbers = new int[] {123, 457, 2, 89, 201, 8, 4, 567, 86, 92, 4, 567, 86, 92, 61, 29, 123, 457, 201, 8, 93, 27, 13, 39, 626, 205, 9, 3, 912, 05};
    Label filename = asciiData(true, "inputs/input3.txt");
    Label buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, buffer);
    Assert.assertEquals(1, get(v0));
    Assert.assertEquals(rows, getWord(buffer, 0));
    Assert.assertEquals(cols, getWord(buffer, 4));
    for(int i = 2; i < 32; i++) {
      Assert.assertEquals(numbers[i-2], getWord(buffer, i*4));
    }
    for(int i = 32; i < 102; i++) {
      Assert.assertEquals(0, getWord(buffer, i*4));
    }
  }

  @Test
  public void verify_input_4() {
    int rows = 10;
    int cols = 10;
    int[] numbers = new int[] {1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 8372, 37272, 3823, 9471, 4732, 9377, 3083, 3830, 927, 2638, 3837, 364646, 39282, 46393, 36294, 6746, 30575, 4720, 29375, 593, 10383, 3840, 29473, 60859, 3634850, 362, 8504, 9786734, 354696, 2470275, 8474, 6464, 4820467, 49265, 8264, 495722, 556, 390856, 92974, 1, 93673, 2038, 3948, 2873, 384, 89683, 2647, 59473, 5938, 393, 93, 52, 85, 364964, 3947, 3964, 350639, 5756, 39047, 4847};
    Label filename = asciiData(true, "inputs/input4.txt");
    Label buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, buffer);
    Assert.assertEquals(1, get(v0));
    Assert.assertEquals(rows, getWord(buffer, 0));
    Assert.assertEquals(cols, getWord(buffer, 4));
    for(int i = 2; i < 102; i++) {
      Assert.assertEquals(numbers[i-2], getWord(buffer, i*4));
    }
  }


  @Test
  public void verify_bad_input_1() {
    Label filename = asciiData(true, "inputs/input6.txt");
    Label buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, buffer);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(0, getWord(buffer, 0));
    Assert.assertEquals(0, getWord(buffer, 4));
    for(int i = 0; i < 83; i++) {
      Assert.assertEquals(0, getWord(buffer, i*4));
    }
  }

  @Test
  public void verify_bad_input_2() {
    Label filename = asciiData(true, "inputs/input7.txt");
    Label buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, buffer);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(0, getWord(buffer, 0));
    Assert.assertEquals(0, getWord(buffer, 4));
    for(int i = 0; i < 83; i++) {
      Assert.assertEquals(0, getWord(buffer, i*4));
    }
  }

  @Test
  public void verify_bad_input_3() {
    Label filename = asciiData(true, "inputs/badup.txt");
    Label buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, buffer);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(0, getWord(buffer, 0));
    Assert.assertEquals(0, getWord(buffer, 4));
    for(int i = 0; i < 83; i++) {
      Assert.assertEquals(0, getWord(buffer, i*4));
    }
  }

  @Test
  public void verify_bad_input_4() {
    Label filename = asciiData(true, "inputs/input8.txt");
    Label buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, buffer);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(0, getWord(buffer, 0));
    Assert.assertEquals(0, getWord(buffer, 4));
    for(int i = 0; i < 83; i++) {
      Assert.assertEquals(0, getWord(buffer, i*4));
    }
  }

  @Test
  public void verify_bad_input_5() {
    Label filename = asciiData(true, "inputs/input9.txt");
    Label buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, buffer);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(0, getWord(buffer, 0));
    Assert.assertEquals(0, getWord(buffer, 4));
    for(int i = 0; i < 83; i++) {
      Assert.assertEquals(0, getWord(buffer, i*4));
    }
  }
}
