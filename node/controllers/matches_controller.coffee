define [
  'underscore'
  'models/match'
  'helpers/elo'
  'winston'

], (_, Match, Elo, winston) ->

  query: (request, response, next) ->
    Match.find()
      .select('_id winners losers date')
      .lean()
      .exec (arr, data) ->
        response.json data

  get: (request, response, next) ->
    Match.findById(request.params.id)
      .select('_id winners losers date')
      .lean()
      .exec (arr, data) ->
        response.json data

  create: (request, response, next) ->
    body = JSON.parse request.body
    match = new Match
      winners: body.winners
      losers: body.losers

    match.save (err) ->
      if err?
        winston.error err
        response.json err
      else
        Elo.applyMatch match
        response.json match
