# Unsupported Project Warning!

This project is unmaintained; it was always intended as a proof-of-concept demonstration and not something for actual use.

# Pssychtest!

This is a little tiny demonstration app that collects some psychological data and stores it. It also does some summary aggregation. The responses will come through as a kind of heterogonous sludge of json. (Note: How true is this, actually? There's at least *some* defined structure to these responses. Can we actually just store these as structured data?)

The data we'll collect here will be the lag between a screen stimulus and keypress; we'll do it by showing a periodic flashing stimulus and having participants push a button when it blinks; the same trick is used in rhythm games. Participants can anticipate the flash, so it's not a reaction time test. However, there will be some lag between when the screen flashes and when a keypress is registered; we'll measure that.

For this test, we're gonna try stuffing things in a postgresql database.

For this example, we have three tables:

* **Assessments**, which stores each individual "session" of our task.
* **Events**, which contains data for *every actual event* (eg, screen flash, keypress) that happens during the task. Most of the data about an individual event is stored in an **event_json** json field.
* **Measurements**, which contains *numeric derived data* about the task — for example, reaction times. The main fields here are **type** which is simply a string to classify the data, and **value** which is a double-precision floating point number. This field may be used to store both individual measurements as well as aggregate measures such as mean and standard deviation.

Both events and measurements are recorded by a javascript-based client system, so it's possible for network problems and client bugs to cause repeated values in these tables. To help combat this, both tables contain a **unique_id** field that will be unique in combination with the assessment id. Yes, this id needs to be filled in by the client, and there could be a bug that makes events or measurements get added more than once, but it should be fairly easy to make that not happen.

