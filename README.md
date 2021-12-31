This repo contains a patched Google Closure that will uncurry closures
in PureScript.

Thanks to Kerem Kat for
[the pointer](https://github.com/google/closure-compiler/issues/3713#issuecomment-999170951)
and
[help with my Dockerfile](https://github.com/google/closure-compiler/issues/3713#issuecomment-1003235426).

Releases are named as: `closure-YYYY-MM-DD-COMMIT`, where the commit
is from the original closure-compiler repo.

## How to use

Pull a .jar from the `releases/` dir. Then run:

    java -jar closure.jar -O ADVANCED --js in.js --js_output_file out.js

## How to build

Build the jar:

    $ docker image build . -t krk/closure-purs

Copy the jar:

    $ docker run --rm -v`pwd`:`pwd` krk/closure-purs cp bazel-bin/compiler_unshaded_deploy.jar `pwd`/
