+++
title = "Rust Ownership And Borrowing for Beginners"
description = "Rust Ownership And Borrowing for Beginners"
date = "2025-06-01"
# updated = "2025-01-01"
draft = false

[taxonomies]
categories = ["Rust"]
tags = ["rust", "strings", "cheatsheet"]

[extra]
lang = "en"
toc = true
comment = false
copy = true
outdate_alert = true
outdate_alert_days = 120
math = false
mermaid = false
featured = false
reaction = false
gh_link = "https://github.com/bikathi/kathi-archives/blob/main/content/posts/rust_ownership_and_borrowing_cheatsheet.md"
+++

# Rust's Approach To Memory Safety
In VM-managed languages, the VM manages data both on the stack and the heap. It knows exactly when to put data, copy, update, grow, shrink,
and remove data.
The part of the VM that cleans up data when it is no longer in use is called the **garbage collector**.
However, **Rust doesn't have a VM (mostly) and consequentially, does not have a garbage collector**. 

In Rust, it is the work of the developer to know what data goes to the stack, which to the heap, wisely decide when to copy data 
and (although very rare), when to clean unused data.

Rust is a *statically-typed and compiled* language. This infers that Rust must know the **type** of each piece of data you create, so that it can
communicate to the OS the amount of space to allocate (whether on the stack or heap) for that type of data. However, it is fully up to the
developer to decide what data goes to the heap and which goes to the stack, Rust only calculates the space needed to hold the data for you.
Such a decision comes with downsides and upsides.

# How Does Memory Work In Other Languages?
When writing code in a language like Java, Python or Javascript (we'll use this for all the non-Rust examples in this article),
you usually don't give two thoughts about where the data you are storing in your variables is being stored within the context of
your application and the computers memory. This train of thought is usually abstracted from you by the <INSERT_LANGUAGE_NAME_HERE>
Virtual Machine (for example the [Java Virtual Machine](https://en.wikipedia.org/wiki/Java_virtual_machine) for Java, and the 
[Python Virtual Machine](https://www.geeksforgeeks.org/python-virtual-machine/) for Python).

It is the duty of the virtual machine to know where to store the data you assign to your variables within the context of your computer
memory, and to ensure the data in that memory is cleaned up when you don't need it any more. This technology eases the difficulty of writing
code and moreso, has allowed developers over the years to write code that runs on multiple platforms, **cross platform code**, because the
VMs can be customized to behave according to the specifications for that platform.

# What Is Memory?: Stack Versus Heap
The term *memory* can mean alot of things to a lot of different people within the world of software engineering. In our case, we will think 
of memory as **the part of your computer that temporarily holds data as you're working with it before it is permanently saved onto the SSD**.
This is called the **RAM (Random Access Memory)**. Unlike your SSD space, RAM space is very limited and so, your OS has to be very considerate
of the amount of space it assigns to your program in the RAM, and more importantly **how** it stores the data in the RAM.
Within your RAM, therefore, data can be stored in one of two 'places', the **stack** or the **heap**.

## The Stack
- Is exactly what the name says i.e. data is stored in such a manner that one piece of data appears 'on top of' the other.
- If you look at the stack from a top-down view, you'll see new data 'on top'.
- The OS operates on data on the stack in a LIFO (**Last In First Out**) manner, such that, the newest data to be added on the stack
  will always be the first to be removed (a process technically called *cleaning up*).
- Because data on the stack has to be inserted and removed quickly, the OS and many programming languages,
  only store simple data on the stack (technically called **primitive data**)
- Such data includes:
    - Plain whole numbers (integers) like 1, 2, 3, 400, 700...
    - Decimal numbers like 10.8, 3.147...
    - One character like x, y, k, b...
    - True or False values (booleans)
- The simplicity of this data allows them to be copied easily (as in without using up a lot of resources).

## The Heap
- You can think of the heap like a laundry pile, all things, big and small can be found here with no particular order, meaning that
there is no FIFO-fanciness here.
- This means that copying such data is usually expensive (as in uses up a lot of resources), but also that such data can easily be expanded 
or shrunk down (like in the case of an Array).
- Data stored here includes:
    - Strings e.g. names of people and places, hyperlinks e.t.c...
    - Lists and arrays e.g. list of groceries
    - Complex objects (like instances of a class in Java and *struct* instances in Rust)

## Rust's Approach in a Nutshell
- Rust allocates local variables (variables created within a certain scope e.g. within a function) in **stack frames**, which is a mapping between 
a variable and the value it is associated with and lives on the **stack**.
- The stack frame is **allocated when a function is called** and **de-allocated when the call ends**.
- The stack frame is made up of two parts:
    1. The variable - these are what you define in your code to hold data for you.
    2. The data the variable points to - can be one of two things: **pure data** like numbers, booleans e.t.c or **pointers** (more on that in a few)
