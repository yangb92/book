# Memory Consistency Properties

Java语言规范第17章([Chapter 17 of the Java Language Specification](https://docs.oracle.com/javase/specs/jls/se7/html/jls-17.html#jls-17.4.5))定义了内存操作上的happens-before关系，比如共享变量的读写

如果A动作发生在B动作之前，可标记为 hb(A,B)

一个线程中的写操作与另一个线程中的读操作在数据竞争中可能出现顺序错误。happens-before关系定义了什么时候发生数据竞争。

在变量r 读取V的值时观察到w在写V的值,根据happens-before原则:

* r 没有排在w之前，即它不是hp(r,w)
* w 还没有写入 v

r读取的时候允许看到w写的结果

在happens-before一致的操作集中，每次读取都会看到一个允许它看到的写入happens-before ordering



-----------------------



For the trace in [Table 17.5](https://docs.oracle.com/javase/specs/jls/se7/html/jls-17.html#jls-17.4.5-table-1), initially `A == B == 0`. The trace can observe `r2 == 0` and `r1 == 0` and still be *happens-before consistent*, since there are execution orders that allow each read to see the appropriate write.



**Table 17.5. Behavior allowed by happens-before consistency, but not sequential consistency.**

| Thread 1  | Thread 2  |
| --------- | --------- |
| `B = 1;`  | `A = 2;`  |
| `r2 = A;` | `r1 = B;` |

Since there is no synchronization, each read can see either the write of the initial value or the write by the other thread. An execution order that displays this behavior is:

```
1: B = 1;
3: A = 2;
2: r2 = A;  // sees initial write of 0
4: r1 = B;  // sees initial write of 0
```

Another execution order that is happens-before consistent is:

```
1: r2 = A;  // sees write of A = 2
3: r1 = B;  // sees write of B = 1
2: B = 1;
4: A = 2;
```

In this execution, the reads see writes that occur later in the execution order. This may seem counterintuitive, but is allowed by *happens-before* consistency. Allowing reads to see later writes can sometimes produce unacceptable behaviors.