import org.junit.*;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;
import java.io.*;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

public class Hw3Test5 {
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
  public void verify_rotate_clkws_270_1() {
    String[] expected = new String[] {"3", "2", "3 1812", "212 56", "82 34"};
    Label filename = asciiData(true, "inputs/input1.txt");
    Label outFile = asciiData(true, "out.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("rotate_clkws_270", inp_buffer, outFile);
    try (BufferedReader br = new BufferedReader(new FileReader("out.txt")))
    {
      String line;
      for(int i=0; i < expected.length; i++) {
        line = br.readLine();
        Assert.assertEquals(expected[i], line);
      }
    }
    catch(IOException e) {
      Assert.assertTrue("File IO Error", false);
    }
    catch(Exception e) {
      Assert.assertTrue("Test Errored out ... ", false);
    }
    finally {
      new File("out.txt").delete();
    }
  }

  @Test
  public void verify_rotate_clkws_270_2() {
    String[] expected = new String[] {"5", "4",
      "109 201 49 33473", "59 99 29 49", "1 951 731 13332", "20 223 32 393", "129 678 9 37"};
    Label filename = asciiData(true, "inputs/input2.txt");
    Label outFile = asciiData(true, "out.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("rotate_clkws_270", inp_buffer, outFile);
    try (BufferedReader br = new BufferedReader(new FileReader("out.txt")))
    {
      String line;
      for(int i=0; i < expected.length; i++) {
        line = br.readLine();
        Assert.assertEquals(expected[i], line);
      }
    }
    catch(IOException e) {
      Assert.assertTrue("File IO Error", false);
    }
    catch(Exception e) {
      Assert.assertTrue("Test Errored out ... ", false);
    }
    finally {
      new File("out.txt").delete();
    }
  }

  // 123 457 2 89 201 8 4 567 86 92
  // 4 567 86 92 61 29 123 457 201 8
  // 93 27 13 39 626 205 9 3 912 05

  @Test
  public void verify_rotate_clkws_270_3() {
    String[] expected = new String[] {"10", "3",
      "92 8 5", "86 201 912", "567 457 3",
      "4 123 9", "8 29 205", "201 61 626",
      "89 92 39", "2 86 13", "457 567 27",
      "123 4 93"};
    Label filename = asciiData(true, "inputs/input3.txt");
    Label outFile = asciiData(true, "out.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("rotate_clkws_270", inp_buffer, outFile);
    try (BufferedReader br = new BufferedReader(new FileReader("out.txt")))
    {
      String line;
      for(int i=0; i < expected.length; i++) {
        line = br.readLine();
        Assert.assertEquals(expected[i], line);
      }
    }
    catch(IOException e) {
      Assert.assertTrue("File IO Error", false);
    }
    catch(Exception e) {
      Assert.assertTrue("Test Errored out ... ", false);
    }
    finally {
      new File("out.txt").delete();
    }
  }

  @Test
  public void verify_rotate_clkws_270_4() {
    String[] expected = new String[] {"10", "10",
      "9 19 29 190 2638 593 2470275 1 393 4847",
      "8 18 28 180 927 29375 354696 92974 5938 39047",
      "7 17 27 170 3830 4720 9786734 390856 59473 5756",
      "6 16 26 160 3083 30575 8504 556 2647 350639",
      "5 15 25 150 9377 6746 362 495722 89683 3964",
      "4 14 24 140 4732 36294 3634850 8264 384 3947",
      "3 13 23 130 9471 46393 60859 49265 2873 364964",
      "2 12 22 120 3823 39282 29473 4820467 3948 85",
      "1 11 21 110 37272 364646 3840 6464 2038 52",
      "1 10 20 100 8372 3837 10383 8474 93673 93",
    };
    Label filename = asciiData(true, "inputs/input4.txt");
    Label outFile = asciiData(true, "out.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("rotate_clkws_270", inp_buffer, outFile);
    try (BufferedReader br = new BufferedReader(new FileReader("out.txt")))
    {
      String line;
      for(int i=0; i < expected.length; i++) {
        line = br.readLine();
        Assert.assertEquals(expected[i], line);
      }
    }
    catch(IOException e) {
      Assert.assertTrue("File IO Error", false);
    }
    catch(Exception e) {
      Assert.assertTrue("Test Errored out ... ", false);
    }
    finally {
      new File("out.txt").delete();
    }
  }
}
