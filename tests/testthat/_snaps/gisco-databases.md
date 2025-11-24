# Get database

    Code
      unique(new_db$id_giscoR)
    Output
      [1] "coastallines" "communes"     "countries"    "lau"          "nuts"        
      [6] "postalcode"   "urban_audit" 

---

    Code
      unique(new_db$ext)
    Output
      [1] "csv"     "geojson" "gpkg"    "json"    "pbf"     "shp"    

---

    Code
      unique(new_db$epsg)
    Output
      [1] "3035" "3857" "4326" NA    

---

    Code
      unique(new_db$nuts_level)
    Output
      [1] NA    "0"   "1"   "2"   "3"   "all"

---

    Code
      unique(new_db$resolution)
    Output
      [1] "01"  "03"  "10"  "20"  "60"  NA    "100"

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
       [1] "2001" "2003" "2004" "2006" "2008" "2010" "2011" "2012" "2013" "2014"
      [11] "2015" "2016" "2017" "2018" "2019" "2020" "2021" "2022" "2023" "2024"

