#!/usr/bin/env bats

# libatomic is required by node: nodejs.org official Linux builds
# dynamically link libatomic.so.1.

@test "libatomic is installed" {
    rpm -q libatomic
}

@test "libatomic.so.1 is resolvable by the dynamic linker" {
    ldconfig -p | grep -q 'libatomic\.so\.1'
}
