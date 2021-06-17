# JWT 加密与解密

maven

```xml
<!-- jwt -->
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-api</artifactId>
    <version>0.11.2</version>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-impl</artifactId>
    <version>0.11.2</version>
    <scope>runtime</scope>
</dependency>
<dependency>
    <groupId>io.jsonwebtoken</groupId>
    <artifactId>jjwt-jackson</artifactId> <!-- or jjwt-gson if Gson is preferred -->
    <version>0.11.2</version>
    <scope>runtime</scope>
</dependency>
```

测试用例

```java

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.io.Encoders;
import io.jsonwebtoken.security.Keys;

    String info = "Hello World";

    @Test
    void encodeOne(){
        System.out.println("加密方式一：自动生成密钥，密钥不对外暴露，除了此程序能解密之外，开发人员也不能解密");
        Key key = Keys.secretKeyFor(SignatureAlgorithm.HS256);
        String jws = Jwts.builder().setSubject(info).signWith(key).compact();
        System.out.println(jws);
        String subject = Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(jws).getBody().getSubject();
        System.out.println(subject);
    }

    @Test
    void encodeTwo(){
        System.out.println("加密方式二：手动指定密钥");
        Key key = Keys.hmacShaKeyFor("uiquwieoqruiolhqhoiqhweqjeoj123jowei".getBytes(StandardCharsets.UTF_8));
        String jws = Jwts.builder().setSubject(info).signWith(key).compact();
        System.out.println("JWT加密:" + jws);
        String subject = Jwts.parserBuilder().setSigningKey(key).build().parseClaimsJws(jws).getBody().getSubject();
        System.out.println("JWT解密" + subject);
    }
```