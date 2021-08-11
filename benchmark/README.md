# Performance profiling

Run the following to gather new benchmark data:

```text
$ flutter drive --target=benchmark/app.dart --driver=benchmark/app_benchmark.dart --profile --endless-trace-buffer --purge-persistent-cache
```

You can do many runs one after another to minimize the effect of random noise
in measurements.

```text
for n in {1..10}; do echo "=== Run number ${n}/10 ==="; \
  flutter drive \
    --target=benchmark/app.dart \
    --driver=benchmark/app_benchmark.dart \
    --profile \
    --endless-trace-buffer \
    --purge-persistent-cache; \
done
```

(You can then combine the separate runs into one file using `benchmerge`.)

Install Benchmarkhor (`pub global activate benchmarkhor`), then run:

```text
$ benchextract benchmark/*.json
```

Finally, compare different benchmark runs with

```text
$ benchcompare benchmark/some-baseline.benchmark benchmark/new.benchmark
```
