# 多线程

## Executor

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

----------------

## ExecutorService

```java
public interface ExecutorService
extends Executor
```

一个Executor，提供管理终止的方法和可以生成Future以跟踪一个或多个异步任务进度的方法。

-----------------------------

## ScheduledExecutorService

```java
public interface ScheduledExecutorService
extends ExecutorService
```

一个ExecutorService扩展, 可以延迟或者定期执行任务.调度功能。

schedule方法创建具有各种延迟的任务，并返回可用于取消或检查执行的任务对象。scheduleAtFixedRate和scheduleWithFixedDelay方法创建并执行定期运行的任务，直到被取消。

使用Executor.executor(Runnable) 和 ExecutorService.submit() 方法提交任务，请求的延迟为0，允许零延迟或负延迟,并视为请求立即执行 。

### Usage Example

Here is a class with a method that sets up a ScheduledExecutorService to beep every ten seconds for an hour:

```java
 import static java.util.concurrent.TimeUnit.*;
 class BeeperControl {
   private final ScheduledExecutorService scheduler =
     Executors.newScheduledThreadPool(1);

   public void beepForAnHour() {
     final Runnable beeper = new Runnable() {
       public void run() { System.out.println("beep"); }
     };
     final ScheduledFuture<?> beeperHandle =
       scheduler.scheduleAtFixedRate(beeper, 10, 10, SECONDS);
     scheduler.schedule(new Runnable() {
       public void run() { beeperHandle.cancel(true); }
     }, 60 * 60, SECONDS);
   }
 }
```

-------------

## Executors

用于在此包中定义的Executor、ExecutorService、ScheduledExecutorService、ThreadFactory和Callable类的工厂和实用方法

- Methods that create and return an [`ExecutorService`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ExecutorService.html) set up with commonly useful configuration settings.
- Methods that create and return a [`ScheduledExecutorService`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ScheduledExecutorService.html) set up with commonly useful configuration settings.
- Methods that create and return a "wrapped" ExecutorService, that disables reconfiguration by making implementation-specific methods inaccessible.
- Methods that create and return a [`ThreadFactory`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ThreadFactory.html) that sets newly created threads to a known state.
- Methods that create and return a [`Callable`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Callable.html) out of other closure-like forms, so they can be used in execution methods requiring `Callable`.