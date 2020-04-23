# 函数式编程

> 函数式编程语言操纵代码片段就像操作数据一样容易。 虽然 Java 不是函数式语言，但 Java 8 Lambda 表达式和方法引用 (Method References) 允许你以函数式编程。

OO（object oriented，面向对象）是抽象数据，FP（functional programming，函数式编程）是抽象行为。

代码演示

```java

interface Strategy {
    String approach(String msg);
}

class Unrelated {
    static String twice(String msg) {
        return msg + " " + msg;
    }
}

public class Fuctioncodetest {


    public static void main(String[] args) {
        Strategy[] strategies = {
                msg -> msg + "Tom", // Lambda 
                Unrelated::twice // 方法应用
        };

        for (Strategy strategy : strategies) {
            String goodmorning = strategy.approach("Goodmorning ");
            System.out.println(goodmorning);
        }
    }

}
```

## Lambda表达式

1. Lambda 表达式产生函数，而不是类。 在 JVM（Java Virtual Machine，Java 虚拟机）上，一切都是一个类，因此在幕后执行各种操作使 Lambda 看起来像函数 —— 但作为程序员，你可以高兴地假装它们“只是函数”。
2. Lambda 语法尽可能少，这正是为了使 Lambda 易于编写和使用。

### 递归
接受 int 型参数并生成 int 的接口：
```java
// functional/IntCall.java

interface IntCall {
  int call(int arg);
}
```
整数 n 的阶乘将所有小于或等于 n 的正整数相乘。 阶乘函数是一个常见的递归示例：
```java
// functional/RecursiveFactorial.java

public class RecursiveFactorial {
  static IntCall fact;
  public static void main(String[] args) {
    fact = n -> n == 0 ? 1 : n * fact.call(n - 1);
    for(int i = 0; i <= 10; i++)
      System.out.println(fact.call(i));
  }
}
```

## 方法引用

Java 8 方法引用没有历史包袱。方法引用组成：类名或对象名，后面跟 :: 然后跟方法名称。

### Runnable接口

```java
class Go {
    static void go() {
        System.out.println("Go::go()");
    }
}

new Thread(Go::go).start();
```

### 未绑定的方法引用

未绑定的方法引用是指没有关联对象的普通（非静态）方法。 使用未绑定的引用之前，我们必须先提供对象：
```java
class Go {
    void go() {
        System.out.println("Go::go()");
    }
}

Go g_o = new Go();
new Thread(g_o::go).start();
```

## 构造函数引用

```java
class Dog {
    String name;
    int age = -1; // For "unknown"
    Dog() { name = "stray"; }
    Dog(String nm) { name = nm; }
    Dog(String nm, int yrs) { name = nm; age = yrs; }
}

interface MakeNoArgs {
    Dog make();
}

interface Make1Arg {
    Dog make(String nm);
}

interface Make2Args {
    Dog make(String nm, int age);
}

public class Fuctioncodetest {

    public static void main(String[] args) {
        MakeNoArgs mna = Dog::new;
        Make1Arg m1a = Dog::new;
        Make2Args m2a = Dog::new;
    }

}
```

Dog 有三个构造函数，函数接口内的 make() 方法反映了构造函数参数列表（ make() 方法名称可以不同）。

注意我们如何对 [1]，[2] 和 [3] 中的每一个使用 Dog :: new。 这 3 个构造函数只有一个相同名称：:: new，但在每种情况下都赋值给不同的接口。编译器可以检测并知道从哪个构造函数引用。

编译器能识别并调用你的构造函数（ 在本例中为 make()）。

## [函数式接口](https://lingcoder.github.io/OnJava8/#/book/13-Functional-Programming?id=函数式接口)

方法引用和 Lambda 表达式必须被赋值，同时编译器需要识别类型信息以确保类型正确。

假设你要传递 System.out :: println 到你正在编写的方法 ，你怎么知道传递给方法的参数的类型？

为了解决这个问题，Java 8 引入了 java.util.function 包。它包含一组接口，这些接口是 Lambda 表达式和方法引用的目标类型。 每个接口只包含一个抽象方法，称为函数式方法。

在编写接口时，可以使用`@FunctionalInterface`注解强制执行此“函数式方法”模式：

下表描述了 `java.util.function` 中的目标类型（包括例外情况）：

| **特征**                                  | **函数式方法名**                                             | **示例**                                                     |
| ----------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 无参数； 无返回值                         | **Runnable** (java.lang) `run()`                             | **Runnable**                                                 |
| 无参数； 返回类型任意                     | **Supplier** `get()` `getAs类型()`                           | **Supplier `<T>` BooleanSupplier IntSupplier LongSupplier DoubleSupplier** |
| 无参数； 返回类型任意                     | **Callable** (java.util.concurrent) `call()`                 | **Callable`<T>`**                                            |
| 1 参数； 无返回值                         | **Consumer** `accept()`                                      | **`Consumer<T>` IntConsumer LongConsumer DoubleConsumer**    |
| 2 参数 **Consumer**                       | **BiConsumer** `accept()`                                    | **`BiConsumer<T><U>`**                                       |
| 2 参数 **Consumer**； 1 引用； 1 基本类型 | **Obj类型Consumer** `accept()`                               | **`ObjIntConsumer<T>` `ObjLongConsumer<T>` `ObjDoubleConsumer<T>`** |
| 1 参数； 返回类型不同                     | **Function** `apply()` **To类型** 和 **类型To类型** `applyAs类型()` | **Function`<T><R>` IntFunction`<R>` `LongFunction<R>` DoubleFunction`<R>` ToIntFunction`<T> `ToLongFunction<T>``ToDoubleFunction<T>` IntToLongFunction IntToDoubleFunction LongToIntFunction LongToDoubleFunction DoubleToIntFunction DoubleToLongFunction** |
| 1 参数； 返回类型相同                     | **UnaryOperator** `apply()`                                  | **`UnaryOperator<T>` IntUnaryOperator LongUnaryOperator DoubleUnaryOperator** |
| 2 参数类型相同； 返回类型相同             | **BinaryOperator** `apply()`                                 | **`BinaryOperator<T>` IntBinaryOperator LongBinaryOperator DoubleBinaryOperator** |
| 2 参数类型相同; 返回整型                  | Comparator (java.util) `compare()`                           | **`Comparator<T>`**                                          |
| 2 参数； 返回布尔型                       | **Predicate** `test()`                                       | **`Predicate<T>` `BiPredicate<T,U>` IntPredicate LongPredicate DoublePredicate** |
| 参数基本类型； 返回基本类型               | **类型To类型Function** `applyAs类型()`                       | **IntToLongFunction IntToDoubleFunction LongToIntFunction LongToDoubleFunction DoubleToIntFunction DoubleToLongFunction** |
| 2 参数类型不同                            | **Bi操作** (不同方法名)                                      | `BiFunction<T,U,R> BiConsumer<T,U> BiPredicate<T,U> ToIntBiFunction<T,U> ToLongBiFunction<T,U> ToDoubleBiFunction<T> ` |



### 多参数函数式接口

`java.util.functional` 中的接口是有限的。比如有了 `BiFunction`，但它不能变化。 如果需要三参数函数的接口怎么办？ 其实这些接口非常简单，很容易查看 Java 库源代码并自行创建。代码示例：

```java
// functional/TriFunction.java

@FunctionalInterface
public interface TriFunction<T, U, V, R> {
    R apply(T t, U u, V v);
}
```



## [高阶函数](https://lingcoder.github.io/OnJava8/#/book/13-Functional-Programming?id=高阶函数)

这个名字可能听起来令人生畏，但是：[高阶函数](https://en.wikipedia.org/wiki/Higher-order_function)（Higher-order Function）只是一个消费或产生函数的函数。

我们先来看看如何产生一个函数：

```java
// functional/ProduceFunction.java

import java.util.function.*;

interface
FuncSS extends Function<String, String> {} // [1]

public class ProduceFunction {
  static FuncSS produce() {
    return s -> s.toLowerCase(); // [2]
  }
  public static void main(String[] args) {
    FuncSS f = produce();
    System.out.println(f.apply("YELLING"));
  }
}
```

## [闭包](https://lingcoder.github.io/OnJava8/#/book/13-Functional-Programming?id=闭包)

考虑一个更复杂的 Lambda，它使用函数作用域之外的变量。 返回该函数会发生什么？ 也就是说，当你调用函数时，它对那些 “外部 ”变量引用了什么? 如果语言不能自动解决这个问题，那将变得非常具有挑战性。 能够解决这个问题的语言被称为**支持闭包**，或者叫作在词法上限定范围( 也使用术语*变量捕获* )。Java 8 提供了有限但合理的闭包支持，我们将用一些简单的例子来研究它。

## [函数组合](https://lingcoder.github.io/OnJava8/#/book/13-Functional-Programming?id=函数组合)

函数组合（Function Composition）意为“多个函数组合成新函数”。它通常是函数式编程的基本组成部分。在前面的 `TransformFunction.java` 类中，有一个使用 `andThen()` 的函数组合示例。一些 `java.util.function` 接口中包含支持函数组合的方法 [^7]。