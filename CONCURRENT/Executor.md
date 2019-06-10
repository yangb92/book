# Executor

```java
public interface Executor
```

该接口提供了一个方法, 执行Runnable对象的任务。

**提供了一种可以将任务本身和任务的运行机制(包括线程使用, 调度等细节)分离开来的方法** 

通常使用执行器而不是显试的创建线程。

例如：你不是为每一个任务去创建线程 `new Thread(new(RunnableTask())).start()`你可以使用

```java
Executor executor = anExecutor;
 executor.execute(new RunnableTask1());
 executor.execute(new RunnableTask2());
 ...
```

然而，Executor 接口并不严格要求执行是异步的，最简单的情况如下，执行程序可以立即在调用者的线程中运行提交的任务。

```java
 class DirectExecutor implements Executor {
   public void execute(Runnable r) {
     r.run();
   }
 }
```

