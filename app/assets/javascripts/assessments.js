window.console = window.console || {}
window.console.log = window.console.log || function() {};

console.log("Hello");

// Standard sum function
function sum(ar) {
  return ar.reduce(function(s, val) {
    return s + val;
  }, 0)
}

// arithmetic mean
function mean(ar) {
  return sum(ar) / ar.length;
}

function avg_square_diffs(ar) {
  var m = mean(ar);
  var sqdiffs = ar.map(function(e) {
    var d = e - m;
    return d * d;
  });
  return mean(sqdiffs);
}

// Yup, it's standard deviation
function stdev(ar) {
  return Math.sqrt(avg_square_diffs(ar));
}

function measurement_list() {
  var my = {};
  my.items = [];
  my.add_item = function(type, value) {
    var item = {
      'type': type,
      'value': value,
      'unique_id': my.items.length
    }
    my.items.push(item);
    return item;
  }
  return my;
}

function event_list() {
  var my = {};
  my.items = [];
  my.add_item = function(timestamp, event) {
    var item = {
      'timestamp': timestamp,
      'unique_id': my.items.length,
      'event': event
    }
    my.items.push(item);
    return item;
  }
  return my;
}

var blink_controller = function(cycle_ms, blink_ms, blink_element, record_blinks) {
  var my = {};
  my.cycle_ms = cycle_ms;
  my.blink_ms = blink_ms;
  my.blink_element = blink_element;
  my.record_blinks = record_blinks;
  my.blinks_recorded = 0;
  my.event_list = [];

  my.keep_blinking = false;
  my.started = false;
  my.finished = false;

  function blink_on() {
    my.blink_element.classList.add("on");
    if (my.started) {
      my.blinks_recorded += 1;
      console.log(my.blinks_recorded);
    }
  }

  function blink_off() {
    my.blink_element.classList.remove("on");
    if (my.blinks_recorded >= my.record_blinks) {
      my.finished = true;
      my.stop_blinking();
      my.event_list.push({
        'type': 'collection_finish',
        'timestamp': window.performance.now()
      });
      var evt = new Event('finish');
      my.blink_element.dispatchEvent(evt);
    }
  }

  var handle_frame = function(timestamp) {
    // console.log("in handle_frame...")
    if (my.keep_blinking) {
      my.last_frame_time = my.last_frame_time || timestamp;
      var elapsed = timestamp - my.last_frame_time;
      // console.log([elapsed, my.blink_remaining, my.cycle_remaining].join("\t"));
      if (isFinite(my.blink_remaining)) {
        my.blink_remaining -= elapsed;
      }
      if (my.blink_remaining <= 0) {
        blink_off();
        my.blink_remaining = NaN;
        my.event_list.push({
          'type': 'blink_off',
          'timestamp': timestamp
        });
        console.log("blink_off\t"+timestamp);
      }

      my.cycle_remaining -= elapsed;
      if (my.cycle_remaining <= 0 ) {
        blink_on();
        my.blink_remaining = my.blink_ms;
        my.cycle_remaining = my.cycle_ms;
        my.event_list.push(
          {
            "type": "blink_on",
            "timestamp": timestamp
        });
        console.log("blink_on\t"+timestamp);
      }
      my.last_frame_time = timestamp;

      if (my.keep_blinking) {
        window.requestAnimationFrame(handle_frame);
      }
    }
  }

  my.start_blinking = function() {
    my.keep_blinking = true;
    my.cycle_remaining = my.cycle_ms;
    my.blink_remaining = my.blink_ms;
    window.requestAnimationFrame(handle_frame);
  }

  my.stop_blinking = function() {
    my.keep_blinking = false;
  }

  function make_sort_function(evt) {
    return function(ke1, ke2) {
      var dist1 = Math.abs(evt.timestamp - ke1.timestamp);
      var dist2 = Math.abs(evt.timestamp - ke2.timestamp);
      return dist1 - dist2;
    };
  }

  function get_blink_events() {
    return my.event_list.filter(function(e) { return e.type == 'blink_on'; });
  }

  function get_press_events() {
    return my.event_list.filter(function(e) { return e.type == 'keypress'; });
  }

  my.match_blinks_and_presses = function() {
    var blinks = get_blink_events();
    var bs = blinks.slice();
    var presses = get_press_events();

    console.log(presses);
    presses.forEach(function(p) {
      console.log("Finding closest blink...");
      console.log(p);
      var sort_fx = make_sort_function(p);
      bs.sort(sort_fx);
      console.log(p);
      var b = bs[0];
      console.log("Closest match:");
      console.log([p.timestamp, b.timestamp]);
      b.press_candidate = b.press_candidate || p;
      var old_diff = Math.abs(b.timestamp, b.press_candidate.timestamp);
      var new_diff = Math.abs(b.timestamp, p.timestamp);
      if (new_diff < old_diff) {
        b.press_candidate = p;
      }
    });
    console.log(blinks);

    return blinks.filter(function(b) { return b.press_candidate; }).map(function(b) {
      return {
        "blink": b,
        "press": b.press_candidate,
        "diff": b.press_candidate.timestamp - b.timestamp
      }
    });
  }

  function record_press(timestamp) {
    my.event_list.push({
      'type': 'keypress',
      'timestamp': timestamp
    });
  }

  my.handle_press = function(event) {
    var ts = window.performance.now();
    console.log(event);
    if (my.finished) {
      return;
    }
    if (!my.started) {
      console.log("starting to record");
      my.event_list.push({
        'type': 'collection_start',
        'timestamp': ts
      });
      my.blink_element.dispatchEvent(new Event('start'));
      my.started = true;
    }
    record_press(ts);
  }

  my.data_for_reporting = function() {
    var out = {}
    var el = event_list();
    my.event_list.forEach(function(e) {
      el.add_item(e.timestamp, e);
    })
    out.events = el.items;
    var ml = measurement_list();
    var diffs = my.match_blinks_and_presses().map(function(match) {
      return match.diff;
    });
    diffs.forEach(function(e) { ml.add_item('lag', e)});
    ml.add_item('mean_lag', mean(diffs));
    ml.add_item('sd_lag', stdev(diffs));
    out.measurements = ml.items;
    return out;
  }

  my.report_data = function(url, csrf_token) {
    var xhr = new XMLHttpRequest();
    var data = my.data_for_reporting();
    data['authenticity_token'] = csrf_token;
    data['completed'] = true;
    xhr.open('PUT', url);
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.addEventListener('load', function(evt) {
      console.log(evt);
    })
    xhr.send(JSON.stringify(data));
  }

  return my;
}
