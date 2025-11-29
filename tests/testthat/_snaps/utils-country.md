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
      ! Some country/codes were not matched unambiguously: "POR" and "RTA"
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
      ! Some country/codes were not matched unambiguously: "Rea" and "Murcua"
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

