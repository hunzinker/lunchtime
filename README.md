lunchtime
=========

Tired of eating boring sandwiches for lunch? Sticky lids on yesterday's soup
containers getting you down?

![Lunch Fail](http://i0.kym-cdn.com/photos/images/original/000/497/629/a11.gif)

Try lunchtime! It's fast. It's easy. And best of all, it's free!

Where should I go?

```bash
lunch.bash
```

Need variety?

```bash
lunch.bash -f /path/to/newline/delimited/lunchbox/file
```

See `lunchbox_example` for more information.

Lost?

```bash
lunch.bash -h
```

### Hubot Integration

Create `lunchbox/places` in Hubot's root directory to add your own variety. Add the below to `scripts/lunch.coffee`.

```coffeescript
# Description:
#   Lunch is the most important meal of the day!
#
# Commands:
#   None
#
# Notes:
#   None
#
# Author:
#   You!
#
# Dependencies:
#   None

exec = require('child_process').exec

module.exports = (robot) ->
  robot.hear /(lunch|meatwad)/i, (msg) ->
    child = exec 'lunch.bash -f lunchbox/places', (error, stdout, stderr) ->
      msg.send('\n' + stdout)
```
