# 流式编程

## 流创建

你可以通过 `Stream.of()` 很容易地将一组元素转化成为流

```java
Stream.of("it", "is", "of", "yang", "b").forEach(System.out::println);
```

除此之外，每个集合都可以通过调用 `stream()` 方法来产生一个流。

```java
List<String> worlds = Arrays.asList("it", "is", "of", "yang", "b");
worlds.stream()
        .mapToInt(item -> item.length())
        .forEach(System.out::println);
```



## 随机数流

控制流的大小和界限

```java
Random random = new Random(24);
random.ints(10,2,10).boxed().forEach(System.out::println);
```

 **Random** 类只能生成基本类型 **int**， **long**， **double** 的流,`boxed()` 流操作将会自动地把基本类型包装成为对应的装箱类型stream

### int 类型的范围

`IntStream` 类提供了 `range()` 方法用于生成整型序列的流。编写循环时，这个方法会更加便利：

```java
range(10, 20).sum();
```

实用的repeat函数,产生的循环更加清晰,

```java
public static void repeat(int n, Runnable action) {
    range(0, n).forEach(i -> action.run());
}
```

### generate()

```java
public class Fuctioncodetest implements Supplier<String> {
    Random rand = new Random(47);
    char[] letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray();
    @Override
    public String get() {
        return "" + letters[rand.nextInt(letters.length)];
    }

    public static void main(String[] args) {
        String word = Stream.generate(new Fuctioncodetest()).limit(30).collect(Collectors.joining());
        System.out.println(word);
    }

}
```

