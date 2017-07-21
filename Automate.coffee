# Description:
#   Calling Git API.
#
# Dependecies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot could you deploy - 
#
# Author:
#   Padma Channal

module.exports = (robot) ->
  robot.respond /could you deploy$/i,(res) ->
	  res.send 'I am initiating the deployment'
	  robot.http("https://gitlab.example.com//api/v4/projects/11/jobs/16863/retry")
    .header('PRIVATE-TOKEN', 'xxx')
    .post() (err, res, body) ->
      if err
        res.send "Encountered an error :( #{err}"
        return
	  res.send "Got back the body --> #{body}"
adding more of sync http calls to handle Gitlab runner bottle neck

	  

     
