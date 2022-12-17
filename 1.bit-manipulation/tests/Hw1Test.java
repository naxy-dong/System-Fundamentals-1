import org.junit.*;

import static edu.gvsu.mipsunit.munit.MUnit.Register.*;
import static edu.gvsu.mipsunit.munit.MUnit.*;
import static edu.gvsu.mipsunit.munit.MARSSimulator.*;

import org.junit.rules.Timeout;
import java.util.concurrent.TimeUnit;

public class Hw1Test {

  @Rule
  public Timeout timeout = new Timeout(30000, TimeUnit.MILLISECONDS);

  @Test
  public void verify_extra_args_err() {
    Label args = asciiData(true, "D", "123", "hello");
    run("hw_main", 3, args);
    Assert.assertEquals("Program requires exactly two arguments\n", getString(get(a0)));
  }

  @Test
  public void verify_less_args_err() {
    Label args = asciiData(true, "D");
    run("hw_main", 1, args);
    Assert.assertEquals("Program requires exactly two arguments\n", getString(get(a0)));
  }

  @Test
  public void verify_simple_decimal_1() {
    Label args = asciiData(true, "D", "1");
    run("hw_main", 2, args);
    Assert.assertEquals(1, get(a0));
  }

  @Test
  public void verify_simple_decimal_2() {
    Label args = asciiData(true, "D", "0");
    run("hw_main", 2, args);
    Assert.assertEquals(0, get(a0));
  }

  @Test
  public void verify_decimal_lt32_1() {
    Label args = asciiData(true, "D", "10010");
    run("hw_main", 2, args);
    Assert.assertEquals(18, get(a0));
  }

  @Test
  public void verify_decimal_lt32_2() {
    Label args = asciiData(true, "D", "11111101001");
    run("hw_main", 2, args);
    Assert.assertEquals(2025, get(a0));
  }

  @Test
  public void verify_decimal_lt32_3() {
    Label args = asciiData(true, "D", "10000011111101001");
    run("hw_main", 2, args);
    Assert.assertEquals(67561, get(a0));
  }

  @Test
  public void verify_decimal_lt32_4() {
    Label args = asciiData(true, "D", "01111111111111111111111111111111");
    run("hw_main", 2, args);
    Assert.assertEquals(2147483647, get(a0));
  }

  @Test
  public void verify_decimal_eq32_1() {
    Label args = asciiData(true, "D", "00000000000000000000000000001111");
    run("hw_main", 2, args);
    Assert.assertEquals(15, get(a0));
  }

  @Test
  public void verify_decimal_eq32_2() {
    Label args = asciiData(true, "D", "11111111111111111111111111111111");
    run("hw_main", 2, args);
    Assert.assertEquals(-1, get(a0));
  }

  @Test
  public void verify_decimal_eq32_3() {
    Label args = asciiData(true, "D", "10000000000000000000000000000000");
    run("hw_main", 2, args);
    Assert.assertEquals(-2147483648, get(a0));
  }

  @Test
  public void verify_decimal_gt32_1() {
    Label args = asciiData(true, "D", "110000000000000000000000000000000");
    run("hw_main", 2, args);
    Assert.assertEquals("Invalid Arguments\n", getString(get(a0)));
  }

  @Test
  public void verify_decimal_gt32_2() {
    Label args = asciiData(true, "D", "910000000000000000000000000000000");
    run("hw_main", 2, args);
    Assert.assertEquals("Invalid Arguments\n", getString(get(a0)));
  }
  

  @Test
  public void verify_neg_decimal_is_invalid() {
    Label args = asciiData(true, "D", "-123");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("Invalid Arguments\n", getString(get(a0)));
    }
    catch(Exception e) {
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_arg1_is_invalid() {
    Label args = asciiData(true, "Y", "123");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("Invalid Arguments\n", getString(get(a0)));
    }
    catch(Exception e) {
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_arg1_has_length_gt1() {
    Label args = asciiData(true, "DX12", "123");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("Invalid Arguments\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_arg1_has_length_zero() {
    Label args = asciiData(true, "", "123");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("Invalid Arguments\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_decimal_is_empty() {
    Label args = asciiData(true, "D", "");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("Invalid Arguments\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_decode_rtype_rs_1() {
    Label args = asciiData(true, "S", "0xaCe8AB92");
    run("hw_main", 2, args);
    Assert.assertEquals(7, get(a0));
  }

  @Test
  public void verify_decode_rtype_rs_2() {
    Label args = asciiData(true, "S", "0xACD8AB92");
    run("hw_main", 2, args);
    Assert.assertEquals(6, get(a0));
  }

  @Test
  public void verify_decode_rtype_rs_3() {
    Label args = asciiData(true, "S", "0xFFd8Ab92");
    run("hw_main", 2, args);
    Assert.assertEquals(30, get(a0));
  }

  @Test
  public void verify_decode_rtype_rs_4() {
    Label args = asciiData(true, "S", "0xff18ab");
    run("hw_main", 2, args);
    Assert.assertEquals(7, get(a0));
  }

  @Test
  public void verify_decode_rtype_rt_1() {
    Label args = asciiData(true, "T", "0xFCE8AB92");
    run("hw_main", 2, args);
    Assert.assertEquals(8, get(a0));
  }

  @Test
  public void verify_decode_rtype_rt_2() {
    Label args = asciiData(true, "T", "0xfCE1ab92");
    run("hw_main", 2, args);
    Assert.assertEquals(1, get(a0));
  }

  @Test
  public void verify_decode_rtype_rt_3() {
    Label args = asciiData(true, "T", "0xfcD1ab92");
    run("hw_main", 2, args);
    Assert.assertEquals(17, get(a0));
  }

  @Test
  public void verify_decode_rtype_rt_4() {
    Label args = asciiData(true, "T", "0xcd1ab92");
    run("hw_main", 2, args);
    Assert.assertEquals(17, get(a0));
  }

  @Test
  public void verify_decode_rtype_rd_1() {
    Label args = asciiData(true, "E", "0xFCE8AB92");
    run("hw_main", 2, args);
    Assert.assertEquals(21, get(a0));
  }

  @Test
  public void verify_decode_rtype_rd_2() {
    Label args = asciiData(true, "E", "0xff18ab");
    run("hw_main", 2, args);
    Assert.assertEquals(3, get(a0));
  }

  @Test
  public void verify_decode_rtype_rd_3() {
    Label args = asciiData(true, "E", "0xaCc8BB92");
    run("hw_main", 2, args);
    Assert.assertEquals(23, get(a0));
  }

  @Test
  public void verify_decode_rtype_shamt_1() {
    Label args = asciiData(true, "H", "0x1f73fffe");
    run("hw_main", 2, args);
    Assert.assertEquals(-1, get(a0));
  }

  @Test
  public void verify_decode_rtype_shamt_2() {
    Label args = asciiData(true, "H", "0x1f73F0fE");
    run("hw_main", 2, args);
    Assert.assertEquals(3, get(a0));
  }

  @Test
  public void verify_decode_rtype_shamt_3() {
    Label args = asciiData(true, "H", "0xE73F4ef");
    run("hw_main", 2, args);
    Assert.assertEquals(-13, get(a0));
  }

  @Test
  public void verify_decode_rtype_func_1() {
    Label args = asciiData(true, "U", "0x9EfB9361");
    run("hw_main", 2, args);
    Assert.assertEquals(33, get(a0));
  }

  @Test
  public void verify_decode_rtype_func_2() {
    Label args = asciiData(true, "U", "0xFff");
    run("hw_main", 2, args);
    Assert.assertEquals(63, get(a0));
  }

  @Test
  public void verify_decode_rtype_func_3() {
    Label args = asciiData(true, "U", "0x0118ab");
    run("hw_main", 2, args);
    Assert.assertEquals(43, get(a0));
  }

  @Test
  public void verify_decode_rtype_inv_arg_1() {
    Label args = asciiData(true, "O", "0FCD7A1B");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("Invalid Arguments\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_decode_rtype_inv_arg_2() {
    Label args = asciiData(true, "I", "0xFCD7A1B890");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("Invalid Arguments\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_decode_rtype_inv_arg_3() {
    Label args = asciiData(true, "S", "0XFCD7A1");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("Invalid Arguments\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message!", true);
    }
  }

  @Test
  public void verify_convert_hex_to_float_1() {
    Label args = asciiData(true, "F", "42864000");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", 6, get(a0));
    Assert.assertEquals("Unexpected result", "1.00001100100000000000000", getString(get(a1)));
  }

  @Test
  public void verify_convert_hex_to_float_2() {
    Label args = asciiData(true, "F", "C2864000");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", 6, get(a0));
    Assert.assertEquals("Unexpected result", "-1.00001100100000000000000", getString(get(a1)));
  }

  @Test
  public void verify_convert_hex_to_float_3() {
    Label args = asciiData(true, "F", "f4483b47");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", 105, get(a0));
    Assert.assertEquals("Unexpected result", "-1.10010000011101101000111", getString(get(a1)));
  }

  @Test
  public void verify_convert_hex_to_float_4() {
    Label args = asciiData(true, "F", "811234Ac");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", -125, get(a0));
    Assert.assertEquals("Unexpected result", "-1.00100100011010010101100", getString(get(a1)));
  }

  @Test
  public void verify_convert_hex_to_Zero_1() {
    Label args = asciiData(true, "F", "00000000");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", "Zero\n", getString(get(a0)));
  }

  @Test
  public void verify_convert_hex_to_Zero_2() {
    Label args = asciiData(true, "F", "80000000");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", "Zero\n", getString(get(a0)));
  }

  @Test
  public void verify_convert_hex_to_Inf_1() {
    Label args = asciiData(true, "F", "fF800000");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", "-Inf\n", getString(get(a0)));
  }

  @Test
  public void verify_convert_hex_to_Inf_2() {
    Label args = asciiData(true, "F", "7F800000");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", "+Inf\n", getString(get(a0)));
  }

  @Test
  public void verify_convert_hex_to_Nan_1() {
    Label args = asciiData(true, "F", "7f800008");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", "NaN\n", getString(get(a0)));
  }

  @Test
  public void verify_convert_hex_to_Nan_2() {
    Label args = asciiData(true, "F", "ff800008");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", "NaN\n", getString(get(a0)));
  }

  @Test
  public void verify_convert_hex_to_Nan_3() {
    Label args = asciiData(true, "F", "FF80000a");
    run("hw_main", 2, args);
    Assert.assertEquals("Unexpected result", "NaN\n", getString(get(a0)));
  }

  @Test
  public void verify_convert_hex_to_float_inv_arg_1() {
    Label args = asciiData(true, "F", "FF80000");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("Invalid Arguments\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message as arg has less than 8 chars!", true);
    }
  }

  @Test
  public void verify_convert_hex_to_float_inv_arg_2() {
    Label args = asciiData(true, "F", "FF8000012");
    run("hw_main", 2, args);
    try {
        Assert.assertEquals("Invalid Arguments\n", getString(get(a0)));
    }
    catch(Exception e) {
      System.out.println("$a0 = " + String.valueOf(get(a0)));
      Assert.assertFalse("Expected an error message as arg has more than 8 chars!", true);
    }
  }

  @Test
  public void verify_loot_hand_1() {
    Label args = asciiData(true, "L", "M6M4P3P2M4M5");
    run("hw_main", 2, args);
    Assert.assertEquals(-30, get(a0));
  }

  @Test
  public void verify_loot_hand_2() {
    Label args = asciiData(true, "L", "M5M4P2P4P1M8");
    run("hw_main", 2, args);
    Assert.assertEquals(27, get(a0));
  }

  @Test
  public void verify_loot_hand_3() {
    Label args = asciiData(true, "L", "P3M4P2P4P1M8");
    run("hw_main", 2, args);
    Assert.assertEquals(20, get(a0));
  }

  @Test
  public void verify_loot_hand_4() {
    Label args = asciiData(true, "L", "P3P4P2P4P1P1");
    run("hw_main", 2, args);
    Assert.assertEquals(6, get(a0));
  }

  @Test
  public void verify_loot_hand_5() {
    Label args = asciiData(true, "L", "M3M4M6M5M4M8");
    run("hw_main", 2, args);
    Assert.assertEquals(-16, get(a0));
  }

  @Test
  public void verify_loot_hand_6() {
    Label args = asciiData(true, "L", "1P2P3P4P9P6P");
    run("hw_main", 2, args);
    Assert.assertEquals("Loot Hand Invalid\n", getString(get(a0)));
  }

  @Test
  public void verify_loot_hand_7() {
    Label args = asciiData(true, "L", "M3P4M6M5M4P8");
    run("hw_main", 2, args);
    Assert.assertEquals("Loot Hand Invalid\n", getString(get(a0)));
  }

  @Test
  public void verify_loot_hand_8() {
    Label args = asciiData(true, "L", "M3P4M6M5M4P8P2");
    run("hw_main", 2, args);
    Assert.assertEquals("Loot Hand Invalid\n", getString(get(a0)));
  }
}
