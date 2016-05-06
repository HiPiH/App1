class Application
    deviceReady: false
    documentReady: false

    constructor: ->
        _.extend(@, Backbone.Events)

        $(document).on('deviceready', @._onDeviceReady)
        $(document).on('ready', @._onDocumentReady)

    _onDeviceReady: =>
        @.deviceReady = true
        if @.documentReady
            @.trigger('ready')

    _onDocumentReady: =>
        @.documentReady = true
        if @.deviceReady
            @.trigger('ready')
            return

        try
            cordova
        catch Error
            @.trigger('ready')
