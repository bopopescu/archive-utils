package com.lockerz.meatshop;

import org.junit.Test;
import org.springframework.security.crypto.bcrypt.BCrypt;

/**
 * @author Brian Gebala
 * @version 1/28/13 2:22 PM
 */
public class BCryptTest {
    @Test
    public void test() {
        String plainPassword = "ilikepizza";
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));

        System.out.println(hashedPassword);
        System.out.println(hashedPassword.length());

        if (BCrypt.checkpw(plainPassword, hashedPassword)) {
            System.out.println("match");
        }
    }
}
