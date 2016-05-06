#= extern Backbone.Collection


class BaseCollection extends Backbone.Collection
    ###
    # загрузка моделй из локалсторедж
    #
    ###
    fetchLocal: =>
        models = app.register.getItem(@.localName, null)
        if models
            for value in models
                model = new @.model(value)
                @.add(model)
        @.trigger('fetchLocal', @)

    ###
    # сохранение моделе в локал сторедж
    #
    ###
    saveLocal: =>
        app.register.setItem(@.localName, @.models)
        @.trigger('saveLocal', @)
