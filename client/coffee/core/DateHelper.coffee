class DateHelper

  constructor: ->
      Date.iso8601Time = (string) =>
        time = ''
        hours = '00'
        minutes = '00'
        seconds = '00'

        reptms = /^PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?$/;

        if reptms.test(string)
            matches = reptms.exec(string)
            if matches[1]
              hours = Number(matches[1])
            if matches[2]
              minutes = Number(matches[2])
            if matches[3]
              seconds = Number(matches[3])
            time = hours + ':' + minutes
            if seconds != "00"
              time += ':' + seconds

        return time

      Date.prototype.setISO8601 = (string) =>
        regexp = "([0-9]{4})(-([0-9]{2})(-([0-9]{2})" +
          "(T([0-9]{2}):([0-9]{2})(:([0-9]{2})(\.([0-9]+))?)?" +
          "(Z|(([-+])([0-9]{2}):([0-9]{2})))?)?)?)?";
        d = string.match(new RegExp(regexp));

        offset = 0;
        date = new Date(d[1], 0, 1);

        if d[3]
          date.setMonth(d[3] - 1)
        if d[5]
          date.setDate(d[5])
        if d[7]
          date.setHours(d[7])
        if d[8]
          date.setMinutes(d[8])
        if d[10]
          date.setSeconds(d[10])
        if d[12]
          date.setMilliseconds(Number("0." + d[12]) * 1000)
        if d[14]
          offset = (Number(d[16]) * 60) + Number(d[17]);
          offset *= ((d[15] == '-') ? 1 : -1)

        offset -= date.getTimezoneOffset();
        time = (Number(date) + (offset * 60 * 1000))
        @.setTime(Number(time))
