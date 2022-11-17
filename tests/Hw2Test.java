import org.junit.*;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;

import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

public class Hw2Test {
  //Label name1 = asciiData(true, "I love MIPS!");
  Label name1 = asciiData(true, "Jane");
  Label name2 = asciiData(true, "Joey");
  Label name3 = asciiData(true, "Alit");
  Label name4 = asciiData(true, "Veen");
  Label name5 = asciiData(true, "Stan");
  Label name6 = asciiData(true, "Naxy");
  Label name7 = asciiData(true, "Ryan");	

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
  public Timeout timeout = new Timeout(20000, TimeUnit.MILLISECONDS);

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
  public void check_distant_friend() {
    Label name1 = asciiData(true, "Jane");
    Label name2 = asciiData(true, "Joey");
    Label name3 = asciiData(true, "Alit");
    Label name4 = asciiData(true, "Veen");
    Label name5 = asciiData(true, "Stan");
    Label name6 = asciiData(true, "Naxy");
    Label name7 = asciiData(true, "Ryan");	
    int a;
    run("create_network", 10, 10);
    a = get(v0);
    System.out.println(get(v0));
    run("add_person", a, name1);
    a = get(v0);
    System.out.println(get(v0));
    run("add_person", a, name2);
    a = get(v0);
    run("add_person", a, name3);
    a = get(v0);
    run("add_person", a, name4);
    a = get(v0);
    run("add_person", a, name5);
    a = get(v0);
    run("add_person", a, name6);
    a = get(v0);
    run("add_person", a, name7);
    a = get(v0);
    run("add_relation", a, name1,name2,1);
    a = get(v0);
    run("add_relation", a, name1,name3,1);
    a = get(v0);
    run("add_relation", a, name2,name5,1);
    a = get(v0);
    run("add_relation", a, name3,name4,1);
    a = get(v0);
    run("add_relation", a, name3,name6,1);
    a = get(v0);
    run("get_distant_friends", a, name1);
    //Assert.assertEquals(990009, get(v0));
  }
}

