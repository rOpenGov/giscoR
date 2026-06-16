# Testing attributions

    Code
      gisco_attributions(copyright = TRUE)
    Message
      i Copyright notice
      
      When data downloaded from GISCO
      is used in any printed or electronic publication,
      in addition to any other provisions applicable to
      the whole Eurostat website, the data source must
      be acknowledged in the legend of the map and on
      the introductory page of the publication with the
      following copyright notice:
      
      - EN: © EuroGeographics for the administrative boundaries
      - FR: © EuroGeographics pour les limites administratives
      - DE: © EuroGeographics bezüglich der Verwaltungsgrenzen
      
      For publications in languages other than English,
      French or German, the translation of the copyright
      notice in the language of the publication shall be
      used.
      
      If you intend to use the data commercially, please
      contact EuroGeographics for information about
      their license agreements.
      
    Output
      [1] "© EuroGeographics for the administrative boundaries"

---

    Code
      gisco_attributions("da")
    Output
      [1] "© EuroGeographics for administrative grænser"

---

    Code
      gisco_attributions("de")
    Output
      [1] "© EuroGeographics bezüglich der Verwaltungsgrenzen"

---

    Code
      gisco_attributions("es")
    Output
      [1] "© Eurogeographics para los límites administrativos"

---

    Code
      gisco_attributions("FR")
    Output
      [1] "© EuroGeographics pour les limites administratives"

---

    Code
      gisco_attributions("fi")
    Output
      [1] "© EuroGeographics Association hallinnollisille rajoille"

---

    Code
      gisco_attributions("no")
    Output
      [1] "© EuroGeographics for administrative grenser"

---

    Code
      gisco_attributions("sv")
    Output
      [1] "© EuroGeographics för administrativa gränser"

---

    Code
      gisco_attributions("xx")
    Message
      ! `lang` = "xx" is not supported. Switching to English.
      i Consider contributing a translation: <https://github.com/rOpenGov/giscoR/issues>.
    Output
      [1] "© EuroGeographics for the administrative boundaries"

