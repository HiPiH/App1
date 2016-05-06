class ButtonView extends Backbone.View
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-button'
    ###
    template: JST['b-button']

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

        @.style = options.style || 'standard'
        @.text = options.text
        @.checkConnection = options.checkConnection || false
        @.html = ''

        ButtonView.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        if @.html
            @.html.off()
            @.html.remove()
        ButtonView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        if not @.html
            @.html = $(@.template(@))

        @.enable()
        @.html

    ###
    # отключает элемент
    #
    ###
    disable: ->
        @.html.prop('disabled', true);
        @.html.addClass('b-button__disabled')
        @.html.removeClass('b-button__enabled')
        @.html.off()

    ###
    # активирует элемент
    #
    ###
    enable: ->
        @.html.prop('disabled', false);
        @.html.removeClass('b-button__disabled')
        @.html.addClass('b-button__enabled')
        @._applyEvent()

    ###
    # устанавливает указанный стиль
    #
    # @param {String} style стиль
    ###
    setStyle: (style) ->
        if @.html
            @.html.removeClass('btn-' + @.style)
            @.html.addClass('btn-' + style)

        @.style = style

    ###
    # тригер для клика
    #
    # @trigger {String} click
    ###
    _onClick: =>
        if !@.checkConnection
            @.trigger('click', @)
        else
           if app.device.checkConnection()
               @.trigger('click', @)
           else
               app.errorsManager.throwException('NoInternetConnection')

    _applyEvent: ->
        @.html.off()
        if app.device.type == Device.TYPE_DESKTOP
            @.html.on('click', @_onClick)
        else
            @.html.on('touchclick', @_onClick)
