# mapSpain

<details>

* Version: 0.9.1
* GitHub: https://github.com/rOpenSpain/mapSpain
* Source code: https://github.com/cran/mapSpain
* Date/Publication: 2024-06-10 18:20:01 UTC
* Number of recursive dependencies: 102

Run `revdepcheck::revdep_details(, "mapSpain")` for more info

</details>

## Newly broken

*   checking tests ...
    ```
      Running 'testthat.R'
     ERROR
    Running the tests in 'tests/testthat.R' failed.
    Last 13 lines of output:
        4.       └─testthat:::test_files_parallel(...)
        5.         ├─withr::with_dir(...)
        6.         │ └─base::force(code)
        7.         ├─testthat::with_reporter(...)
        8.         │ └─base::tryCatch(...)
        9.         │   └─base (local) tryCatchList(expr, classes, parentenv, handlers)
       10.         │     └─base (local) tryCatchOne(expr, names, parentenv, handlers[[1L]])
       11.         │       └─base (local) doTryCatch(return(expr), name, parentenv, handler)
       12.         └─testthat:::parallel_event_loop_chunky(queue, reporters, ".")
       13.           └─queue$poll(Inf)
       14.             └─base::lapply(...)
       15.               └─testthat (local) FUN(X[[i]], ...)
       16.                 └─private$handle_error(msg, i)
       17.                   └─rlang::abort(...)
      Execution halted
    ```

## In both

*   checking data for non-ASCII characters ... NOTE
    ```
      Note: found 13138 marked UTF-8 strings
    ```

