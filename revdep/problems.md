# mapSpain

<details>

* Version: 0.7.0
* GitHub: https://github.com/rOpenSpain/mapSpain
* Source code: https://github.com/cran/mapSpain
* Date/Publication: 2022-12-22 21:40:02 UTC
* Number of recursive dependencies: 105

Run `revdepcheck::revdep_details(, "mapSpain")` for more info

</details>

## Newly broken

*   checking tests ...
    ```
      Running 'testthat.R'
     ERROR
    Running the tests in 'tests/testthat.R' failed.
    Last 13 lines of output:
      [ FAIL 1 | WARN 0 | SKIP 29 | PASS 140 ]
      
      ══ Skipped tests ═══════════════════════════════════════════════════════════════
      • On CRAN (29)
      
      ══ Failed tests ════════════════════════════════════════════════════════════════
      ── Failure ('test-esp_cache.R:17:3'): Test cache online ────────────────────────
      dir.exists(testdir) is not FALSE
      
      `actual`:   TRUE 
      `expected`: FALSE
      
      [ FAIL 1 | WARN 0 | SKIP 29 | PASS 140 ]
      Error: Test failures
      Execution halted
    ```

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 13138 marked UTF-8 strings
    ```

