# ScheduledExecutorService

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

