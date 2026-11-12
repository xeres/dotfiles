#!/usr/bin/env bats

@test "libatomic1 is installed" {
    dpkg-query --show --showformat='${Status}' libatomic1 | grep -q 'install ok installed'
}

@test "libatomic.so.1 is resolvable by the dynamic linker" {
    ldconfig -p | grep -q 'libatomic\.so\.1'
}
