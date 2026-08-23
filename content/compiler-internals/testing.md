+++
title = "Testing"
weight = 1
+++

The `test` top-level directory of the Pirouette source code contains tests.
There are two major tools for testing: [OUnit2](https://github.com/gildor478/ounit) (see also [this tutorial](https://cs3110.github.io/textbook/chapters/data/ounit.html)) and [Cram](https://dune.readthedocs.io/en/stable/reference/cram.html) (see also [this tutorial](https://sancho.dev/blog/cram-tests-a-hidden-gem-of-dune)).
When you add new functionality to the compiler, you should add tests.

# OUnit Tests
OUnit is a unit testing framework for OCaml.
Each piece of functionality should have a file declaring a suite of OUnit tests.
The file `test_main.ml` then collects all of these tests and runs them.

# Cram Tests
Cram tests are an integration-testing framework for OCaml.
They allow you to describe a command-line interaction, and test that it produces the expected output.
Every aspect of the compiler CLI should have a cram test.
Ideally, every such aspect would have a number of tests, creating a robust test suite.

# Whitebox Testing with Bisect

The [bisect](https://github.com/aantron/bisect_ppx) tool allows you to check code coverage for your OCaml program.
(See also [this tutorial](https://courses.cs.cornell.edu/cs3110/2021sp/textbook/testing/bisect.html)).
Every feature should ensure as much code coverage as possible. 
