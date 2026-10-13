+++
title = "Backends"
description = "How NetIR programs become runnable code"
weight = 5
+++

A backend takes a NetIR program and turns it into code that can actually run.
Each participant in a choreography gets its own NetIR program, and the backend
produces one runnable file per participant.

Different backends handle communication differently. Some perform real
communication, such as sending messages over HTTP. Others only simulate it,
which is useful for testing and debugging the compiler.