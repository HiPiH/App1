#= require baseView.coffee

class BaseListSearchView extends BaseView

    constructor: ->
        _.extend(@, Backbone.Events)
        BaseListSearchView.__super__.constructor.apply(@)

    onUpdateSearch: (value) ->
