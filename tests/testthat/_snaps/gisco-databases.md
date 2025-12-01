# No conexion

    Code
      fend <- gisco_get_latest_db(update_cache = TRUE)
    Message
      ! Can't access <https://gisco-services.ec.europa.eu/distribution/v2/>. If you think this is a bug please consider opening an issue on <https://github.com/ropengov/giscoR/issues>
      > Returning "NULL"

---

    Code
      fend <- gisco_get_latest_db_units(update_cache = TRUE)
    Message
      ! Can't access <https://gisco-services.ec.europa.eu/distribution/v2/>. If you think this is a bug please consider opening an issue on <https://github.com/ropengov/giscoR/issues>
      > Returning "NULL"

# Get database

    Code
      unique(new_db$id_giscor)
    Output
      [1] "coastal_lines" "communes"      "countries"     "lau"          
      [5] "nuts"          "postal_codes"  "urban_audit"  

---

    Code
      unique(new_db$ext)
    Output
      [1] "csv"     "geojson" "gpkg"    "json"    "pbf"     "shp"    

---

    Code
      unique(new_db$epsg)
    Output
      [1] 3035 3857 4326   NA

---

    Code
      unique(new_db$nuts_level)
    Output
      [1] NA    "0"   "1"   "2"   "3"   "all"

---

    Code
      unique(new_db$resolution)
    Output
      [1]   1   3  10  20  60  NA 100

---

    Code
      unique(new_db$spatialtype)
    Output
      [1] "RG"     "BN"     "LB"     NA       "COASTL" "INLAND"

---

    Code
      unique(new_db$level)
    Output
      [1] NA               "CITY"           "KERN"           "LUZ"           
      [5] "CITIES"         "FUA"            "GREATER_CITIES" "all"           

---

    Code
      sort(unique(new_db$year))
    Output
       [1] 2001 2003 2004 2006 2008 2010 2011 2012 2013 2014 2015 2016 2017 2018 2019
      [16] 2020 2021 2022 2023 2024

# Get database units

    Code
      unique(new_db$id_giscor)
    Output
      [1] "countries"   "nuts"        "urban_audit"

---

    Code
      unique(new_db$ext)
    Output
      [1] "geojson"

---

    Code
      unique(new_db$epsg)
    Output
      [1] 3035 3857 4326

---

    Code
      unique(new_db$resolution)
    Output
      [1]   1   3  10  20  NA  60 100

---

    Code
      unique(new_db$spatialtype)
    Output
      [1] "region" "label" 

---

    Code
      sort(unique(new_db$year))
    Output
       [1] 2001 2003 2004 2006 2010 2013 2014 2016 2018 2020 2021 2024

