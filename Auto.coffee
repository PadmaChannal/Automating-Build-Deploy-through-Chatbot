# Description:
#   Calling Git API to execute OCTO-DEPLOY
#
# Dependecies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot Deploy em
#
# Author:
#   Padma Channal

module.exports = (robot) ->
  robot.hear /Deploy em/i, (res) ->
    room = 'nerds'
    robot.messageRoom room, ":nerd: Triggering Deployment :chart_with_upwards_trend: . . . ."
    robot.http('https://example.com/api/v4/projects/11/pipelines?per_page=100').header('Accept', 'application/json').header('PRIVATE-TOKEN', 'xxx-xxx').get() (err, response, body) ->
       if err
         robot.messageRoom room, 'Error in Fetching the pipelines'
         return
       resbody = null
       try
         resbody = JSON.parse(body)
       catch error
         return
       i=0   
       while i < resbody.length
         if  resbody[i].ref == 'master'
           #robot.messageRoom room, ' The one with Ref = Master  ' + resbody[i].id
           url='https://example.com/api/v4/projects/11/pipelines/' + resbody[i].id + '/jobs'
           robot.http(url).header('Accept', 'application/json').header('PRIVATE-TOKEN', 'xxx-xxx').get() (err, response, body) ->
             if err
                robot.messageRoom room, 'Error in Second call'
                return
              resbody=null
              try
                resbody = JSON.parse(body)
              catch error
                return
              j=0
              while j < resbody.length
                if resbody[j].name == 'execute_octoDeploy'
                  #robot.messageRoom room, 'check for' +resbody[j].id
                  url='https://example.com/api/v4/projects/11/jobs/' + resbody[j].id + '/play'
                  robot.http(url).header('Accept', 'application/json').header('PRIVATE-TOKEN', 'xxx-xxx').post() (err, response, body) ->
                    if err
                      robot.messageRoom room, 'Error in third call'
                      return
                    else
                      url ='https://example.com/api/v4/projects/11/jobs/' + resbody[j].id  + '/retry'
                      robot.http(url).header('Accept', 'application/json').header('PRIVATE-TOKEN', 'xxx-xxx').post() (err, response, body) ->
                    resbody=null
                    try
                      resbody=JSON.parse(body)
                    catch error
                      robot.messageRoom room, 'Error in parsing the JSON in third call'
                      return
                  break
                j++
           break
         i++
		    return
