# ConcurrentHashMap

一个支持异步检索和高预期并发更新的哈希表. 这个类和HashTable遵循相同的规范，并且包含了Hashtable每个方法相对应的版本。

每一个操作都是线程安全的，检索操作不需要锁定,而且锁定整张表组织其他的访问

检索操作通常不会阻塞, 因此可能与更新操作重叠。(同一个键的更新操作与获取操作具有happens-before关系)

Iterators，Spliterators和Enumerations在迭代器/枚举的创建时或之后的某个时刻返回反映哈希表状态的元素。 它们不会抛出ConcurrentModificationException。



