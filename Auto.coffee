module.exports = (robot) ->
  robot.hear /da/i, (res) ->
    room = 'playing_with_hubot'
    robot.messageRoom room, "Started..."
    robot.messageRoom room, "Beginning "
    robot.http('https://hyperchicken.m2.spreetail.org/api/v4/projects/11/pipelines?per_page=100').header('Accept', 'application/json').header('PRIVATE-TOKEN', 'xxx').get() (err, response, body) ->
       robot.messageRoom room, 'Inside First HTTP'
       if err
         robot.messageRoom room, 'Error in Fist Call'
         return
       robot.messageRoom room, 'Error Check Completed'
       resbody = null
       try
         resbody = JSON.parse(body)
       catch error
         robot.messageRoom room, 'Ran into an error parsing JSON in First Call :('
         return
       len = resbody.length
       robot.messageRoom room, ' Body of first API Call'+ resbody + 'length is ' +len
       i = 0
       while i < len
         item = resbody[i]
         if item.ref == 'master'
           masterRef = item.id
           robot.messageRoom room, ' The one with Ref = Master  ' + masterRef
           robot.http('https://hyperchicken.m2.spreetail.org/api/v4/projects/11/pipelines/#{masterRef}/jobs').header('Accept', 'application/json').header('PRIVATE-TOKEN', 'xx-xx').get() (err, response, body) ->   
             robot.messageRoom room, 'Inside Second HTTP'
             if err
                robot.messageRoom room, 'Error in Second call'
                return
              robot.messageRoom room, 'Error check completed for second call'
              resbody=null
              try
                resbody=JSON.parse(body)
              catch error
                robot.messageRoom room, 'Ran into an error parsing JSON in Second Call'
                return
              len =resbody.length
              robot.messageRoom room, 'Body of second API call' + body + 'Length is' +len
              j=0
              while j < len
                item=resbody[j]
                if item.name == 'execute_monkey'
                  jobId=item.id
                  robot.messageRoom room, 'The one with name as execute_monkey' +jobId
                  robot.http('https://hyperchicken.m2.spreetail.org/api/v4/projects/11/jobs/#{jobId}/play').header('Accept', 'application/json').header('PRIVATE-TOKEN', 'xxxx').get() (err, response, body) ->
                    robot.messageRoom room, 'Inside third API'
                    if err
                      robot.messageRoom room, 'Error in third call'
                      return
                    robot.messageRoom room, 'Error Check comepleted'
                    robot.messageRoom room, ' Body of third API' + body
                    resbody=null
                    try
                      resbody=JSON.parse(body)
                    catch error
                      robot.messageRoom room, 'Error in parsing the JSON in third call'
                      return
                    len=resbody.length
                    robot.messageRoom room, 'Body of third API Call' + body + ' Length is' + len
                    k=0
                    while k < len
                      item=resbody[k]
                      if item.id == jobId
                        robot.messageRoom room, 'Success'
                        break
                      k++
                  break
                j++
           break
         i++
		    return
