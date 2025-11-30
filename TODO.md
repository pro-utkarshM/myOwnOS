# TODO — Build My Own Operating System (From Scratch)

**Author:** Utkarsh Maurya  
**Repository:** myOwnOS-dev-env  
**Goal:** Build a complete x86 operating system from scratch — from bootloader to kernel, paging to userland, networking, and modern observability.

---

## Development Environment

- **Host OS:** Linux (Debian/Ubuntu)
- **Languages:** Assembly, C (and later C++)
- **Toolchain:** `nasm`, `gcc`, `ld`, `make`, `qemu`, `gdb`
- **Optional Cross-Compiler:** `i686-elf-gcc`
- **Testing:** QEMU with GDB remote debugging

---

# Phase 1: Bootloader & Kernel Entry (Done)

### 1.1 Bootloader (16-bit Real Mode)
- [x] Enable A20 line
- [x] Set up GDT
- [x] Switch to Protected Mode (CR0.PE)
- [x] Load kernel sectors from disk using BIOS interrupts (INT 13h)
- [x] Simple print routine using BIOS teletype
- [x] Implement clean build/run scripts (`build.sh`, `run_qemu.sh`)
- [x] Custom Makefile
- [ ] Document memory map (bootloader + kernel)
- [ ] Add BIOS memory map detection via `INT 15h, E820h`
- [ ] Add boot banner and error codes for debugging

### 1.2 32-bit Protected Mode
- [x] Set up flat memory model
- [x] Jump to kernel C entry (`kmain`)
- [x] Prepare stack
- [x] Clear `.bss` section
- [ ] Relocate kernel to higher-half (`0xC0000000`) for modern layout
- [ ] Set up paging early for higher-half relocation

---

# Phase 2: Core Kernel Initialization

### 2.1 I/O and Interrupts
- [x] Implement port I/O (`inb/outb/inw/outw`)
- [x] Initialize IDT
- [x] Implement ISR stubs (exceptions 0–31)
- [x] Initialize PIC (remap IRQ0–15)
- [x] Enable IRQ0 (PIT) and IRQ1 (keyboard)
- [x] Implement `sti()` and `cli()`
- [x] Basic timer interrupt counter
- [ ] Print register dump on fault/interrupt
- [ ] Implement serial debugging (`COM1`)

### 2.2 PIT & Keyboard
- [x] PIT driver (IRQ0)
- [x] Keyboard interrupt handler
- [ ] Keymap translation (scancode → ASCII)
- [ ] Handle modifiers (Shift, Ctrl, Alt)
- [ ] Input buffer (for shell)

---

# Phase 3: Memory Management

### 3.1 Paging
- [x] Identity-map first 4MB
- [x] Enable paging (CR3 + CR0.PG)
- [ ] Page allocator (`alloc_page`, `free_page`)
- [ ] Dynamic page mapping/unmapping
- [ ] Page fault handler (ISR 14)
- [ ] Kernel page map visualization (`show_mappings`)
- [ ] Demand paging & lazy mapping
- [ ] Copy-on-Write (COW) for fork()

### 3.2 Kernel Heap
- [x] Basic heap (block-based)
- [ ] Implement `kmalloc()` / `kfree()`
- [ ] Implement aligned allocations
- [ ] Heap expansion via paging
- [ ] Leak detector and heap integrity check

### 3.3 Advanced Memory Systems
- [ ] Implement Buddy Allocator
- [ ] Implement Slab Allocator (for kernel objects)
- [ ] Per-process address spaces
- [ ] Virtual memory API (`mmap`, `munmap`)
- [ ] Huge pages (4MB)
- [ ] Physical memory map from BIOS (E820)
- [ ] Page coloring and caching policy (optional)

---

# Phase 4: TSS, Privilege Levels & Multitasking

### 4.1 Task State Segment (TSS)
- [ ] Define TSS structure
- [ ] Add TSS descriptor to GDT
- [ ] Load with `ltr`
- [ ] Set `esp0` and `ss0` for privilege transitions
- [ ] Verify stack switch on privilege change

### 4.2 Basic Tasking
- [ ] Define `task_t` (registers, stack, page directory)
- [ ] Implement context switch
- [ ] Create task queue
- [ ] Timer preemption (IRQ0)
- [ ] Add idle task
- [ ] Implement `create_task(func)`

### 4.3 Scheduling
- [ ] Round-robin scheduler
- [ ] Priority-based scheduling
- [ ] Sleep/wait queue
- [ ] Blocking/wake-up system
- [ ] Implement process states (READY, RUNNING, WAITING)
- [ ] Load balancing (for SMP later)

---

# Phase 5: Disk I/O & File Systems

### 5.1 ATA PIO Driver
- [ ] Detect primary/secondary drives
- [ ] Implement `ata_read()` / `ata_write()`
- [ ] Poll drive status registers
- [ ] Verify sector read/write in QEMU
- [ ] Add caching for sectors

### 5.2 FAT16 File System
- [ ] Parse BIOS Parameter Block (BPB)
- [ ] Load FAT table
- [ ] Directory listing
- [ ] Read files by cluster chain
- [ ] Write files
- [ ] Mount FAT16 as root (`/`)

### 5.3 Virtual File System (VFS)
- [ ] Define `vnode`, `vfs_mount`, `file_ops`
- [ ] `open`, `read`, `write`, `close`
- [ ] Register FAT16 with VFS
- [ ] Initialize `/dev`, `/bin`, `/proc`
- [ ] Implement pseudo-filesystems later (`procfs`, `sysfs`)

### 5.4 Ext2 (Advanced)
- [ ] Parse superblock/inodes
- [ ] Block caching layer
- [ ] Read/write ext2 files
- [ ] Mount/unmount multiple FS types

---

# Phase 6: Process Management & Syscalls

### 6.1 Syscalls
- [ ] Implement syscall interrupt (`int 0x80`)
- [ ] Define syscall table
- [ ] Implement core syscalls:
  - [ ] `write`, `read`, `open`, `close`
  - [ ] `fork`, `exec`, `waitpid`, `exit`
  - [ ] `getpid`, `sleep`, `kill`
- [ ] Implement `sysenter/syscall` fast path (optional)

### 6.2 ELF Loader
- [ ] Parse ELF headers
- [ ] Map segments into process memory
- [ ] Set up user stack
- [ ] Transfer control to user mode via `iret`
- [ ] Validate segment permissions

### 6.3 Process Management
- [ ] Implement process table
- [ ] Implement process state transitions
- [ ] Implement signal delivery system
- [ ] Process cleanup and zombie reaping
- [ ] Kernel threads vs. user processes

---

# Phase 7: Userland & Shell

### 7.1 Standard I/O
- [ ] Keyboard driver with ASCII
- [ ] Console output driver
- [ ] File descriptor abstraction (stdin/stdout/stderr)

### 7.2 Shell
- [ ] Command prompt (`myOS>`)
- [ ] `help`, `ls`, `cat`, `reboot`, `clear`
- [ ] Command parsing
- [ ] Command history
- [ ] Basic scripting support (batch file execution)

### 7.3 Userland Programs
- [ ] Implement simple `init` process
- [ ] Create example programs:
  - [ ] `echo`, `ps`, `sleep`, `malloc-test`
  - [ ] `netping`, `cat`, `top`
- [ ] Dynamic linking (optional)

---

# Phase 8: Networking Stack

### 8.1 Network Driver (rtl8139/e1000)
- [ ] PCI device detection
- [ ] Map MMIO registers
- [ ] Initialize TX/RX descriptors
- [ ] Interrupt handling
- [ ] Send/receive Ethernet frames

### 8.2 Protocol Layers
**Layer 2 — Ethernet**
- [ ] Parse MAC headers
- [ ] Register protocol handlers (ARP, IP)

**Layer 3 — IPv4**
- [ ] Parse IP headers
- [ ] Validate checksums
- [ ] Handle ICMP (ping)
- [ ] Routing table

**Layer 4 — UDP**
- [ ] Implement header construction
- [ ] `udp_send()`, `udp_recv()`

**Layer 4 — TCP (Advanced)**
- [ ] 3-way handshake
- [ ] Connection states
- [ ] Retransmission & congestion handling

### 8.3 Sockets API
- [ ] Implement `socket()`, `bind()`, `sendto()`, `recvfrom()`
- [ ] Support UDP first, TCP later
- [ ] `/dev/net` interface for debugging

### 8.4 Networking Tools
- [ ] `netping` — ICMP echo
- [ ] `netcat` — send/receive packets
- [ ] `netstat` — show connections
- [ ] `ifconfig` — show interfaces

---

# Phase 9: eBPF & Kernel Observability

### 9.1 eBPF Virtual Machine
- [ ] Define instruction set
- [ ] Implement interpreter
- [ ] Verifier for safety
- [ ] Implement map types (`array`, `hash`)
- [ ] eBPF syscalls (`bpf_load_program`, `bpf_map_update`)

### 9.2 Attach Points
- [ ] Syscalls
- [ ] Network RX/TX
- [ ] Scheduler events
- [ ] Timer ticks
- [ ] Custom tracepoints

### 9.3 Tools
- [ ] `syscall_counter`
- [ ] `net_monitor`
- [ ] `perf_trace`

---

# Phase 10: Multiprocessing (SMP)

- [ ] Enable APIC
- [ ] Detect CPU cores via ACPI/MADT
- [ ] Bootstrap secondary CPUs
- [ ] Per-CPU stacks & schedulers
- [ ] Inter-Processor Interrupts (IPI)
- [ ] Local APIC timers per CPU
- [ ] Load balancing between cores
- [ ] Spinlocks and atomic primitives
- [ ] Cross-CPU task migration

---

# Phase 11: Debugging & Tooling

- [ ] Serial debug log
- [ ] Kernel panic with stack trace
- [ ] Symbol resolution for backtraces
- [ ] `dmesg` buffer
- [ ] Remote GDB debugging (`qemu -s -S`)
- [ ] `debug_qemu.sh` script
- [ ] Memory dump utility
- [ ] Kernel profiling (timer + counters)

---

# Phase 12: Advanced & Research-Level Systems

### 12.1 Kernel Architecture
- [ ] Microkernel mode (move drivers to user space)
- [ ] Hybrid kernel experiments
- [ ] Capability-based security model

### 12.2 Performance & Security
- [ ] Kernel ASLR
- [ ] Stack canaries
- [ ] Guard pages
- [ ] Measure syscall latency and context switch time

### 12.3 Virtualization
- [ ] Implement basic VMM (VMX/SVM)
- [ ] Virtual memory introspection
- [ ] Guest process monitoring

### 12.4 Self-Hosting
- [ ] Port a small compiler (TinyCC)
- [ ] Compile a program inside your OS
- [ ] Compile your own kernel inside itself (self-hosting milestone)

---

# Phase 13: Optional Research Extensions

- [ ] Exokernel (apps manage hardware)
- [ ] Rust-based kernel port
- [ ] Formal verification of MMU or scheduler
- [ ] Log-structured filesystem (LFS)
- [ ] Deterministic replay debugger
- [ ] Kernel-in-userspace mode for fast testing
- [ ] Distributed file system (mini NFS)

---

# Milestone Summary

| Milestone | Focus | Status |
|------------|--------|--------|
| M1 | Bootloader & Protected Mode | Completed |
| M2 | Interrupts & Basic Paging | Completed |
| M3 | Heap, Page Allocator | In Progress |
| M4 | TSS & Multitasking | Pending |
| M5 | File Systems & VFS | Pending |
| M6 | Syscalls & ELF Loader | Pending |
| M7 | Userland & Shell | Pending |
| M8 | Networking Stack | Planned |
| M9 | eBPF & Observability | Planned |
| M10 | SMP & Optimization | Planned |
| M11 | Debugging & Tooling | Planned |
| M12 | Research Extensions | Optional |

---

# Immediate Next Steps

1. Finalize kernel page allocator and page fault handler.  
2. Implement TSS and prepare for user-mode transition.  
3. Build round-robin multitasking with two dummy tasks.  
4. Begin ATA driver and simple FAT16 reader.  
5. Read Intel Manual Vol. 3A (System Programming).  
6. Document memory map, interrupt vector layout, and page layout in `/docs/`.  

---

**Endgame:**  
A self-hosting, multitasking, networked, traceable, and observable OS — capable of compiling and debugging itself.  
Once achieved, you’ll have mastered every major system in modern computing.
