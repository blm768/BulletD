# About #

BulletD is a project to create a D binding for the Bullet Physics engine.

# Project status #

Only a very small subset of the Bullet API is bound, and the binding mechanism still has a few rough edges, but what's there kind of works.

# Supported platforms #

Currently, only Linux is supported, but the code might also work on other Unix-like systems. Windows support is in progress.

# Build process #

Code generation occurs in three major phases:

1. Generate `gen_b.d`
2. Generate files for `extern(C)` methods and `gen_c.d`
3. Generate `bullet/bindings/sizes.d`, which contains sizes of the C++ classes

Sometime during the generation process, `all.d` files are generated for each package to simplify imports.

