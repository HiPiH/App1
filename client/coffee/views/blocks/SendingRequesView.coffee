class SendingRequestView extends Backbone.View
    template: JST['b-sending-request']

    ###
    # Создает экземпляр OfflineMessage
    #
    # @constructor
    # #params {boolean} edit (указывать при изменении категории)
    ###
    constructor: () ->
        @._loading = false
        SendingRequestView.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        if @.html
            @._loading = false
            @.html.off()
            @.html.remove()
            app.soap.off('send:request',@._show)
            app.soap.off('send:success',@._hide)
            app.errorsManager.off('error:unknown',@._hide)
        SendingRequestView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        @.html = $(@.template(@))
        @.html.hide()
        @.overllay = @.html
        app.soap.on('send:request',@._show)
        app.soap.on('send:success',@._hide)
        app.soap.on('send:fail',@._hide)
        app.errorsManager.on('error:unknown',@._hide)
        @.html

    _show:=>
        if !@._loading
            @._loading = !@._loading
            @.html.show()
            @._timeoutID = setTimeout(@._hide,Config.LOADING_TIME_OUT_DELAY)

    _hide:=>
        if @._loading
            @._loading = !@._loading
            @.html.hide()
            clearTimeout(@._timeoutID)

