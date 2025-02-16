# Async Reading Module

## Overview
While working on my Neovim clipboard sync plugin, I encountered a challenge in handling `libuv`'s asynchronous read calls efficiently. 

To solve this, I implemented a message length prefixing approach, similar to HTTP headers. This ensures that the reader function only appends incoming data when the full message has been received, preventing incomplete reads.

This module was built as a learning exercise to deepen my understanding of the Lua programming language and to develop a structured approach to solving this issue in my main project.
