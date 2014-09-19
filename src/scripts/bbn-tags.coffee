# Description
#   A Hubot script that display bbn (blog.bouzuya.net) tags
#
# Configuration:
#   None
#
# Commands:
#   hubot bbn tags - display bbn (blog.bouzuya.net) tags
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  robot.respond /bbn\s+tags$/i, (res) ->
    url = 'http://blog.bouzuya.net/tags.json'
    res.http(url).get() (err, r, body) ->
      tags = JSON.parse(body)
      tags = [0..5].reduce (r) ->
        index = Math.floor(Math.random() * tags.length)
        r.concat [tags.splice(index, 1)[0]]
      , []
      message = tags
        .sort (a, b) ->
          if a.count < b.count
            1
          else if a.count is b.count
            0
          else
            -1
        .map (tag) ->
          "http://blog.bouzuya.net/posts?tags=#{tag.name} (#{tag.count})"
        .join '\n'
      res.send message
