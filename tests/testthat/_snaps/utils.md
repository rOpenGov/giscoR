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

# Pretty match

    Code
      my_fun("error here")
    Condition
      Error:
      ! `arg_one` should be one of "10", "1000", "3000" or "5000", not "error here".

---

    Code
      my_fun(c("an", "error"))
    Condition
      Error:
      ! `arg_one` should be one of "10", "1000", "3000" or "5000", not "an" or "error".

---

    Code
      my_fun("5")
    Condition
      Error:
      ! `arg_one` should be one of "10", "1000", "3000" or "5000", not "5".
      i Did you mean "5000"?

---

    Code
      my_fun("00")
    Condition
      Error:
      ! `arg_one` should be one of "10", "1000", "3000" or "5000", not "00".

---

    Code
      my_fun2(c(1, 2))
    Condition
      Error:
      ! `year` should be "20", not "1" or "2".

---

    Code
      my_fun3("3")
    Condition
      Error:
      ! `an_arg` should be one of "30" or "20", not "3".
      i Did you mean "30"?

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

