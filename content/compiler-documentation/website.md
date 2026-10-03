+++
title = "Website"
weight = 1
+++

This website is written using the [Zola static site generator](https://www.getzola.org).
You will need to install zola in order to build the website.

Zola Version: zola 0.22.1

# Documenting the Pirouette and NetIR Languages

The main documentation of [Pirouette](@/pirouette/_index.md) and [NetIR](@/netir/_index.md) for users is here.
There should be a page on each major feature documenting its syntax and semantics.

In addition, there is a tutorial for both [Pirouette](@/pirouette-tutorial/_index.md) and [NetIR](@/netir-tutorial/_index.md).
When new features get added to the language, a small tutorial on them should be added.
A future goal is to turn each of these into a more full-featured tutorial.

# Documenting the Compiler

Expository articles on the internals of the compiler should also be written [here](@/compiler-internals/_index.md).
Ideally, there will also be [odoc-generated documentation](@/compiler-documentation/odoc.md) available here soon.

# Documenting the Documentation

Finally, this page is part of the documentation of where all the documentation is available.
Any new documentation process should be written about here as well.

# Testing Reports

Eventually, we will put testing reports here.
These include the number of passing [OUnit tests](@/compiler-internals/testing.md#ounit-tests), as well as what tests are failing and why.
Perhaps more importantly, it will include the latest [bisect report](@/compiler-internals/testing.md#whitebox-testing-with-bisect).
