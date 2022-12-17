import org.junit.*;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;
import java.io.*;
import java.util.Arrays;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

public class Hw4Test {

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
  public Timeout timeout = new Timeout(10000, TimeUnit.MILLISECONDS);

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
  public void verify_create_network() {
    run("create_network", 4, 8);
    Assert.assertEquals(4, getWord(get(v0)));
    Assert.assertEquals(8, getWord(get(v0)+4));
    Assert.assertEquals(0, getWord(get(v0)+8));
    Assert.assertEquals(0, getWord(get(v0)+12));
    for (int i = 16; i < 32; i = i + 4) {
      Assert.assertEquals(0, getWord(get(v0)+i));
    }
    for (int i = 32; i < 64; i = i + 4) {
      Assert.assertEquals(0, getWord(get(v0)+i));
    }
  }

  @Test
  public void verify_create_network_fail_1() {
    run("create_network", -4, 8);
    Assert.assertEquals(-1, get(v0));
  }

  @Test
  public void verify_create_network_fail_2() {
    run("create_network", 4, -8);
    Assert.assertEquals(-1, get(v0));
  }

  @Test
  public void verify_add_person_succ_1() {
    Label p1 = asciiData(true, "Joe");
    run("grader_122022_add_person", 4, 8, p1);
    Assert.assertEquals(1, get(v1));
    Assert.assertEquals("Joe", getString(getWord(get(v0)+16)+4, 3));
    Assert.assertEquals(3, getWord(getWord(get(v0)+16)));
  }

  @Test
  public void verify_add_person_length_succ() {
    Label p1 = asciiData(true, "Joe");
    run("grader_122022_add_person", 4, 8, p1);
    Assert.assertEquals(3, getWord(getWord(get(v0)+16)));
  }

  @Test
  public void verify_add_person_network_succ() {
    Label p1 = asciiData(true, "Joe");
    run("grader_122022_add_person", 4, 8, p1);
    Assert.assertEquals(1, getWord(get(v0)+8));
    Assert.assertEquals(4, getWord(get(v0)));
    Assert.assertEquals(8, getWord(get(v0)+4));
    Assert.assertEquals(0, getWord(get(v0)+12));
    for (int i = 20; i < 32; i = i + 4) {
      Assert.assertEquals(0, getWord(get(v0)+i));
    }
    for (int i = 32; i < 64; i = i + 4) {
      Assert.assertEquals(0, getWord(get(v0)+i));
    }
  }

  @Test
  public void verify_add_empty_person_fail() {
    Label p1 = asciiData(true, "");
    run("grader_122022_add_person", 4, 8, p1);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(-1, get(v1));
  }

  @Test
  public void verify_add_two_persons_succ() {
    Label p1 = asciiData(true, "Joe");
    Label p2 = asciiData(true, "Roe");
    run("grader_122022_add_two_persons", 4, 8, p1, p2);
    Assert.assertEquals(1, get(v1));
    Assert.assertEquals("Joe", getString(getWord(get(v0)+16)+4, 3));
    Assert.assertEquals(3, getWord(getWord(get(v0)+16)));
    Assert.assertEquals("Roe", getString(getWord(get(v0)+20)+4, 3));
    Assert.assertEquals(3, getWord(getWord(get(v0)+20)));
  }

  @Test
  public void verify_add_same_persons_fail() {
    Label p1 = asciiData(true, "Roe");
    Label p2 = asciiData(true, "Roe");
    run("grader_122022_add_two_persons", 4, 8, p1, p2);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(-1, get(v1));
  }

  @Test
  public void verify_add_two_persons_network_succ() {
    Label p1 = asciiData(true, "Joe");
    Label p2 = asciiData(true, "Roe");
    run("grader_122022_add_two_persons", 4, 8, p1, p2);
    Assert.assertEquals(2, getWord(get(v0)+8));
    Assert.assertEquals(4, getWord(get(v0)));
    Assert.assertEquals(8, getWord(get(v0)+4));
    Assert.assertEquals(0, getWord(get(v0)+12));
    for (int i = 24; i < 32; i = i + 4) {
      Assert.assertEquals(0, getWord(get(v0)+i));
    }
    for (int i = 32; i < 64; i = i + 4) {
      Assert.assertEquals(0, getWord(get(v0)+i));
    }
  }

  @Test
  public void verify_add_max_fail() {
    Label p1 = asciiData(true, "Woe");
    run("grader_122022_add_max_persons", 4, 8, p1);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(-1, get(v1));
  }

  @Test
  public void verify_get_existing_person() {
    Label p1 = asciiData(true, "Joe");
    Label p2 = asciiData(true, "Roe");
    run("grader_122022_get_person", 4, 8, p1, p2);
    Assert.assertEquals(3, getWord(get(v0)));
    Assert.assertEquals("Roe", getString(get(v0)+4, 3));
  }

  @Test
  public void verify_get_absent_person() {
    Label p1 = asciiData(true, "Joe");
    Label p2 = asciiData(true, "Roe");
    run("grader_122022_get_person_fail", 4, 8, p1, p2);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(-1, get(v1));
  }

  @Test
  public void verify_add_relation_simple() {
    Label p1 = asciiData(true, "Zoe");
    Label p2 = asciiData(true, "Roe");
    run("grader_122022_add_relation_test", p1, p2, 1);
    boolean x = getString((getWord(getWord(get(v0)+32)))+4, 3).equals("Zoe");
    boolean y = getString((getWord(getWord(get(v0)+32)))+4, 3).equals("Roe");
    Assert.assertTrue(x ^ y);
    x = getString((getWord(getWord(get(v0)+32)+4))+4, 3).equals("Zoe");
    y = getString((getWord(getWord(get(v0)+32)+4))+4, 3).equals("Roe");
    Assert.assertTrue(x ^ y);
    Assert.assertEquals(4, getWord(get(v0)+8));
    Assert.assertEquals(1, getWord(get(v0)+12));
  }

  @Test
  public void verify_add_relation_multi() {
    Label p1 = asciiData(true, "Joe");
    Label p2 = asciiData(true, "Roe");
    run("grader_122022_add_multi_relation_test", p1, p2, 2);
    boolean x = getString((getWord(getWord(get(v0)+44)))+4, 3).equals("Joe");
    boolean y = getString((getWord(getWord(get(v0)+44)))+4, 3).equals("Roe");
    Assert.assertTrue(x ^ y);
    x = getString((getWord(getWord(get(v0)+44)+4))+4, 3).equals("Joe");
    y = getString((getWord(getWord(get(v0)+44)+4))+4, 3).equals("Roe");
    Assert.assertTrue(x ^ y);
    Assert.assertEquals(4, getWord(get(v0)+8));
    Assert.assertEquals(4, getWord(get(v0)+12));
  }

  @Test
  public void verify_add_relation_absent_person_1() {
    Label p1 = asciiData(true, "Joe");
    Label p2 = asciiData(true, "Loe");
    run("grader_122022_add_multi_relation_test", p1, p2, 1);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(-1, get(v1));
  }

  @Test
  public void verify_add_relation_absent_person_2() {
    Label p1 = asciiData(true, "Joe");
    Label p2 = asciiData(true, "Loe");
    run("grader_122022_add_multi_relation_test", p2, p1, 1);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(-1, get(v1));
  }

  @Test
  public void verify_add_relation_exists() {
    Label p1 = asciiData(true, "Woe");
    Label p2 = asciiData(true, "Joe");
    run("grader_122022_add_multi_relation_test", p1, p2, 1);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(-1, get(v1));
  }

  @Test
  public void verify_add_relation_same() {
    Label p1 = asciiData(true, "Woe");
    Label p2 = asciiData(true, "Woe");
    run("grader_122022_add_multi_relation_test", p1, p2, 1);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(-1, get(v1));
  }

  @Test
  public void verify_add_relation_bad_type() {
    Label p1 = asciiData(true, "Joe");
    Label p2 = asciiData(true, "Roe");
    run("grader_122022_add_multi_relation_test", p1, p2, 4);
    Assert.assertEquals(-1, get(v0));
    Assert.assertEquals(-1, get(v1));
  }

  @Test
  public void verify_add_relation_max() {
    Label p1 = asciiData(true, "Joe");
    Label p2 = asciiData(true, "Woe");
    run("grader_122022_add_max_relation_test", p1, p2, 2);
    Assert.assertEquals(-1,get(v0));
    Assert.assertEquals(-1, get(v1));
  }

  @Test
  public void verify_get_distant_friends_1() {
    Label p = asciiData(true, "Woe");
    run("grader_122022_distant_friend_test", p);
    boolean x = getString(get(v0), 3).equals("Zoe");
    boolean y = getString(get(v0), 3).equals("Roe");
    Assert.assertTrue(x ^ y);
    x = getString(getWord(get(v0)+4), 3).equals("Zoe");
    y = getString(getWord(get(v0)+4), 3).equals("Roe");
    Assert.assertTrue(x ^ y);
    Assert.assertEquals(0, getWord(getWord(get(v0)+4)+4));
  }

  @Test
  public void verify_get_distant_friends_2() {
    Label p = asciiData(true, "Zoe");
    run("grader_122022_distant_friend_test", p);
    boolean x = getString(get(v0), 3).equals("Woe");
    Assert.assertTrue(x);
    Assert.assertEquals(0, getWord(get(v0)+4));
  }

  @Test
  public void verify_get_distant_friends_3() {
    Label p = asciiData(true, "Joe");
    run("grader_122022_distant_friend_test", p);
    Assert.assertEquals(-1, get(v0));
  }

  @Test
  public void verify_get_distant_friends_4() {
    Label p = asciiData(true, "Roe");
    run("grader_122022_distant_friend_test", p);
    boolean x = getString(get(v0), 3).equals("Woe");
    Assert.assertTrue(x);
    Assert.assertEquals(0, getWord(get(v0)+4));
  }

  @Test
  public void verify_get_distant_friends_5() {
    Label p = asciiData(true, "Loe");
    run("grader_122022_distant_friend_test", p);
    Assert.assertEquals(-2, get(v0));
  }
}
