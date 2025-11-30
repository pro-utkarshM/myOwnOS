# TODO — Building My Own Operating System (From Scratch)

**Author:** Utkarsh Maurya  
**Repository:** myOwnOS-dev-env  
**Goal:** Build a complete x86 operating system from scratch — from bootloader to kernel, paging to userland, networking, and eBPF-style observability.

---

## Development Environment

- **Host OS:** Linux (Ubuntu/Debian)
- **Languages:** Assembly + C
- **Tools:** nasm, gcc, ld, qemu, make, objdump, gdb
- **Testing:** QEMU with serial output and GDB debugging

---

# Phase 1: Bootloader & Kernel Entry (Completed)

### Bootloader (boot.asm)
**Goal:** Load the kernel into memory and enter 32-bit protected mode.

- [x] Enable A20 line
- [x] Set up GDT (Global Descriptor Table)
- [x] Switch to Protected Mode (CR0.PE = 1)
- [x] Jump to kernel entry point
- [x] Load kernel from HDD using BIOS interrupts
- [x] Implement basic print routine (BIOS teletype)
- [x] Create build and run scripts (`build.sh`, `run_qemu.sh`)
- [x] Write a custom Makefile

**Verification:** System boots and prints a kernel message after loading from disk.

---

# Phase 2: Core Kernel Initialization (Completed)

### Protected Mode Kernel
**Goal:** Establish a clean environment for C code execution.

- [x] Clear BSS section
- [x] Set up kernel stack
- [x] Initialize GDT (flat segmentation model)
- [x] Call `kmain()` in C

### I/O and Interrupt Setup
**Goal:** Enable low-level hardware communication.

- [x] Implement port I/O (`inb`, `outb`, `inw`, `outw`)
- [x] Initialize the Interrupt Descriptor Table (IDT)
- [x] Implement ISR stubs (assembly + C handlers)
- [x] Initialize and remap the Programmable Interrupt Controller (PIC)
- [x] Implement `sti()` and `cli()` for interrupt control
- [x] Configure timer (IRQ0, PIT)
- [x] Configure keyboard interrupt (IRQ1)
- [x] Verify interrupts using serial or screen output

---

# Phase 3: Memory Management (Partially Completed)

### Paging
**Goal:** Introduce virtual memory management.

- [x] Identity-map kernel memory (0x00000000 - 0x00400000)
- [x] Create page directory and first page table
- [x] Enable paging (CR3 + CR0.PG = 1)
- [ ] Implement kernel page allocator (`alloc_page`, `free_page`)
- [ ] Handle page faults (ISR 14)
- [ ] Add support for mapping and unmapping pages dynamically

### Heap Memory
**Goal:** Implement dynamic memory allocation for kernel data structures.

- [x] Implement block-based heap allocator
- [ ] Add `kmalloc()` / `kfree()` wrappers
- [ ] Implement aligned allocations
- [ ] Add heap expansion support using paging

### Virtual Memory Enhancements
- [ ] Add allocation tracking and debugging
- [ ] Implement per-process address spaces
- [ ] Log page faults with register state

---

# Phase 4: Task State Segment (TSS) & Multitasking

### Task State Segment (TSS)
**Goal:** Enable privilege transitions between kernel and user space.

- [ ] Define TSS structure (`tss_entry_t`)
- [ ] Set `esp0` and `ss0` for kernel stack switching
- [ ] Load TSS descriptor into GDT
- [ ] Load TSS using `ltr` instruction
- [ ] Verify privilege transitions between rings

### Multitasking (Round-Robin)
**Goal:** Run multiple processes concurrently.

- [ ] Define `task_t` structure (registers, stack, page directory)
- [ ] Implement context switching (`switch_task()`)
- [ ] Implement timer-based preemption (IRQ0)
- [ ] Maintain a ready queue of tasks
- [ ] Add idle task
- [ ] Create `create_task(func)` to spawn new tasks

### Advanced Scheduling
- [ ] Implement priority-based scheduling
- [ ] Add sleep/wait mechanisms
- [ ] Enable process-specific memory spaces

---

# Phase 5: Disk I/O & File Systems

### ATA PIO Driver
**Goal:** Implement low-level disk sector read/write.

- [ ] Implement `ata_read(sector, count, buffer)`
- [ ] Implement `ata_write(sector, count, buffer)`
- [ ] Poll drive status registers for readiness
- [ ] Handle drive selection and command setup
- [ ] Detect connected drives (primary/secondary)

### FAT16 File System
**Goal:** Implement a simple FAT16 file system driver.

- [ ] Parse BIOS Parameter Block (BPB)
- [ ] Load FAT table into memory
- [ ] Implement directory listing
- [ ] Implement file read operations
- [ ] Implement file write operations
- [ ] Mount FAT16 as root filesystem (`/`)

### Virtual File System (VFS)
**Goal:** Create an abstraction layer for file systems.

- [ ] Define `vnode` and `vfs_mount` structures
- [ ] Register supported file systems
- [ ] Implement VFS operations (`open`, `read`, `write`, `close`)
- [ ] Mount FAT16 as root
- [ ] Initialize `/dev` and `/bin` directories

---

# Phase 6: Userland & Shell

### Keyboard Input
**Goal:** Implement PS/2 keyboard driver.

- [ ] Convert scancodes to ASCII
- [ ] Handle key release and modifier keys
- [ ] Maintain input buffer
- [ ] Provide `getchar()` for userland programs

### User Programs
**Goal:** Execute user programs from disk.

- [ ] Implement flat binary loader
- [ ] Allocate user stack and code segment
- [ ] Implement syscalls
- [ ] Switch from ring 0 to ring 3
- [ ] Return control to kernel on interrupt/syscall

### Shell
**Goal:** Create a minimal command-line shell.

- [ ] Display prompt (`myOS>`)
- [ ] Implement core commands:
  - [ ] `help`
  - [ ] `ls`
  - [ ] `cat`
  - [ ] `reboot`
- [ ] Optional: history and command parsing improvements

---

# Phase 7: Networking Stack

### NIC Driver (QEMU rtl8139 / e1000)
**Goal:** Initialize and communicate with a virtual network card.

- [ ] Detect PCI devices
- [ ] Map MMIO registers
- [ ] Initialize RX/TX ring buffers
- [ ] Handle NIC interrupts
- [ ] Transmit and receive Ethernet frames

### Network Stack Layers

**Ethernet (Layer 2)**
- [ ] Parse destination/source MAC and Ethertype
- [ ] Register protocol handlers (ARP, IP)

**IPv4 (Layer 3)**
- [ ] Parse IP headers
- [ ] Implement checksum verification
- [ ] Implement ICMP (ping)
- [ ] Create routing table (static)

**UDP (Layer 4)**
- [ ] Implement UDP header creation
- [ ] Send and receive datagrams
- [ ] Map to userland socket API

**TCP (Stretch Goal)**
- [ ] Implement 3-way handshake
- [ ] Support basic send/receive streams

### Network Utilities
- [ ] netping — send ICMP echo requests
- [ ] netcat — send and receive UDP packets
- [ ] netstat — display connection table

---

# Phase 8: eBPF-Inspired Observability

### eBPF Virtual Machine
**Goal:** Implement a minimal bytecode interpreter for safe kernel instrumentation.

- [ ] Define instruction set (registers, ALU ops, jumps)
- [ ] Implement interpreter
- [ ] Add verifier for bounded loops and memory safety
- [ ] Implement map types (array, hash)
- [ ] Add syscalls to load and execute programs

### Attach Points
- [ ] Syscall entry and exit
- [ ] Network RX/TX
- [ ] Timer tick
- [ ] Custom kernel tracepoints

### Example Programs
- [ ] syscall_counter — count syscalls
- [ ] net_monitor — track packets per protocol
- [ ] perf_trace — monitor interrupts and context switches

---

# Phase 9: Debugging & Tooling

- [ ] Enable serial port (COM1) debugging
- [ ] Implement panic with stack trace
- [ ] Add kernel symbol table for backtraces
- [ ] Enable remote GDB debugging via QEMU (`qemu -s -S`)
- [ ] Create `debug_qemu.sh` helper script

---

# Phase 10: Polishing & Long-Term Goals

- [ ] Implement ELF loader for user programs
- [ ] Add dynamic linker (optional)
- [ ] Define syscall table and handler stubs
- [ ] Implement kernel log buffer (`dmesg` equivalent)
- [ ] Add `/proc` pseudo-filesystem
- [ ] Create `init` process
- [ ] Implement framebuffer-based GUI (long-term)

---

# Milestone Summary

| Milestone | Focus | Status |
|------------|--------|--------|
| M1 | Bootloader and Protected Mode | Completed |
| M2 | Interrupts, Paging, Heap | Completed |
| M3 | TSS and Multitasking | In Progress |
| M4 | File System and VFS | Pending |
| M5 | Userland and Shell | Pending |
| M6 | Networking Stack | Pending |
| M7 | eBPF Observability | Planned |

---
