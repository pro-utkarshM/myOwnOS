> How to Write Your Own Operating System: A Beginner's Guide

Hello, my name is Utkarsh Maurya, and in this blog post, I'm going to guide you through the process of writing your own operating system. Before we dive in, I want to thank two invaluable resources, .org and lowl EU, which have been instrumental in my learning journey. 

## Getting Started

To follow along with this tutorial, I recommend using Linux Mint 17. Although the specific processor you use is not crucial, aligning your setup with mine can help ensure consistency.

### Required Software

You'll need the following software to write your operating system:

- GCC (GNU Compiler Collection) for C++ (`g++`)
- GNU Assembler (`as`)
- `libc6-dev-i386` package

From this, you might deduce that we'll be writing our OS in C++. While many prefer C for its speed, I prefer C++ for its object-oriented programming capabilities. Procedural programming feels outdated to me, and though you can do quasi-object-oriented programming in C, it often feels unnatural and hackish. C++ strikes a balance between performance and modern programming paradigms.

## Understanding the Boot Process

Before we start coding, let's talk about what happens when you start your computer:

1. **BIOS**: Your mainboard has a BIOS (Basic Input/Output System) that initializes and tests hardware components and loads the bootloader from the hard drive.
2. **Bootloader**: This is the first piece of software that runs when your computer starts. We'll be using the GRUB bootloader in this tutorial.
3. **Kernel**: The bootloader loads the kernel, which is the core part of the operating system.

### Basic Components

- **BIOS**: The BIOS contains firmware that initializes hardware during the booting process.
- **Bootloader (GRUB)**: The bootloader loads the operating system kernel into memory and starts it.
- **Kernel**: The kernel manages system resources and hardware-software communication.

### Registers and Memory

Understanding CPU registers and memory is essential. When the CPU starts, it uses the instruction pointer to execute firmware from the BIOS, which then loads the bootloader into RAM. The bootloader loads the kernel and sets up the necessary environment for it to run.

## Writing Your Kernel

We'll start by creating a simple kernel that prints a message to the screen. Here's a step-by-step guide to writing your kernel in C++.

### Setting Up the Environment

Create a directory for your project and the following files:
- `loader.s` (assembly file to set up the stack pointer)
- `kernel.cpp` (C++ file for the kernel)
- `link.ld` (linker script)
- `Makefile` (to automate the build process)

### Makefile

Your Makefile should include rules to compile and link your assembly and C++ code. Here’s a simple example:

```makefile
AS = as --32
LD = ld -m elf_i386
GPP = g++ -m32

all: mykernel.bin

loader.o: loader.s
    $(AS) -o loader.o loader.s

kernel.o: kernel.cpp
    $(GPP) -c -o kernel.o kernel.cpp

mykernel.bin: loader.o kernel.o
    $(LD) -T link.ld -o mykernel.bin loader.o kernel.o

clean:
    rm -f *.o mykernel.bin
```

### Kernel in C++

In `kernel.cpp`, we define the main function of our kernel:

```cpp
extern "C" void kernel_main() {
    const char *str = "Hello, Operating System!";
    char *video_memory = (char*) 0xb8000;
    for (int i = 0; str[i] != '\0'; ++i) {
        video_memory[i * 2] = str[i];
        video_memory[i * 2 + 1] = 0x07; // White text on black background
    }
    while (1); // Infinite loop to prevent the kernel from exiting
}
```

### Loader Assembly

In `loader.s`, we set the stack pointer and call the C++ kernel function:

```asm
.section .multiboot
    .align 4
    .long 0x1BADB002  // Magic number
    .long 0x00        // Flags
    .long -(0x1BADB002 + 0x00)  // Checksum

.section .text
.global _start
_start:
    cli                 // Disable interrupts
    mov $0x90000, %esp  // Set stack pointer
    call kernel_main    // Call kernel_main in kernel.cpp
    hlt                 // Halt the CPU
```

### Linker Script

In `link.ld`, we specify the memory layout:

```ld
ENTRY(_start)
SECTIONS
{
    . = 0x100000;

    .text : {
        *(.multiboot)
        *(.text)
    }

    .data : {
        *(.data)
    }

    .bss : {
        *(.bss)
    }
}
```

## Compiling and Running

To compile and run your kernel:

1. Run `make` to compile your code.
2. Copy `mykernel.bin` to the boot directory.
3. Add an entry to your GRUB configuration:

```plaintext
menuentry "My Operating System" {
    multiboot /boot/mykernel.bin
    boot
}
```

4. Reboot your computer and select "My Operating System" from the GRUB menu.

## Conclusion

Congratulations! You've just written a basic operating system kernel. While this is a simple example, it lays the groundwork for more advanced features. In the next post, I'll show you how to install and test your operating system in a virtual machine, which will save you from having to reboot your physical machine every time you make a change. 

Stay tuned for more exciting tutorials on operating system development!
