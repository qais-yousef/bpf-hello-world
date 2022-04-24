#include <bpf/libbpf.h>
#include <signal.h>
#include <stdio.h>

#include "hello_world.skel.h"

static volatile bool exiting = false;

static void sig_handler(int sig)
{
	exiting = true;
}

int main(int argc, char **argv)
{
	struct hello_world_bpf *skel;
	int err;

	signal(SIGINT, sig_handler);
	signal(SIGTERM, sig_handler);

	skel = hello_world_bpf__open();
	if (!skel) {
		fprintf(stderr, "Failed to open and load BPF skeleton\n");
		return 1;
	}

	err = hello_world_bpf__load(skel);
	if (err) {
		fprintf(stderr, "Failed to load and verify BPF skeleton\n");
		goto cleanup;
	}

	err = hello_world_bpf__attach(skel);
	if (err) {
		fprintf(stderr, "Failed to attach BPF skeleton\n");
		goto cleanup;
	}

	while (!exiting);

cleanup:
	hello_world_bpf__destroy(skel);
	return err < 0 ? -err : 0;
}
