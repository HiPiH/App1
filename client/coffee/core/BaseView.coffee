#= extern Backbone.View

class BaseView extends Backbone.View

    constructor: ->
        @._mainView = null;
        BaseView.__super__.constructor.apply(@)


    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    remove: =>
        for key, value of @
            if value and typeof value.remove == 'function'
                value.remove()
    ###
    # функция для рендеринга
    #
    ###
    render: ->
        @.rendered = true

    ###
    # функция оповещения о конечном отображении
    #
    ###
    afterRender: ->
        for key, value of @
            if typeof value.afterRender == 'function' and value.rendered
                value.afterRender()

    ###
    # определяет, будет ли отображаться заголовок
    #
    ###
    needHeader: ->
        return true

    ###
    # будет ли кнопка назад в заголовке
    #
    ###
    headerBackButton: ->
        return true

    ###
    # возвращаем текст в заголовке
    #
    ###
    headerTitle: ->
        return null

    setMainView: (view) ->
        @._mainView = view

    getMainView: ->
        return @._mainView
