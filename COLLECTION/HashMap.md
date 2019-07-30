# HashMap

Hash表数据结构，线程不安全。



## FQA

Q: HashMap 怎么处理Hash冲突。

A: 链地址法, 这种方法的基本思想是将所有哈希地址为i的元素构成一个称为同义词链的单链表，并将单链表的头指针存在哈希表的第i个单元中，因而查找、插入和删除主要在同义词链中进行。链地址法适用于经常进行插入和删除的情况 (也就是说，如果两个元素Hash结果一致，创建一个同义词链，比对具体的值判断是哪个元素)
