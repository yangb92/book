# ConcurrentLinkedQueue

* 基于链接节点的无界线程安全队列

* FIFO(先进先出),

* 不允许使用空元素。

* 许多线程共享对公共集合的访问时，ConcurrentLinkedQueue是一个合适的选择.
* 迭代器是弱一致的,反映队列在迭代器创建时或创建后某个时点的状态的元素。它们不会抛出ConcurrentModificationException，并且可以与其他操作并发进行。自创建迭代器以来，队列中包含的元素将只返回一次。

