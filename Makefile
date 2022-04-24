BINARY := hello_world
ARCH ?= arm64

all:
	git submodule init
	git submodule update

	make -C libbpf/src BUILD_STATIC_ONLY=1 DESTDIR=$(abspath bpf) install

	bpftool btf dump file /sys/kernel/btf/vmlinux format c > vmlinux.h

	clang -g -O2 -Wall -target bpf -D__TARGET_ARCH_$(ARCH) \
		-I bpf/usr/include -c $(BINARY).bpf.c -o $(BINARY).bpf.o

	llvm-strip -g $(BINARY).bpf.o

	bpftool gen skeleton $(BINARY).bpf.o > $(BINARY).skel.h

	cc -g -O2 -Wall -I bpf/usr/include -c $(BINARY).c -o $(BINARY).o

	cc -g -O2 -Wall -I bpf/usr/include $(BINARY).o \
		bpf/usr/lib64/libbpf.a -lelf -lz -o $(BINARY)

clean:
	make -C libbpf/src clean
	rm -rf bpf *.o vmlinux.h *.skel.h $(BINARY)
