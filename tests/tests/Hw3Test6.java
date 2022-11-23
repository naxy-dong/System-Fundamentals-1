import org.junit.*;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;
import java.io.*;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

public class Hw3Test6 {
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
  public void verify_mirror_1() {
    String[] expected = new String[] {"2", "3", "3 212 82", "1812 56 34"};
    Label filename = asciiData(true, "inputs/input1.txt");
    Label outFile = asciiData(true, "out.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("mirror", inp_buffer, outFile);
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

  // 4
  // 5
  // 129 20 1 59 109
  // 678 223 951 99 201
  // 9 32 731 29 49
  // 37 393 13332 49 33473

  @Test
  public void verify_mirror_2() {
    String[] expected = new String[] {"4", "5",
      "109 59 1 20 129", "201 99 951 223 678",
      "49 29 731 32 9",
      "33473 49 13332 393 37",
    };
    Label filename = asciiData(true, "inputs/input2.txt");
    Label outFile = asciiData(true, "out.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("mirror", inp_buffer, outFile);
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
  public void verify_mirror_3() {
    String[] expected = new String[] {"3", "10",
      "92 86 567 4 8 201 89 2 457 123",
      "8 201 457 123 29 61 92 86 567 4",
      "5 912 3 9 205 626 39 13 27 93",
    };
    Label filename = asciiData(true, "inputs/input3.txt");
    Label outFile = asciiData(true, "out.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("mirror", inp_buffer, outFile);
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
  public void verify_mirror_4() {
    String[] expected = new String[] {"10", "10",
      "9 8 7 6 5 4 3 2 1 1",
      "19 18 17 16 15 14 13 12 11 10",
      "29 28 27 26 25 24 23 22 21 20",
      "190 180 170 160 150 140 130 120 110 100",
      "2638 927 3830 3083 9377 4732 9471 3823 37272 8372",
      "593 29375 4720 30575 6746 36294 46393 39282 364646 3837",
      "2470275 354696 9786734 8504 362 3634850 60859 29473 3840 10383",
      "1 92974 390856 556 495722 8264 49265 4820467 6464 8474",
      "393 5938 59473 2647 89683 384 2873 3948 2038 93673",
      "4847 39047 5756 350639 3964 3947 364964 85 52 93"
    };
    Label filename = asciiData(true, "inputs/input4.txt");
    Label outFile = asciiData(true, "out.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("mirror", inp_buffer, outFile);
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
