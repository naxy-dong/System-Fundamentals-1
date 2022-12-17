import org.junit.*;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;
import java.io.*;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

public class Hw3Test3 {
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
  public void verify_rotate_clkws_90_1() {
    String[] expected = new String[] {"3", "2", "34 82", "56 212", "1812 3"};
    Label filename = asciiData(true, "inputs/input1.txt");
    Label outFile = asciiData(true, "out.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("rotate_clkws_90", inp_buffer, outFile);
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
  public void verify_rotate_clkws_90_2() {
    String[] expected = new String[] {"5", "4", "37 9 678 129", "393 32 223 20", "13332 731 951 1", "49 29 99 59", "33473 49 201 109"};
    Label filename = asciiData(true, "inputs/input2.txt");
    Label outFile = asciiData(true, "out.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("rotate_clkws_90", inp_buffer, outFile);
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
  public void verify_rotate_clkws_90_3() {
    String[] expected = new String[] {"10", "3", "93 4 123", "27 567 457", "13 86 2", "39 92 89", "626 61 201", "205 29 8", "9 123 4", "3 457 567", "912 201 86", "5 8 92"};
    Label filename = asciiData(true, "inputs/input3.txt");
    Label outFile = asciiData(true, "out.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("rotate_clkws_90", inp_buffer, outFile);
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
  public void verify_rotate_clkws_90_4() {
    String[] expected = new String[] {"10", "10",
      "93 93673 8474 10383 3837 8372 100 20 10 1",
      "52 2038 6464 3840 364646 37272 110 21 11 1",
      "85 3948 4820467 29473 39282 3823 120 22 12 2",
      "364964 2873 49265 60859 46393 9471 130 23 13 3",
      "3947 384 8264 3634850 36294 4732 140 24 14 4",
      "3964 89683 495722 362 6746 9377 150 25 15 5",
      "350639 2647 556 8504 30575 3083 160 26 16 6",
      "5756 59473 390856 9786734 4720 3830 170 27 17 7",
      "39047 5938 92974 354696 29375 927 180 28 18 8",
      "4847 393 1 2470275 593 2638 190 29 19 9"
    };
    Label filename = asciiData(true, "inputs/input4.txt");
    Label outFile = asciiData(true, "out.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("rotate_clkws_90", inp_buffer, outFile);
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
