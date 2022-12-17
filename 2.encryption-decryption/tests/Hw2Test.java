import org.junit.*;
import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;

import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

public class Hw2Test {

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
  public void hash_1() {
    Label msg = asciiData(true, "I love MIPS!");
    run("hash", msg);
    Assert.assertEquals(921, get(v0));
  }

  @Test
  public void hash_2() {
    Label msg = asciiData(true, "Hakuna Matata?");
    run("hash", msg);
    Assert.assertEquals(1295, get(v0));
  }

  @Test
  public void hash_3() {
    Label msg = asciiData(true, "Seawolves let's go!");
    run("hash", msg);
    Assert.assertEquals(1743, get(v0));
  }

  @Test
  public void hash_4() {
    Label msg = asciiData(true, "I am potus");
    run("hash", msg);
    Assert.assertEquals(914, get(v0));
  }

  @Test
  public void hash_5() {
    Label msg = asciiData(true, "Fall2022");
    run("hash", msg);
    Assert.assertEquals(581, get(v0));
  }

  @Test
  public void verify_prime_1() {
    int p = 60;
    int q = 73;
    run("isPrime", p);
    Assert.assertEquals("Expected p to not be prime", 0,get(v0));
    run("isPrime", q);
    Assert.assertEquals("Expected q to be prime", 1,get(v0));
  }

  @Test
  public void verify_prime_2() {
    int p = 67;
    int q = 77;
    run("isPrime", p);
    Assert.assertEquals("Expected p to be prime", 1,get(v0));
    run("isPrime", q);
    Assert.assertEquals("Expected q to not be prime", 0,get(v0));
  }

  @Test
  public void verify_lcm_1() {
    run("lcm", 999,991);
    Assert.assertEquals(990009, get(v0));
  }

  @Test
  public void verify_lcm_2() {
    run("lcm", 382,8261);
    Assert.assertEquals(3155702, get(v0));
  }

  @Test
  public void verify_lcm_3() {
    run("lcm", 8261, 382);
    Assert.assertEquals(3155702, get(v0));
  }

  @Test
  public void verify_gcd_1() {
    run("gcd", 45, 909);
    Assert.assertEquals(9, get(v0));
  }

  @Test
  public void verify_gcd_2() {
    run("gcd", 909, 45);
    Assert.assertEquals(9, get(v0));
  }

  @Test
  public void verify_gcd_3() {
    run("gcd", 9999, 132);
    Assert.assertEquals(33, get(v0));
  }

  @Test
  public void verify_pkeyExp_1() {
    run("prikExp", 15,26);
    Assert.assertEquals(7, get(v0));
  }

  @Test
  public void verify_pkeyExp_2() {
    run("prikExp", 2061,5228);
    Assert.assertEquals(1281, get(v0));
  }

  @Test
  public void verify_pkeyExp_3() {
    run("prikExp", 821, 9981);
    Assert.assertEquals(851, get(v0));
  }

  @Test
  public void verify_pkeyExp_4() {
    run("prikExp", 119919, 998777);
    Assert.assertEquals(966578, get(v0));
  }

  @Test
  public void verify_pkeyExp_invalid_1() {
    run("prikExp", 29, 29);
    Assert.assertEquals(-1, get(v0));
  }

  @Test
  public void verify_pkeyExp_invalid_2() {
    run("prikExp", 18, 57);
    Assert.assertEquals(-1, get(v0));
  }

  @Test
  public void verify_pubkExp_1() {
    run("pubkExp", 15908);
    int x = get(v0);
    run("gcd", x, 15908);
    Assert.assertEquals(1, get(v0));
  }

  @Test
  public void verify_pubkExp_2() {
    run("pubkExp", 25);
    int x = get(v0);
    run("gcd", x, 25);
    Assert.assertEquals(1, get(v0));
  }

  @Test
  public void verify_pubkExp_3() {
    run("pubkExp", 999991);
    int x = get(v0);
    run("gcd", x, 999991);
    Assert.assertEquals(1, get(v0));
  }

  @Test
  public void verify_rsa_1() {
    // IMPORTANT : hashed message m < n where n = p * q and p,q are primes
    run("encrypt", 19, 5, 7);
    int c = get(v0);
    int e = get(v1);
    run("decrypt", c, e, 5, 7);
    Assert.assertEquals(19, get(v0));
  }

  @Test
  public void verify_rsa_2() {
    run("encrypt", 21, 23, 47);
    int c = get(v0);
    int e = get(v1);
    run("decrypt", c, e, 23, 47);
    Assert.assertEquals(21, get(v0));
  }

  @Test
  public void verify_rsa_3() {
    run("encrypt", 52, 107, 131);
    int c = get(v0);
    int e = get(v1);
    run("decrypt", c, e, 107, 131);
    Assert.assertEquals(52, get(v0));
  }

  @Test
  public void verify_rsa_4() {
    run("encrypt", 581, 107, 233);
    int c = get(v0);
    int e = get(v1);
    run("decrypt", c, e, 107, 233);
    Assert.assertEquals(581, get(v0));
  }

  @Test
  public void verify_rsa_5() {
    run("encrypt", 921, 23, 47);
    int c = get(v0);
    int e = get(v1);
    run("decrypt", c, e, 23, 47);
    Assert.assertEquals(921, get(v0));
  }

  @Test
  public void verify_rsa_6() {
    run("encrypt", 1743, 107, 157);
    int c = get(v0);
    int e = get(v1);
    run("decrypt", c, e, 107, 157);
    Assert.assertEquals(1743, get(v0));
  }

  @Test
  public void verify_rsa_7() {
    run("encrypt", 914, 67, 73);
    int c = get(v0);
    int e = get(v1);
    run("decrypt", c, e, 67, 73);
    Assert.assertEquals(914, get(v0));
  }

  @Test
  public void verify_rsa_8() {
    run("encrypt", 1295, 67, 79);
    int c = get(v0);
    int e = get(v1);
    run("decrypt", c, e, 67, 79);
    Assert.assertEquals(1295, get(v0));
  }

  @Test
  public void verify_rsa_9() {
    int p = 67;
    int q = 79;
    run("isPrime", p);
    Assert.assertEquals("Expected p to be prime", 1,get(v0));
    run("isPrime", q);
    Assert.assertEquals("Expected q to be prime", 1,get(v0));
    run("encrypt", 914, p, q);
    int c = get(v0);
    int e = get(v1);
    run("decrypt", c, e, p, q);
    Assert.assertEquals(914, get(v0));
  }
}
