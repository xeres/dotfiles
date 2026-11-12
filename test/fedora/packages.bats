#!/usr/bin/env bats

@test "libatomic is installed" {
    rpm -q libatomic
}

@test "libatomic.so.1 is resolvable by the dynamic linker" {
    ldconfig -p | grep -q 'libatomic\.so\.1'
}
