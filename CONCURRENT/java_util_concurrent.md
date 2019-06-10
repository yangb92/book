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

ConcurrentLinkedQueue类提供了一个高效的可伸缩的线程安全**非阻塞**FIFO(先进先出)队列,ConcurrentLinkedDeque类与之类似，但还支持Deque(双向队列)接口。

该报中提供了五个BlockingQueue 接口实现类,它定义了put和take的**阻塞**版本,LinkedBlockingQueue，ArrayBlockingQueue，SynchronousQueue，PriorityBlockingQueue和DelayQueue。 不同的类涵盖了生产者 - 消费者，消息传递，并行任务和相关并发设计的最常见使用上下文。

扩展接口TransferQueue和实现LinkedTransferQueue引入了同步传输方法(以及相关特性)，其中生产者可以选择性地阻塞等待其消费者。

BlockingDeque接口扩展了BlockingQueue，支持FIFO和LIFO(基于堆栈)操作。类LinkedBlockingDeque提供了一个实现

