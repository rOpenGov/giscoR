# Messages

    Code
      make_msg("generic", TRUE, "Hi", "I am a generic.", "See {.var avar}.")
    Message
      > Hi I am a generic. See `avar`.

---

    Code
      make_msg("info", TRUE, "Info here.", "See {.pkg igoR}.")
    Message
      i Info here. See igoR.

---

    Code
      make_msg("warning", TRUE, "Caution! A warning.", "But still OK.")
    Message
      ! Caution! A warning. But still OK.

---

    Code
      make_msg("danger", TRUE, "OOPS!", "I did it again :(")
    Message
      x OOPS! I did it again :(

---

    Code
      make_msg("success", TRUE, "Hooray!", "5/5 ;)")
    Message
      v Hooray! 5/5 ;)

# Utils names

    Code
      get_country_code(c("Espagne", "United Kingdom"))
    Output
      [1] "ES" "UK"

---

    Code
      get_country_code("U")
    Condition
      Error in `FUN()`:
      ! Invalid country name "U" Try a vector of names or ISO3/Eurostat codes

---

    Code
      get_country_code(c("ESP", "POR", "RTA", "USA"), "iso3c")
    Message
      ! Some values were not matched unambiguously: POR and RTA
      i Review the names/codes or switch to ISO3 codes.
    Output
      [1] "ESP" "USA"

---

    Code
      get_country_code(c("ESP", "Alemania"))
    Output
      [1] "ES" "DE"

# Problematic names

    Code
      get_country_code(c("Espagne", "Antartica"))
    Output
      [1] "ES" "AQ"

---

    Code
      get_country_code(c("spain", "antartica"))
    Output
      [1] "ES" "AQ"

---

    Code
      get_country_code(c("Spain", "Kosovo", "Antartica"))
    Output
      [1] "ES" "XK" "AQ"

---

    Code
      get_country_code(c("Spain", "Kosovo", "Antartica"), "iso3c")
    Output
      [1] "ESP" "XKX" "ATA"

---

    Code
      get_country_code(c("ESP", "XKX", "DEU"))
    Output
      [1] "ES" "XK" "DE"

---

    Code
      get_country_code(c("Spain", "Rea", "Kosovo", "Antartica", "Murcua"))
    Message
      ! Some values were not matched unambiguously: Rea and Murcua
      i Review the names/codes or switch to ISO3 codes.
    Output
      [1] "ES" "XK" "AQ"

---

    Code
      get_country_code("Kosovo")
    Output
      [1] "XK"

---

    Code
      get_country_code("XKX")
    Output
      [1] "XK"

---

    Code
      get_country_code("XK", "iso3c")
    Output
      [1] "XKX"

# Test mixed countries

    Code
      get_country_code(c("Germany", "USA", "Greece", "united Kingdom"))
    Output
      [1] "DE" "US" "EL" "UK"

# Pretty match

    Code
      my_fun("error here")
    Condition
      Error:
      ! `arg_one` should be one of "10" or "1000" or "3000" or "5000", not "error here".

---

    Code
      my_fun(c("an", "error"))
    Condition
      Error:
      ! `arg_one` should be one of "10" or "1000" or "3000" or "5000", not "an" or "error".

---

    Code
      my_fun("5")
    Condition
      Error:
      ! `arg_one` should be one of "10" or "1000" or "3000" or "5000", not "5".
      i Did you mean "5000"?

---

    Code
      my_fun("00")
    Condition
      Error:
      ! `arg_one` should be one of "10" or "1000" or "3000" or "5000", not "00".

---

    Code
      my_fun2(c(1, 2))
    Condition
      Error:
      ! `year` should be "20", not "1" or "2".

---

    Code
      gisco_get_airports(2050)
    Condition
      Error:
      ! `year` should be one of "2013" or "2006", not "2050".

