define [
  'jquery'
  'underscore'
  'backbone.loader'
  'domain/cache'
  'views/ui/typeahead'
  'views/player/list'
  'tpl!templates/league/invite.html'

], ($, _, Backbone, DomainCache, TypeAhead, PlayerListView, LeagueInviteTpl) ->
  Backbone.Marionette.Layout.extend
    template: LeagueInviteTpl

    regions:
      playersRegion: '.players-region'
      typeAheadRegion: '.typeahead-region'

    vent: null
    model: null
    collection: null

    initialize: (opts) ->
      @vent = opts.vent ? _.extend {}, Backbone.Events

      collection = new (DomainCache.getCollection('players'))()
      collection.fetch()
      @typeAhead = new TypeAhead
        collection: collection
        placeholder: 'Search for players...'

      @listenTo @typeAhead, 'model:selected', (player) =>
        @_setPlayerStaged player, true
      @vent.on 'player:remove', (player) =>
        @_setPlayerStaged player, false

    onRender: ->
      @typeAheadRegion.show @typeAhead
      @playersRegion.show new PlayerListView(
        collection: @collection
        vent: @vent
      )

    _setPlayerStaged: (player, staged) ->
      if staged
        unless @collection.contains player
          @collection.add player
          @typeAhead.remove player

        setTimeout(() =>
          @typeAhead.val ''
        , 10)
      else
        @collection.remove player
        @typeAhead.add player
