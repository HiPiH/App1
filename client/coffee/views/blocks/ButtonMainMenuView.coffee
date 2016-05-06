class ButtonMainMenuView extends Backbone.View
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-button'
    ###
    template: JST['b-button-main-menu']

    ###
    # Создает экземпляр CreateCategoryView
    #
    # @constructor
    # #params {boolean} edit (указывать при изменении категории)
    ###
    constructor: (options) ->
        _.extend(@, Backbone.Events)
        if !options
            options = {}

        @.style = options.style || 'report'
        @.text = options.text
        @.checkConnection = options.checkConnection || false
        @.html = ''

        ButtonMainMenuView.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        if @.html
            @.html.off()
            @._offEvent()
            @.html.remove()
        ButtonMainMenuView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        if not @.html
            @.html = $(@.template(@))
        @._offEvent()
        @._applyEvent()
        @.html

    ###
    # отключает элемент
    #
    ###
    disable: ->
        @.html.addClass('b-button-main-menu___disable');
        @._offEvent()
        @.html.off()

    ###
    # активирует элемент
    #
    ###
    enable: ->
        @.html.removeClass('b-button-main-menu___disable');
        @._offEvent()
        @._applyEvent()

    ###
    # тригер для клика
    #
    # @trigger {String} click
    ###
    _offEvent:=>
        if app.device.type == Device.TYPE_DESKTOP
            @.html.off('click', @_onMouseUp)
        else
            @.html.off('touchclick', @_onMouseUp)

    _applyEvent: ->
        @.html.off()
        if app.device.type == Device.TYPE_DESKTOP
            @.html.on('click', @_onMouseUp)
        else
            @.html.on('touchclick', @_onMouseUp)

    _onMouseUp: =>
        if !@.checkConnection
            @.trigger('click', @)
        else
            if app.device.checkConnection()
                @.trigger('click', @)
            else
                app.errorsManager.throwException('NoInternetConnection')
