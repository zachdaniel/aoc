# Aoc

My solutions to Advent of Code, wrapped in a Spark DSL for solving each day! 
Helps me move quickly and do fun things like watching for file changes and printing out the answer on save! 

## Badges


  <img src="https://img.shields.io/static/v1?label=2015&message=10%20stars&style=for-the-badge&color=orange" alt="10 stars" />

  <img src="https://img.shields.io/static/v1?label=2020&message=50%20stars&style=for-the-badge&color=green" alt="50 stars" />

  <img src="https://img.shields.io/static/v1?label=2021&message=46%20stars&style=for-the-badge&color=orange" alt="46 stars" />

  <img src="https://img.shields.io/static/v1?label=2022&message=33%20stars&style=for-the-badge&color=orange" alt="33 stars" />

  <img src="https://img.shields.io/static/v1?label=2023&message=31%20stars&style=for-the-badge&color=orange" alt="31 stars" />


## Benchmarks

| Year | Day | Part | IPS | Average | Deviation | Median | 99th Percentile |
| ---- | --- | ---- | --- | ------- | --------- | ------ | --------------- |
 | 2015 | 1 | 1 |  674.11 | 1.48 ms | ±45.91% | 1.43 ms | 3.17 ms |
 | 2015 | 1 | 2 |  699.79 | 1.43 ms | ±44.53% | 1.28 ms | 3.23 ms |
 | 2015 | 2 | 1 |  1.28 K | 783.86 μs | ±62.72% | 694.60 μs | 2657.38 μs |
 | 2015 | 2 | 2 |  999.09 | 1.00 ms | ±49.50% | 0.92 ms | 2.37 ms |
 | 2015 | 3 | 1 |  353.64 | 2.83 ms | ±25.73% | 2.70 ms | 4.94 ms |
 | 2015 | 3 | 2 |  293.40 | 3.41 ms | ±23.74% | 3.25 ms | 5.82 ms |
 | 2015 | 4 | 1 |  6.42 | 155.68 ms |  ±1.44% | 155.69 ms | 163.21 ms |
 | 2015 | 4 | 2 | 0.178 |  5.63 s |  ±0.00% |  5.63 s | 5.63 s |
 | 2015 | 5 | 1 | 62.78 |  15.93 ms |  ±9.85% |  15.71 ms | 25.49 ms |
 | 2015 | 5 | 2 |  2.36 | 424.18 ms |  ±0.92% | 424.74 ms | 429.44 ms |
 | 2020 | 1 | 1 |  2.43 K | 412.11 μs | ±82.79% | 356.58 μs | 1315.95 μs |
 | 2020 | 1 | 2 | 99.77 |  10.02 ms | ±12.08% | 9.89 ms | 15.83 ms |
 | 2020 | 2 | 1 |  495.63 | 2.02 ms | ±35.54% | 1.88 ms | 4.68 ms |
 | 2020 | 2 | 2 |  398.94 | 2.51 ms | ±54.66% | 2.22 ms | 7.93 ms |
 | 2020 | 3 | 1 |  325.52 | 3.07 ms | ±31.73% | 2.89 ms | 7.15 ms |
 | 2020 | 3 | 2 | 80.66 |  12.40 ms | ±18.64% |  11.85 ms | 19.70 ms |
 | 2020 | 4 | 1 |  353.96 | 2.83 ms | ±33.27% | 2.66 ms | 6.25 ms |
 | 2020 | 4 | 2 |  237.32 | 4.21 ms | ±47.15% | 3.57 ms | 13.23 ms |
 | 2020 | 5 | 1 |  799.37 | 1.25 ms | ±53.37% | 1.13 ms | 3.17 ms |
 | 2020 | 5 | 2 |  474.96 | 2.11 ms | ±77.94% | 1.62 ms | 11.07 ms |
 | 2020 | 6 | 1 |  265.28 | 3.77 ms | ±36.52% | 3.43 ms | 10.40 ms |
 | 2020 | 6 | 2 |  252.11 | 3.97 ms | ±38.59% | 3.46 ms | 11.43 ms |
 | 2020 | 7 | 1 | 40.86 |  24.48 ms |  ±8.87% |  23.87 ms | 33.09 ms |
 | 2020 | 7 | 2 |  190.66 | 5.24 ms | ±33.29% | 4.69 ms | 13.91 ms |
 | 2020 | 8 | 1 |  1.48 K | 675.86 μs |  ±119.53% | 505.27 μs | 4443.70 μs |
 | 2020 | 8 | 2 |  790.78 | 1.26 ms | ±64.09% | 1.11 ms | 3.68 ms |
 | 2020 | 9 | 1 |  965.43 | 1.04 ms | ±92.61% | 0.81 ms | 5.64 ms |
 | 2020 | 9 | 2 |  550.46 | 1.82 ms | ±52.36% | 1.62 ms | 4.86 ms |
 | 2020 | 10 | 1 |  3.86 K | 259.14 μs |  ±106.51% | 214.25 μs | 936.78 μs |
 | 2020 | 10 | 2 |  1.93 K | 517.65 μs | ±73.24% | 464.02 μs | 1510.70 μs |
 | 2020 | 11 | 1 |  0.93 |  1.08 s |  ±0.98% |  1.08 s | 1.09 s |
 | 2020 | 11 | 2 |  0.84 |  1.18 s |  ±3.50% |  1.17 s | 1.26 s |
 | 2020 | 12 | 1 |  2.32 K | 431.11 μs | ±79.08% | 373.92 μs | 1398.08 μs |
 | 2020 | 12 | 2 |  1.38 K | 726.62 μs | ±60.08% | 660.54 μs | 1867.62 μs |
 | 2020 | 13 | 1 |  843.43 | 1.19 ms | ±43.51% | 1.10 ms | 2.96 ms |
 | 2020 | 13 | 2 |  1.93 K | 517.83 μs | ±73.53% | 464.81 μs | 1481.08 μs |
 | 2020 | 14 | 1 |  379.46 | 2.64 ms | ±30.05% | 2.47 ms | 5.79 ms |
 | 2020 | 14 | 2 |  5.08 | 196.77 ms |  ±4.19% | 194.47 ms | 223.47 ms |
 | 2020 | 15 | 1 |  1.86 K | 538.27 μs | ±78.85% | 453.71 μs | 1684.06 μs |
 | 2020 | 15 | 2 |  0.0539 | 18.56 s |  ±0.00% | 18.56 s | 18.56 s |
 | 2020 | 16 | 1 |  2.30 K | 435.54 μs | ±89.19% | 368.58 μs | 1510.63 μs |
 | 2020 | 16 | 2 |  225.06 | 4.44 ms | ±45.08% | 4.05 ms | 11.88 ms |
 | 2020 | 17 | 1 |  132.42 | 7.55 ms | ±14.88% | 7.30 ms | 12.96 ms |
 | 2020 | 17 | 2 |  5.63 | 177.68 ms |  ±9.21% | 172.98 ms | 221.49 ms |
 | 2020 | 18 | 1 |  122.36 | 8.17 ms | ±12.77% | 7.96 ms | 13.15 ms |
 | 2020 | 18 | 2 |  112.89 | 8.86 ms | ±25.32% | 8.46 ms | 17.76 ms |
 | 2020 | 19 | 1 | 68.74 |  14.55 ms |  ±8.65% |  14.21 ms | 21.57 ms |
 | 2020 | 19 | 2 | 14.08 |  71.01 ms |  ±6.53% |  69.89 ms | 96.84 ms |
 | 2020 | 20 | 1 |  0.0643 | 15.54 s |  ±0.00% | 15.54 s | 15.54 s |
 | 2020 | 20 | 2 |  0.0583 | 17.16 s |  ±0.00% | 17.16 s | 17.16 s |
 | 2020 | 21 | 1 | 35.07 |  28.52 ms |  ±4.06% |  28.30 ms | 33.66 ms |
 | 2020 | 21 | 2 | 58.40 |  17.12 ms | ±15.70% |  16.52 ms | 32.92 ms |
 | 2020 | 22 | 1 |  3.37 K | 296.30 μs |  ±107.57% | 221.17 μs | 1567.64 μs |
 | 2020 | 22 | 2 |  0.71 |  1.41 s |  ±4.30% |  1.42 s | 1.46 s |
 | 2020 | 23 | 1 |  3.09 K | 323.60 μs |  ±119.12% | 261.17 μs | 1415.76 μs |
 | 2020 | 23 | 2 |  0.0292 | 34.19 s |  ±0.00% | 34.19 s | 34.19 s |
 | 2020 | 24 | 1 |  3.47 K | 288.59 μs |  ±122.90% |  232 μs | 1280.63 μs |
 | 2020 | 24 | 2 |  1.50 K | 668.30 μs |  ±147.07% |  447 μs | 5578.68 μs |
 | 2020 | 25 | 1 |  3.48 K | 287.65 μs |  ±129.29% | 229.08 μs | 1272.80 μs |
 | 2020 | 25 | 2 |  1.50 K | 665.90 μs |  ±147.77% | 443.79 μs | 5407.62 μs |
 | 2021 | 1 | 1 |  1.32 K | 754.79 μs |  ±110.72% | 571.52 μs | 4741.23 μs |
 | 2021 | 1 | 2 |  940.75 | 1.06 ms | ±72.03% | 0.91 ms | 3.48 ms |
 | 2021 | 2 | 1 |  1.28 K | 779.37 μs | ±73.38% | 622.67 μs | 3322.68 μs |
 | 2021 | 2 | 2 |  558.87 | 1.79 ms |  ±132.44% | 1.10 ms | 11.29 ms |
 | 2021 | 3 | 1 |  457.41 | 2.19 ms | ±83.67% | 1.60 ms | 10.03 ms |
 | 2021 | 3 | 2 |  441.93 | 2.26 ms | ±91.74% | 1.72 ms | 11.28 ms |
 | 2021 | 4 | 1 | 38.35 |  26.07 ms | ±20.24% |  24.65 ms | 50.84 ms |
 | 2021 | 4 | 2 | 23.37 |  42.79 ms | ±14.78% |  40.89 ms | 85.19 ms |
 | 2021 | 5 | 1 | 0.166 |  6.01 s |  ±0.00% |  6.01 s | 6.01 s |
 | 2021 | 5 | 2 | 0.106 |  9.45 s |  ±0.00% |  9.45 s | 9.45 s |
 | 2021 | 6 | 1 |  2.05 K | 487.79 μs |  ±158.36% | 298.04 μs | 3420.94 μs |
 | 2021 | 6 | 2 |  921.63 | 1.09 ms |  ±139.71% | 0.74 ms | 6.66 ms |
 | 2021 | 7 | 1 | 28.10 |  35.59 ms | ±15.72% |  34.20 ms | 69.76 ms |
 | 2021 | 7 | 2 | 22.87 |  43.72 ms | ±15.17% |  42.10 ms | 83.92 ms |
 | 2021 | 8 | 1 |  279.42 | 3.58 ms | ±61.04% | 3.04 ms | 12.57 ms |
 | 2021 | 8 | 2 |  149.20 | 6.70 ms | ±38.96% | 6.02 ms | 20.32 ms |
 | 2021 | 9 | 1 |  152.61 | 6.55 ms | ±41.61% | 6.03 ms | 16.89 ms |
 | 2021 | 9 | 2 | 56.59 |  17.67 ms | ±22.36% |  16.65 ms | 36.24 ms |
 | 2021 | 10 | 1 |  569.48 | 1.76 ms | ±70.80% | 1.44 ms | 7.95 ms |
 | 2021 | 10 | 2 |  532.53 | 1.88 ms | ±52.71% | 1.67 ms | 5.27 ms |
 | 2021 | 11 | 1 |  212.60 | 4.70 ms | ±34.34% | 4.24 ms | 12.43 ms |
 | 2021 | 11 | 2 | 69.36 |  14.42 ms | ±12.05% |  14.05 ms | 22.59 ms |
 | 2021 | 12 | 1 | 55.11 |  18.14 ms | ±16.88% |  17.90 ms | 26.18 ms |
 | 2021 | 12 | 2 |  1.66 | 601.33 ms |  ±4.56% | 599.52 ms | 640.25 ms |
 | 2021 | 13 | 1 |  1.03 K | 969.71 μs | ±61.09% | 849.42 μs | 2904.62 μs |
 | 2021 | 13 | 2 |  446.66 | 2.24 ms | ±51.43% | 1.92 ms | 6.36 ms |
 | 2021 | 14 | 1 |  495.39 | 2.02 ms | ±46.02% | 1.76 ms | 5.87 ms |
 | 2021 | 14 | 2 |  129.75 | 7.71 ms | ±40.94% | 6.84 ms | 26.52 ms |
 | 2021 | 15 | 1 | 18.00 |  55.56 ms |  ±7.29% |  55.01 ms | 66.75 ms |
 | 2021 | 15 | 2 | 0.186 |  5.39 s |  ±0.00% |  5.39 s | 5.39 s |
 | 2021 | 16 | 1 |  623.34 | 1.60 ms | ±59.10% | 1.38 ms | 5.11 ms |
 | 2021 | 16 | 2 |  488.33 | 2.05 ms | ±98.15% | 1.57 ms | 9.98 ms |
 | 2021 | 17 | 1 | 20.94 |  47.75 ms |  ±5.74% |  47.35 ms | 57.39 ms |
 | 2021 | 17 | 2 |  1.98 | 505.29 ms |  ±5.72% | 499.22 ms | 552.39 ms |
 | 2021 | 18 | 1 |  108.04 | 9.26 ms | ±15.84% | 9.05 ms | 15.61 ms |
 | 2021 | 18 | 2 |  3.36 | 297.56 ms |  ±5.46% | 293.61 ms | 337.30 ms |
 | 2021 | 19 | 1 |  0.0856 | 11.68 s |  ±0.00% | 11.68 s | 11.68 s |
 | 2021 | 19 | 2 |  0.0926 | 10.80 s |  ±0.00% | 10.80 s | 10.80 s |
 | 2021 | 20 | 1 | 27.58 |  36.26 ms | ±12.40% |  35.23 ms | 63.95 ms |
 | 2021 | 20 | 2 |  0.22 |  4.48 s |  ±1.49% |  4.48 s | 4.52 s |
 | 2021 | 21 | 1 |  1.20 K | 835.81 μs |  ±151.32% | 464.73 μs | 6474.43 μs |
 | 2021 | 21 | 2 |  0.0254 | 39.38 s |  ±0.00% | 39.38 s | 39.38 s |
 | 2021 | 22 | 1 |  319.72 | 3.13 ms | ±65.57% | 2.42 ms | 11.62 ms |
 | 2021 | 22 | 2 | 19.22 |  52.02 ms | ±14.28% |  49.60 ms | 92.51 ms |
 | 2021 | 23 | 1 |  0.36 |  2.76 s |  ±0.83% |  2.76 s | 2.78 s |
 | 2021 | 23 | 2 |  0.0865 | 11.56 s |  ±0.00% | 11.56 s | 11.56 s |
 | 2022 | 1 | 1 |  1.32 K | 756.26 μs |  ±130.84% | 501.87 μs | 4663.70 μs |
 | 2022 | 1 | 2 |  949.20 | 1.05 ms |  ±117.10% | 0.78 ms | 5.55 ms |
 | 2022 | 2 | 1 |  559.52 | 1.79 ms | ±80.30% | 1.38 ms | 7.39 ms |
 | 2022 | 2 | 2 |  471.90 | 2.12 ms | ±80.98% | 1.66 ms | 8.59 ms |
 | 2022 | 3 | 1 |  604.74 | 1.65 ms | ±78.81% | 1.32 ms | 6.02 ms |
 | 2022 | 3 | 2 |  644.91 | 1.55 ms | ±88.29% | 1.16 ms | 6.78 ms |
 | 2022 | 4 | 1 |  580.53 | 1.72 ms | ±75.09% | 1.40 ms | 5.85 ms |
 | 2022 | 4 | 2 |  362.34 | 2.76 ms | ±81.75% | 2.18 ms | 10.59 ms |
 | 2022 | 5 | 1 |  690.68 | 1.45 ms | ±88.81% | 1.13 ms | 5.60 ms |
 | 2022 | 5 | 2 |  453.47 | 2.21 ms | ±92.10% | 1.66 ms | 9.22 ms |
 | 2022 | 6 | 1 |  531.64 | 1.88 ms | ±72.23% | 1.51 ms | 6.76 ms |
 | 2022 | 6 | 2 |  159.35 | 6.28 ms | ±43.22% | 5.48 ms | 18.79 ms |
 | 2022 | 7 | 1 |  357.23 | 2.80 ms | ±67.60% | 2.33 ms | 9.03 ms |
 | 2022 | 7 | 2 |  334.83 | 2.99 ms | ±59.18% | 2.42 ms | 10.51 ms |
 | 2022 | 8 | 1 | 33.59 |  29.77 ms | ±18.62% |  28.74 ms | 64.32 ms |
 | 2022 | 8 | 2 | 28.38 |  35.23 ms | ±12.06% |  34.48 ms | 45.79 ms |
 | 2022 | 9 | 1 |  177.30 | 5.64 ms | ±53.37% | 4.82 ms | 18.33 ms |
 | 2022 | 9 | 2 |  128.06 | 7.81 ms | ±36.67% | 7.13 ms | 19.53 ms |
 | 2022 | 10 | 1 |  1.78 K | 560.28 μs |  ±143.04% | 381.91 μs | 3729.87 μs |
 | 2022 | 10 | 2 |  814.95 | 1.23 ms |  ±144.83% | 0.71 ms | 8.01 ms |
 | 2022 | 11 | 1 |  1.13 K | 885.33 μs |  ±119.68% | 668.20 μs | 4289.90 μs |
 | 2022 | 11 | 2 |  5.82 | 171.73 ms |  ±5.48% | 169.24 ms | 190.71 ms |
 | 2022 | 12 | 1 |  7.09 | 141.06 ms | ±28.25% | 127.13 ms | 251.56 ms |
 | 2022 | 12 | 2 | 0.130 |  7.67 s |  ±0.00% |  7.67 s | 7.67 s |
 | 2022 | 13 | 1 |  180.94 | 5.53 ms | ±51.09% | 4.73 ms | 18.39 ms |
 | 2022 | 13 | 2 |  156.01 | 6.41 ms | ±37.73% | 5.86 ms | 15.65 ms |
 | 2022 | 14 | 1 | 44.29 |  22.58 ms | ±21.25% |  21.43 ms | 43.78 ms |
 | 2022 | 14 | 2 |  0.92 |  1.09 s | ±30.35% |  1.04 s | 1.64 s |
 | 2022 | 15 | 1 | 0.130 |  7.68 s |  ±0.00% |  7.68 s | 7.68 s |
 | 2022 | 15 | 2 |  0.23 |  4.44 s |  ±1.00% |  4.44 s | 4.47 s |
 | 2022 | 16 | 1 |  1.24 | 803.86 ms |  ±5.87% | 789.98 ms | 863.99 ms |
 | 2022 | 16 | 2 |  0.0313 | 31.97 s |  ±0.00% | 31.97 s | 31.97 s |
 | 2022 | 17 | 1 | 31.44 |  31.80 ms |  ±2.69% |  31.85 ms | 33.86 ms |
 | 2023 | 1 | 1 |  264.37 | 3.78 ms | ±44.30% | 3.27 ms | 11.38 ms |
 | 2023 | 1 | 2 |  8.69 | 115.02 ms |  ±5.44% | 114.17 ms | 133.73 ms |
 | 2023 | 2 | 1 |  603.45 | 1.66 ms | ±79.76% | 1.27 ms | 7.11 ms |
 | 2023 | 2 | 2 |  505.34 | 1.98 ms | ±77.19% | 1.59 ms | 7.45 ms |
 | 2023 | 3 | 1 | 55.96 |  17.87 ms | ±26.41% |  16.63 ms | 37.84 ms |
 | 2023 | 3 | 2 | 82.68 |  12.09 ms | ±34.41% |  11.19 ms | 27.48 ms |
 | 2023 | 4 | 1 |  652.20 | 1.53 ms | ±83.34% | 1.19 ms | 7.08 ms |
 | 2023 | 4 | 2 |  312.47 | 3.20 ms |  ±132.09% | 2.01 ms | 19.73 ms |
 | 2023 | 5 | 1 |  975.09 | 1.03 ms |  ±103.43% | 0.77 ms | 4.61 ms |
 | 2023 | 5 | 2 |  0.0460 | 21.73 s |  ±0.00% | 21.73 s | 21.73 s |
 | 2023 | 6 | 1 |  2.42 K | 413.93 μs |  ±150.07% | 262.58 μs | 2366.15 μs |
 | 2023 | 6 | 2 |  1.33 | 752.78 ms | ±26.84% | 671.01 ms | 1086.55 ms |
 | 2023 | 7 | 1 |  258.20 | 3.87 ms |  ±120.93% | 2.74 ms | 22.39 ms |
 | 2023 | 7 | 2 |  309.81 | 3.23 ms | ±87.84% | 2.50 ms | 13.11 ms |
 | 2023 | 8 | 1 |  166.48 | 6.01 ms |  ±128.00% | 3.70 ms | 37.36 ms |
 | 2023 | 8 | 2 | 82.08 |  12.18 ms | ±12.05% |  11.69 ms | 18.25 ms |
 | 2023 | 9 | 1 |  221.29 | 4.52 ms |  ±111.66% | 2.87 ms | 29.84 ms |
 | 2023 | 9 | 2 |  436.01 | 2.29 ms | ±53.05% | 1.86 ms | 7.77 ms |
 | 2023 | 10 | 1 |  4.70 | 212.56 ms | ±12.96% | 217.05 ms | 252.50 ms |
 | 2023 | 10 | 2 |  0.84 |  1.19 s |  ±4.28% |  1.17 s | 1.24 s |
 | 2023 | 11 | 1 | 18.30 |  54.64 ms |  ±5.59% |  54.02 ms | 62.39 ms |
 | 2023 | 11 | 2 | 18.65 |  53.63 ms |  ±3.64% |  53.55 ms | 62.62 ms |
 | 2023 | 12 | 1 |  442.19 | 2.26 ms |  ±7.58% | 2.27 ms | 2.60 ms |
 | 2023 | 13 | 1 |  137.13 | 7.29 ms |  ±4.33% | 7.14 ms | 8.09 ms |
 | 2023 | 14 | 1 |  212.65 | 4.70 ms | ±13.85% | 4.62 ms | 6.17 ms |
 | 2023 | 14 | 2 |  0.78 |  1.28 s |  ±2.60% |  1.29 s | 1.32 s |
 | 2023 | 15 | 1 |  1.14 K | 880.92 μs | ±42.23% | 852.08 μs | 1198.84 μs |
 | 2023 | 15 | 2 |  351.46 | 2.85 ms |  ±6.19% | 2.85 ms | 3.23 ms |
 | 2023 | 16 | 1 | 82.87 |  12.07 ms |  ±3.91% |  12.14 ms | 12.83 ms |
 | 2023 | 17 | 1 |  1.08 | 923.46 ms |  ±1.98% | 917.04 ms | 960.70 ms |
 | 2023 | 17 | 2 |  0.38 |  2.65 s |  ±1.28% |  2.65 s | 2.68 s |
