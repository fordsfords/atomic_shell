# atomic_shell
Misc shell script utilities for atomic operations.

These scripts are not guaranteed atomic across different hosts. The user
should execute these scripts on the same host, possibly using ssh, to
ensure proper atomic operation.

They rely on a mutex file. This file should be located on host-local storage,
like /tmp. It is a world of pain to try to locate these files on NFS and
expect different hosts to have temporally-consistent views of the files.

These scripts do not make use of traditional Unix lock operations, like
"flock". Rather it leverages the atomic nature of bash appending data to
a file, and the roughly atomic operation of the "mv" command.

By virtue of running on the same host, these tools can recover from various
failures. For example, if you "kill -9" a process that is holding a lock,
a process waiting on the lock will detect the fact that the process holding
the lock is gone, and will clean up the lock. Thus, even an abrupt power
failure will not result in "stuck locks" hanging around.

Note that the mutex operations require that you pass in a PID. This should
be the PID of the process that will be holding the lock. This can be tricky
if you over-modularize your code. For example, you might have a shell script,
"init.sh" that, among other things, locks a mutex. A later script, "cleanup.sh"
unlocks it. If those scrips pass "$$" as the PID parameter, it won't work.
This is because the "init.sh" script has its own PID, which goes away when
the script returns. This effectively unlocks the mutex, allowing another
program to take the lock. The recommended way of using the mutex operations
is to keep the code simple and straight-line. For example:

```
mlock.sh /tmp/test.mutex $$
do something short and sweet
munlock.sh /tmp/test.mutex $$
```

Here's a summary of the tools:

* mlock.sh - lock a mutex file.
* munlock.sh - unlock a mutex file.
* nextint.sh - increment a counter within a range (with wrap).
