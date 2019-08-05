# 队列

## BlockingQueue

一个队列，它还支持在检索元素时等待队列变为非空的操作，以及在存储元素时等待队列中的空间变为可用的操作。

它的方法有四种形式, 有不同的方式来处理不能立即返回但可能在以后某个时候返回: 一种抛出异常,第二种返回一个特殊值(null或false,取决于操作),第三种线程无限期阻塞当前线程，直到操作成功为止,第四种只有当超出了给定的最大时限内才会放弃

|| *Throws exception* | *Special value* | *Blocks* | *Times out* |
|---| ---------- | -------- | -------- | ------- |
|**Insert**| [`add(e)`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingQueue.html#add-E-) | [`offer(e)`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingQueue.html#offer-E-) | [`put(e)`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingQueue.html#put-E-) | [`offer(e, time, unit)`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingQueue.html#offer-E-long-java.util.concurrent.TimeUnit-) |
|**Remove**| [`remove()`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingQueue.html#remove-java.lang.Object-) | [`poll()`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingQueue.html#poll-long-java.util.concurrent.TimeUnit-) | [`take()`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingQueue.html#take--) | [`poll(time, unit)`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingQueue.html#poll-long-java.util.concurrent.TimeUnit-) |
|**Examine**| [`element()`](https://docs.oracle.com/javase/8/docs/api/java/util/Queue.html#element--) | [`peek()`](https://docs.oracle.com/javase/8/docs/api/java/util/Queue.html#peek--) | *not applicable* | *not applicable* |

默认的容量为 Integer.MAX_VALUE

队列比支持 null

BlockingQueue实现是线程安全的

BlockingQueue本质上不支持任何“关闭”或“关闭”操作，以指示不再添加任何项。这些特性的需求和使用往往依赖于实现

## ConcurrentLinkedQueue

- 基于链接节点的无界线程安全队列
- FIFO(先进先出),
- 不允许使用空元素。
- 许多线程共享对公共集合的访问时，ConcurrentLinkedQueue是一个合适的选择.
- 迭代器是弱一致的,反映队列在迭代器创建时或创建后某个时点的状态的元素。它们不会抛出ConcurrentModificationException，并且可以与其他操作并发进行。自创建迭代器以来，队列中包含的元素将只返回一次。

