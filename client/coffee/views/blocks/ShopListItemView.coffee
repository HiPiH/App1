class ShopListItemView extends Backbone.View
    ###
    # Возвращает необходимый темплейт
    ###
    template: JST['b-shop-list-item']
    ###
    # Создает экземпляр ShopListItemView
    #
    # @constructor
    # #params {boolean} edit (указывать при изменении категории)
    ###
    constructor: (modelShop) ->
        _.extend(@, Backbone.Events)

        @._model = modelShop
        if (modelShop)
            @.id = modelShop.get('id')
            @.name = modelShop.get('name')

        @._html = ''

        ShopListItemView.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        if @._html
            @._html.off()
            @._html.remove()
        ShopListItemView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        @._html = $(@.template(@))
        @._applyEvent()
        
        @._html
    ###
    # Скрываем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    hide: ->
        @._html.hide()
        @._html.off()
        @._html
    ###
    # Показываем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    show:->
        @._html.show()
        @._applyEvent()
        @._html

    getModel: =>
        return @._model

    _applyEvent: ->
        if app.device.type == Device.TYPE_DESKTOP
            @._html.on('click', @._onClick)
        else
            @._html.on('touchclick', @._onClick)

    ###
    # тригер для клика
    #
    # @trigger {String} click
    ###
    _onClick: =>
        @.trigger('select', @._model)
