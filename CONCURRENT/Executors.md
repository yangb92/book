# Executors

用于在此包中定义的Executor、ExecutorService、ScheduledExecutorService、ThreadFactory和Callable类的工厂和实用方法

- Methods that create and return an [`ExecutorService`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ExecutorService.html) set up with commonly useful configuration settings.
- Methods that create and return a [`ScheduledExecutorService`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ScheduledExecutorService.html) set up with commonly useful configuration settings.
- Methods that create and return a "wrapped" ExecutorService, that disables reconfiguration by making implementation-specific methods inaccessible.
- Methods that create and return a [`ThreadFactory`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ThreadFactory.html) that sets newly created threads to a known state.
- Methods that create and return a [`Callable`](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/Callable.html) out of other closure-like forms, so they can be used in execution methods requiring `Callable`.