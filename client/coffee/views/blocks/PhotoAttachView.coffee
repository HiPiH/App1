class PhotoAttachView extends Backbone.View
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-photo-attach'
    ###
    template: JST['b-photo-attach']

    ###
    # Создает экземпляр
    #
    # @constructor
    ###
    constructor: (imageBase64) ->
        _.extend(@, Backbone.Events)

        @.setImage(imageBase64)
        @.html = ''

        PhotoAttachView.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        @.btnClose.off()
        @._imageBase64 = null
        @.html.remove()

        PhotoAttachView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        @.html = $(@.template(@))
        @.imageView = @.html.find('.b-photo-attach-image')
        @.btnClose = @.html.find('.b-photo-attach-delete')
        @.btnClose.on('click', @._onClick)

        if (@._imageBase64 && @._imageBase64.length > 0)
            @.imageView.attr('src', "data:image/jpeg;base64," + @._imageBase64)
        @.html

    setImage: (imageBase64) =>
        if !imageBase64
            imageBase64 = ''
        @._imageBase64 = imageBase64;

        if @.imageView
            @.imageView.attr('src', "data:image/jpeg;base64," + @._imageBase64)

    getImage: =>
        return @._imageBase64

    ###
    # тригер для удаления
    #
    # @trigger {String} click
    ###
    _onClick: =>
        @._imageBase64 = null
        @.imageView.attr('src', "")
        @.trigger('close', @)
