package com.elgris.usersapi;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.junit.Assert.assertEquals;
import io.jsonwebtoken.Claims;

import javax.servlet.http.HttpServletRequest;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import com.elgris.usersapi.api.UsersController;
import com.elgris.usersapi.models.User;

@RunWith(SpringRunner.class)
@SpringBootTest
public class UsersApiApplicationTests {
    
    @Autowired
    UsersController controller;


    @Test
    public void defaultTest() {
        String username = "admin";
        String firstname = "Foo";
        
        HttpServletRequest request = mock(HttpServletRequest.class);
        Claims claims = mock(Claims.class);
        
        when(request.getAttribute("claims")).thenReturn(claims);
        when(claims.get("username")).thenReturn(username);
        
        User user = controller.getUser(request, username);
        assertEquals(user.getFirstname(), firstname);
    }

}
