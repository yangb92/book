# [Channels](<https://docs.oracle.com/javase/8/docs/api/java/nio/channels/package-summary.html>)

*2019-6-12* 

## 概述

定义通道，能够和I/O操作的实体连接，比如 文件，socket， 定义选择器, 用于多路复用, 非阻塞式I/O操作。

**通道介绍：**

Channel	I/O 操作的连接点
  ReadableByteChannel	读取到缓存
    ScatteringByteChannel  	读取到一系列缓存
  WritableByteChannel	写入到缓存
    GatheringByteChannel	写入到一系列缓存
  ByteChannel	能够读/写缓存
    SeekableByteChannel	ByteChannel连接到包含可变长度字节序列的实体
  AsynchronousChannel	支持异步I/O操作
    AsynchronousByteChannel	异步读写字节
  NetworkChannel	网络通道
    MulticastChannel	加入Internet协议（IP）组
Channels	用于流和通道互操作的实用方法

通道(channel)表示与实体,诸如硬件设备,文件，网络 或者一个程序模块能够执行一个或多个不同的I/O操作的开放连接, 比如读或写。它们都是异步关闭的，也都是可中断的。

通道通常用于多线程访问，对多线程访问安全，

[Channel](https://docs.oracle.com/javase/8/docs/api/java/nio/channels/Channel.html)  接口由其他几个接口扩展。

[ReadableByteChannel](https://docs.oracle.com/javase/8/docs/api/java/nio/channels/ReadableByteChannel.html)接口定义了 `read` 方法从通道中读取字节至缓冲区(buffer),相应的[WritableByteChannel](https://docs.oracle.com/javase/8/docs/api/java/nio/channels/WritableByteChannel.html)接口定义了 write 方法将字节从缓冲区写入通道，ByteChnnel 接口结合这两个接口，能够实现常见的读取和写入字节的操作 [SeekableByteChannel](https://docs.oracle.com/javase/8/docs/api/java/nio/channels/SeekableByteChannel.html) 接口继承了ByteChnnel接口，以查询和修改通道的当前位置以及其大小。

 [`ScatteringByteChannel`](https://docs.oracle.com/javase/8/docs/api/java/nio/channels/ScatteringByteChannel.html) and [`GatheringByteChannel`](https://docs.oracle.com/javase/8/docs/api/java/nio/channels/GatheringByteChannel.html) 接口继承了ReadableByteChannel和WritableByteChannel接口，分别添加了读取和写入的方法，这些方法使用了缓冲区序列而不是单个缓冲区。

[`NetworkChannel`](https://docs.oracle.com/javase/8/docs/api/java/nio/channels/NetworkChannel.html) 接口制定绑定通道套接字的方法，获取地址和Socket绑定,以及get 和 set socket 的方法。MulticastChannel 接口指定了加入Internet协议(IP)多播组的方法。

Channels 中的程序类定义了静态方法， 支持和java.io 包的 stream类与此包的通道类的互操作。可以从InputStream和OutputStream构造适当的通道。反过来 InputStream 和 OutputStream也可以由通道构造，可以构造一个Reader，它使用给定的字符集来解码来自给定可读字节通道的字节。反过来，可以构造一个Writer，它使用给定的字符集将字符编码为字节并将他们写入给定的可写字节通道。

**文件通道介绍**

ileChannel	读取，写入，映射和操作文件。
FileLock	锁定一个文件或区域
MappedByteBuffer  	映射到文件区域的直接字节缓冲区(A direct byte buffer mapped to a region of a file)。

FileChannel 支持从连接到文件的通道读取字节和向通道写入字节的常见操作，以及查询和修改当前文件的位置并将文件截断到指定大小的方法，它定义了获取整个文件或文件上特定区域的锁的方法, 这些方法返回FileLock 类的实例, 最后，它定义了强制修改文件和写入到包含改文件存储设备的方法,用于在文件和其他通道之间有效地传输字节，以及将文件的区域直接映射到存储器中。

FileChannel是通过调用它的一个静态open方法创建的,或者调用FileInputStream,FileOutputStream或RandomAcessFile的getChannel方法来返回到与java.io类相同的底层文件通道。

**Multiplexed, non-blocking I/O Description** 多路复用的非阻塞式I/O描述

SelectableChannel	一个可多路复用的通道
  DatagramChannel	面向数据报的套接字的通道
  Pipe.SinkChannel	管道的写入端
  Pipe.SourceChannel	管道的读取端
  ServerSocketChannel  	面向流的监听套接字通道
  SocketChannel	面向流的连接套接字通道
Selector	一个可选通道的多路复用器
SelectionKey	通道选择器的注册令牌
Pipe	两个通道形成单向管道

多路复用非阻塞式I/O，这比面向线程的阻塞式I/O更具扩展性。由选择器，可选通道和选择键提供这些扩展性。

选择器是可选择通道的多路复用器，而这又是一种特殊类型的通道，可以进入非阻塞模式，为了执行多路复用I/O的操作，首先创建一个或者多个可选通道，进入非阻塞模式，并在选择器中注册。注册通道指定将由选择器测试准备状态的一组输入/输出操作，并返回表示注册的选择键。

一旦使用选择器注册了某些通道，`这一执行选择操作以便发现这些通道`，就可以执行选择操作以便发现哪些信道（如果有的话）已经准备好执行先前声明了兴趣的一个或多个操作。 如果某个频道已准备就绪，则注册时返回的密钥将被添加到选择器的选定密钥集中。 可以检查密钥集及其中的密钥，以便确定每个信道准备好的操作。 从每个密钥可以检索相应的信道，以便执行所需的任何I / O操作。

selection key 表示这个通道已经准备好进行某些操作,这只是一个提示，但不能保证，这样的操作可以由线程执行而不会导致线程阻塞。必须编写执行多路复用的I/O代码, 以便在证明它们不正确时忽略这些提示。

该包定义了与java.net包中定义的DatagramSocket, ServerSocket和Socket类相对应的可选通道类，对这些类进行了少量更改，以便支持与通道关联的套接字。该包还定义了一个实现单向管道的简单类. 在所有情况下，通过调用对应类的静态open方法创建一个新的可选通道。如果通道需要关联的Socket，那么这个操作的副作用就是创建一个套接字。

选择器、可选通道和选择键的实现可以通过“插入”java.nio.channels.spi包中定义的SelectorProvider类的替代定义或实例来替换。预计很多开发人员不会使用它，它主要是为了高级用户在需要非常高的性能时可以利用特定操作系统的I/O多路复用机制。

实现多路复用I / O抽象所需的大部分簿记和同步由java.nio.channels.spi包中的AbstractInterruptibleChannel，AbstractSelectableChannel，AbstractSelectionKey和AbstractSelector类执行。 定义自定义选择器提供程序时，只应将AbstractSelector和AbstractSelectionKey类直接子类化; 自定义通道类应扩展此包中定义的相应SelectableChannel子类。

异步I/O描述

AsynchronousFileChannel	用于读取,写入和操作文件的异步通道。
AsynchronousSocketChannel	面向流的连接套接字异步通道。
AsynchronousServerSocketChannel  	面向流的监听套接字异步通道。
CompletionHandler	用于消费异步操作结果的处理程序
AsynchronousChannelGroup	一组异步通道，用户资源共享。

异步通道是一种特殊类型的通道，能够进行异步I/O操作，异步通道时非阻塞的，并且定义了启动异步操作的 方法，返回表示每个操作的挂起结果的Future，Future可用于轮询或等待操作的结果,异步I / O操作还可以指定在操作完成时调用的CompletionHandler,完成处理程序是用户提供的代码，执行该代码以消耗I / O操作的结果。

这个包定义了异步通道类，这些类连接到面向流的连接套接字或侦听套接字，或面向数据流的套接字,它还定义了用于异步读取、写入和操作文件的asynousfilechannel类。与FileChannel一样，它支持将文件截断到特定大小的操作,强制更新要写入存储设备的文件，或获取整个文件或文件特定区域的锁。 与FileChannel不同，它没有定义将文件区域直接映射到内存的方法。 在需要内存映射I / O的情况下，可以使用FileChannel。

出于资源共享的目的，异步通道被绑定到异步通道组。一个组有一个相关的执行服务，任务被提交给该服务来处理输入/输出事件，并分派给使用在组中的通道上执行的异步操作的结果的完成处理程序。创建通道时可以选择指定组，或者通道可以绑定到默认组。老练的用户可能希望创建自己的异步通道组，或者配置将用于默认组的ExecutorService。

与选择器一样，异步通道的实现可以被“插入”Java . nio . channel . SPI包中定义的异步通道提供程序类的替代定义或实例所替代。预计许多开发人员不会真正利用这一设施；它的提供主要是为了当需要非常高的性能时，复杂的用户可以利用特定于操作系统的异步输入/输出机制。

除非另有说明，否则将null参数传递给此包中的任何类或接口中的 构造函数或方法将引发NullPointerException。