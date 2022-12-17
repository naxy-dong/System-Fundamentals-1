import org.junit.*;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;
import java.io.*;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

public class Hw3Test7 {
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
  public void verify_dup_1() {
    Label filename = asciiData(true, "inputs/dup1p.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("duplicate", inp_buffer);
    Assert.assertEquals(1, get(v0));
    Assert.assertEquals(3, get(v1));
  }

  @Test
  public void verify_no_dup_1() {
    Label filename = asciiData(true, "inputs/dup1f.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("duplicate", inp_buffer);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(0, get(v1));
  }

  @Test
  public void verify_dup_2() {
    Label filename = asciiData(true, "inputs/dup2p.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("duplicate", inp_buffer);
    Assert.assertEquals(1, get(v0));
    Assert.assertTrue(4 == get(v1) || 5 == get(v1));
  }

  @Test
  public void verify_no_dup_2() {
    Label filename = asciiData(true, "inputs/dup2f.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("duplicate", inp_buffer);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(0, get(v1));
  }

  @Test
  public void verify_dup_3() {
    Label filename = asciiData(true, "inputs/dup3p.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("duplicate", inp_buffer);
    Assert.assertEquals(1, get(v0));
    Assert.assertTrue(5 == get(v1) || 8 == get(v1));
  }

  @Test
  public void verify_no_dup_3() {
    Label filename = asciiData(true, "inputs/dup3f.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("duplicate", inp_buffer);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(0, get(v1));
  }

  @Test
  public void verify_global_data() {
    String[] expected = new String[] {"5", "4", "37 9 678 129", "393 32 223 20", "13332 731 951 1", "49 29 99 59", "33473 49 201 109"};
    Label filename = asciiData(true, "inputs/input2.txt");
    Label outFile = asciiData(true, "out.txt");
    Label init_buffer = wordData(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    Label some_data = wordData(10,11);
    run("initialize", filename, init_buffer);
    Label inp_buffer = wordData(getWords(init_buffer.address(), 102));
    run("rotate_clkws_90", inp_buffer, outFile);
    Assert.assertEquals("Global data change detected!", 10, getWord(some_data.address()));
    Assert.assertEquals("Global data change detected!", 11, getWord(some_data.address()+4));
    try (BufferedReader br = new BufferedReader(new FileReader("out.txt")))
    {
      String line;
      for(int i=0; i < expected.length; i++) {
        line = br.readLine();
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
