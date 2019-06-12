# java.util.concurrent 学习

[官方英文文档](<https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/package-summary.html#MemoryVisibility>)

## Description

实体类经常用于并发编程，这个包中包含了一些小型标准化可扩展框架，以及一些实用的实现类,否则就单调乏味且难以实现。以下是主要组件的描述。

## Executors

**Interfaces.**  

[Executor](Executor.md) 是一个简单的标准化接口, 用于自定义线程，线程池，异步I/O 和 轻量级任务框架, 这些功能取决于使用Executor哪个实现类。任务可以在一个新的线程执行，现有任务的执行线程或线程调用执行,并且可以顺序执行或者并发执行。[ExecutorService](ExecutorService.md) 提供了一个更完整的异步任务执行框架,它管理了任务的排队的和调度,并允许控制关闭，[ScheduledExecutorService](ScheduledExecutorService.md)子接口和相关接口添加了对延迟和周期性任务执行的支持。ExecutorServices提供了安排异步执行任何表示为Callable的函数的方法，Runnable 作为结果的承载。Future返回函数的结果，确定执行是否已完成,并提供取消执行的方法,RunnableFuture是一个拥有run方法的Future，在执行时设置其结果。

**Implementations.**

类ThreadPoolExecutor和ScheduledThreadPoolExecutor提供可调节的灵活的线程池，[Executors](Executors.md)类为Executor的最常见种类和配置提供工厂方法,以及一些使用它们的实用方法。其他基于Executor的实用程序包括具体的类FutureTask，它提供了future的公共可扩展实现,以及ExecutorCompletionService，它帮助协调异步任务组的处理。

ForkJoinPool类提供了一个Executor，主要用于处理ForkJoinTask及其子类的实例,这些类采用了一种工作窃取调度程序，可以获得符合计算密集型并行处理中常常存在的限制的任务的高吞吐量。

## Queues

[`ConcurrentLinkedQueue`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentLinkedQueue.html)类提供了一个高效的可伸缩的线程安全**非阻塞**FIFO(先进先出)队列,[`ConcurrentLinkedDeque`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentLinkedDeque.html)类与之类似，但还支持[`Deque`](https://docs.oracle.com/javase/8/docs/api/java/util/Deque.html)(双向队列)接口。

该报中提供了五个BlockingQueue 接口实现类,它定义了put和take的**阻塞**版本,LinkedBlockingQueue，ArrayBlockingQueue，SynchronousQueue，PriorityBlockingQueue和DelayQueue。 不同的类涵盖了生产者 - 消费者，消息传递，并行任务和相关并发设计的最常见使用上下文。

扩展接口TransferQueue和实现LinkedTransferQueue引入了同步传输方法(以及相关特性)，其中生产者可以选择性地阻塞等待其消费者。

BlockingDeque接口扩展了BlockingQueue，支持FIFO和LIFO(基于堆栈)操作。类LinkedBlockingDeque提供了一个实现

## Synchronizers

提供了5个工具类用户常见的同步操作。

Semaphore /seməfɔː/是一种经典的并发工具。

CountDownLatch是一个非常简单但非常常见的实用程序，用于阻塞，直到给定数量的信号，事件或条件成立。

CyclicBarrier是一种可重置的多路同步点，在某些并行编程风格中很有用。

Phaser提供了更灵活的屏障形式，可用于控制多个线程之间的分阶段计算。

Exchanger允许两个线程在集合点交换对象，并且在多个管道设计中很有用。

## Concurrent Collections

此软件包提供了专为在多线程上下文中使用而设计的Collection实现,[`ConcurrentHashMap`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentHashMap.html), [`ConcurrentSkipListMap`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentSkipListMap.html), [`ConcurrentSkipListSet`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentSkipListSet.html), [`CopyOnWriteArrayList`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CopyOnWriteArrayList.html), and [`CopyOnWriteArraySet`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CopyOnWriteArraySet.html) 当预期多个线程访问给定集合的时候，ConcurrenthashMap 通常比一个同步的HashMap(Hash表数据结构) 可取.并且ConcurrentSkipListMap通常优于同步的TreeMap(红黑树数据结构),当预期的读取和遍历次数远远超过列表的更新次数时，CopyOnWriteArrayList优于同步的ArrayList。

包中 Concurrent 前缀 表示与类似的 synchronized 类几个不同之处.

 For example `java.util.Hashtable` and `Collections.synchronizedMap(new HashMap())` are synchronized.  Concurrent collection 是线程安全的, 但不用单一的排斥锁管理. 在ConcurrentHashMap特定情况下,它可以安全地允许任意数量的并发读取以及可调数量的并发写入,当您需要阻止通过一个锁对集合的所有访问时,"Synchronized" 非常有用.

以可扩展性较差为代价,在多线程访问公共集合的情况下, 通常优选"Concurrent"版本,如果集合不共享,最好使用非同步集合,

大多数异步集合包括队列 java.uti l Iterator 和 Spliterators 提供了弱实现而快速遍历

* 他们可以与其他业务同时进行

* 他们永远不会抛出ConcurrentModificationException

* 它们可以保证在构造时只存在一次元素，并且可以（但不保证）反映构造后的任何修改。

## Memory Consistency Properties


[Chapter 17 of the Java Language Specification](https://docs.oracle.com/javase/specs/jls/se7/html/jls-17.html#jls-17.4.5) defines the *happens-before* relation on memory operations such as reads and writes of shared variables

Java语言规范第17章定义了内存操作上的happens-before关系，比如共享变量的读写

只有当写的操作发生在读的操作之前,一个线程写的结果才可能被另一个线程的读操作看到.

