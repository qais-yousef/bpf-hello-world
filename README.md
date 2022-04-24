# bpf-hello-world

Blue print for a new BPF CO-RE program. Feel free to fork and use as a blue
print for your new BPF CO-RE program :-)

See this [blog post](https://layalina.io/2022/04/23/intro-to-bpf-co-re.html)
for intro into BPF CO-RE.

# Compile

```
make
```

Override `ARCH` which is set to arm64 by default.

```
make ARCH=x86
```

### clean

```
make clean
```

# Run

From one terminal window:

```
sudo ./hello_world
```

From another terminal window:

```
sudo cat /sys/kernel/tracing/trace_pipe
```

`CTRL+c` to interrupt and exit program.
