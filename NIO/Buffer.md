# [Buffer](<https://docs.oracle.com/javase/8/docs/api/java/nio/Buffer.html>)

```java
public abstract class Buffer
extends Object
```

一个基本数据类型的**容器**

缓冲区是原始数据类型的线性有限序列, 缓存区的基本属性的他的容量(capacity ),范围(limit )和位置(position ):

* capacity 缓冲区的容量是它包含的元素数量，一个缓存区的容量不能为负，也不允许修改。(capacity >= 0)
* limit 缓冲区的范围不允许读或写的第一个元素的索引(通俗解释就是只能到这个点,不能再往后读或写了)，limit 不允许为负,不能大于缓冲区的容量(0 <= limit <= capacity )
* position 是下一个要读或写的元素索引,position 不能为负或者大于limit

非布尔类型的基本类型，该类都有一个子类。(例如: ByteBuffer, CharBuffer, DoubleBuffer ...)

## Transferring data 数据传输

该类的每个子类都定义了get和put两个方法:

	> 当从当前位置读或写一个或多个元素，然后通过元素的数量增加position,如果传输的元素超过了limit ，get 操作会抛出一个 BufferUnderflowException， put 操作会抛出 BufferOverflowException。在这两种情况下，都不传输任何数据。
	>
	> 如果使用绝对位置获取元素，不会作用于position, 如果位置超出了limit，会出现IndexOfBoundsException.

当然数据也可以通过适当的信道I/O操作传送数据缓冲器中或从缓冲器传出，这些操作总是相当于当前位置。

## Marking and resetting 标记和重置

缓冲区的标记是在调用reset方法的时候重置其位置的索引,标记不总是被定义的,但是它一旦被定义，它不能为负或大于这个position, 如果定义了标记，那么当position 或 limit 调整到比标记小的值时,此标记会被丢弃。如果没有定义标记，则调用reset方法将引发InvalidMarkException。

## Invariants  不变性

`0` `<=` *mark* `<=` *position* `<=` *limit* `<=` *capacity*

新建的缓冲区位置始终为0，缓冲区的每个元素初始化为零

## Clearing, flipping, and rewinding 清空，翻转和倒带

除了访问位置，限制和容量值以及标记和重置的方法之外，此类还在缓冲区上定义了以下操作：

clear() 使缓冲区为通道读取或相对放置操作的新序列做好准备, 清空缓冲区,并将容量和位置的positon设置为零

flip() 使缓冲区为通道读取或相对放置操作的新序列做好准备 将limit设置为 当前位置,然后将position设置为零

rewind() 使缓冲区为通道读取或相对放置操作的新序列做好准备保持limit不变, 将position设置为零

## Read-only buffers 只读缓冲区

每个缓冲区都是可读的,但并不是每个缓冲区都是可写的,当在只读缓冲区上调用时，这些操作将抛出ReadOnlyBufferException

一个只读缓冲区不允许改变其内容,但是 mark,position 和 limit 是可变得, 一个Buffer 得 read-only 属性通过isReadOnly 方法修改.

## Thread safety 线程安全

多个并发线程使用缓冲区是不安全的, 如果有多个线程使用一个缓冲区,则应通过适当的同步来控制缓冲区的访问.

## Invocation chaining 调用链

支持调用链

```java
b.flip().position(23).limit(42);
```





​	

