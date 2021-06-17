# Performance profiling

Run the following to gather new benchmark data:

```text
$ flutter drive --target=benchmark/app.dart --driver=benchmark/app_benchmark.dart --profile --endless-trace-buffer --purge-persistent-cache
```

Better yet, run many benchmarks in quick succession.

```text

```


Install Benchmarkhor (`pub global activate benchmarkhor`), then run:

```text
$ benchextract benchmark/*.json
```

Finally, compare different benchmark runs with

```text
$ benchcompare benchmark/some-baseline.benchmark benchmark/new.benchmark
```
