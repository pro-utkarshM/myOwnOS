# Building My Own Operating System (From Scratch)

Hey! I'm **Utkarsh Maurya**, and you’ve just landed in the heart of one of my most ambitious projects: writing a complete operating system from scratch.

This isn’t just a side project — this is me, going full throttle into the depths of low-level computing. From booting off a raw binary, enabling the A20 line, all the way into protected mode, writing my own interrupt handlers, and doing HDD I/O — everything is custom-built, step by step.

No frameworks. No shortcuts. Just real, bare-metal coding.
Want to try it out: go to [myOwnOS-dev-env](https://github.com/pro-utkarshM/myownos-dev-env), this is where you want to start.

---

## What’s This Project About?

I wanted to **understand how computers really work** — not just run code on top of a stack of abstractions, but build the stack *myself*. That meant starting from the boot sector and climbing my way up toward user programs, a file system, multitasking, and more.

This OS is being built using:
- **Assembly + C**
- My dev environment is Linux (Ubuntu/Debian-based)
- Tools: `nasm`, `gcc`, `qemu`, `make`, and raw grit

---

## What’s Already Done?

> "Building my own OS from scratch — user space is up and running."

Here’s what’s already been checked off:

- 🔸 Bootloader (boot.asm)
- 🔸 A20 line enabled
- 🔸 Protected mode entered (manually, and cleanly)
- 🔸 Kernel written in C with assembly glue
- 🔸 Custom `Makefile`, build scripts (`build.sh`, `run_qemu.sh`)
- 🔸 HDD sector reads working
- 🔸 BIOS Parameter Block implemented
- 🔸 Playing around with the interrupt table
- 🔸 First userland code runs!
- 🔸 Set up **Interrupt Descriptor Table (IDT)** fully
- 🔸 Refine **in/out I/O ops**

Every commit tells a story — from `"Big Bang"` to `"avg. hello world program.."` and `"playing with my interrupt table"` — this repo is more than just code. It’s a timeline of curiosity and deep dives.

---

## What’s Next?

Here’s what’s still cooking:

- [ ] Implement **Paging**
- [ ] Setup **TSS (Task State Segment)**
- [ ] Finalize **IRQ Handling**
- [ ] Expand **HDD I/O (PIO mode)**
- [ ] Finish **FAT16 File System + VFS**
- [ ] Kernel panic screens & graceful error handling
- [ ] Virtual keyboard input
- [ ] Run proper **user programs**
- [ ] Basic shell interface
- [ ] Implement **multitasking**

---

## Big Thanks

Two resources have been absolute game-changers:
- [OSDev.org](https://osdev.org) – the holy grail for OS developers
- low lEU – super clear explanations for tough concepts

If you're even thinking of writing your own OS, start there. And then... just start.

---

## Want to Follow or Contribute?

Clone the repo, follow along, or just shoot me a message if you’re building something similar. Happy to learn, share, and nerd out together.

**Next up: IDT, paging, and VFS. Let's go.**

— Utkarsh Maurya

---
