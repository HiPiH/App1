class ResizeHelper

    @.zoomCalculate = (minWidht, currentWidht)->
        return Math.sqrt(currentWidht / minWidht) + 1

    constructor: ->
        @._minZoom = 1.4
        $(window).on("orientationchange", @.update)
        @.update()

    setupScale: () ->
        viewWidth = Math.max(document.documentElement.clientWidth, window.innerWidth);
        viewHeight = Math.max(document.documentElement.clientHeight, window.innerHeight);
        portWidth = Math.min(viewWidth, viewHeight);
        landWidth = Math.max(viewWidth, viewHeight);
        @.fixScale(landWidth, portWidth);

    fixScale: (landW, portW) ->
        zoom = 0;

        if Math.abs(window.orientation) != 90
            zoom = portW / Config.VIRTICAL_DEVICE_MIN_WIDTH
        else if Math.abs(window.orientation) == 90
            zoom = landW / Config.HORIZONTAL_DEVICE_MIN_WIDTH

        if (zoom < 1.2)
            zoom = @._minZoom

        document.body.style.zoom = zoom

    update: =>
        @.setupScale(Config.MIN_DEVICE_WIDTH)
