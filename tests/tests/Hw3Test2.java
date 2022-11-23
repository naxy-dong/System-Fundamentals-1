import org.junit.*;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;
import java.io.*;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

public class Hw3Test2 {
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
  public void verify_out_1() {
    String[] expected = new String[] {"3", "2", "12 291", "1 101", "49 56"};
    Label filename = asciiData(true, "out.txt");
    Label buffer = wordData(3,2,12,291,1,101,49,56,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("write_file", filename, buffer);
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
  public void verify_out_2() {
    String[] expected = new String[] {"5", "8", "29 28 3 138 29 48 29 10", "3329 728 43 18 279 47783 529 10", "7 6298 8 4 3 213 292911 11", "19 89 1992 298 383 473 3 90", "252 11 5 7 8 3039 38 383838"};
    Label filename = asciiData(true, "out.txt");
    Label buffer = wordData(5, 8, 29, 28, 3, 138, 29, 48, 29, 10, 3329, 728, 43, 18, 279, 47783, 529, 10, 7, 6298, 8, 4, 3, 213, 292911, 11, 19, 89, 1992, 298, 383, 473, 3, 90, 252, 11, 5, 7, 8, 3039, 38, 383838);
    run("write_file", filename, buffer);
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
