# Performance profiling

Run the following to gather new benchmark data:

```text
$ flutter drive --target=benchmark/app.dart --driver=benchmark/app_benchmark.dart --profile --endless-trace-buffer --purge-persistent-cache
```

Better yet, run many benchmarks in quick succession.

```text
for n in {1..10}; do echo "=== Run number ${n} ==="; \
  flutter drive --target=benchmark/app.dart --driver=benchmark/short_benchmark.dart --profile --purge-persistent-cache; done
```

Then combine them.


Install Benchmarkhor (`pub global activate benchmarkhor`), then run:

```text
$ benchextract benchmark/*.json
```

Finally, compare different benchmark runs with

```text
$ benchcompare benchmark/some-baseline.benchmark benchmark/new.benchmark
```
