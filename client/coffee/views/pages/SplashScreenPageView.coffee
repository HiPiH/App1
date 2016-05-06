#= require ../../core/baseView.coffee


class SplashScreenPageView extends BaseView
    ###
    # Возвращает необходимый темплейт
    # @template {function}
    ###
    template: JST['b-splash-page']

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        @._html.remove()
        SplashScreenPageView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        SplashScreenPageView.__super__.render.apply(@)
        @._html = $(@.template())
        @._html

    ###
    # действия после отображения элемента
    #
    ###
    afterRender: =>

    needHeader: =>
        return false
