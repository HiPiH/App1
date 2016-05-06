class AddressView extends Backbone.View
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-button'
    ###
    template: JST['b-address-view']

    ###
    # Создает экземпляр CreateCategoryView
    #
    # @constructor
    # #params {boolean} edit (указывать при изменении категории)
    ###
    constructor: (idAddress = "", nameLabel = "") ->
        @._idAddress = idAddress
        @._nameLabel = nameLabel
        @._html = ''

        AddressView.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        if @._html
            @._html.remove()
        AddressView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        @._html = $(@.template(@))
        @._idView = @._html.find('.b-address-view-id')
        @._addressView = @._html.find('.b-address-view-name')
        @._idView.html(@._idAddress)
        @._addressView.html(@._nameLabel)

        @._applyEvent()

        @._html

    setModelShop:(modelShop) ->
        @._idAddress = modelShop.get('id')
        @._nameLabel = modelShop.get('name')

        @._idView.html(@._idAddress)
        @._addressView.html(@._nameLabel)

    setAddressId: (id) =>
        @._idAddress = id
        @._idView.html(@._idAddress)

    setAddressName: (name) =>
        @._nameLabel = name
        @._addressView.html(@._nameLabel)

    getAddressId: ->
        @._idAddress

    getAddressName: ->
        @._nameLabel

    _applyEvent: =>
        if app.device.type == Device.TYPE_DESKTOP
            @._html.on('click', @._onClick)
        else
            @._html.on('touchclick', @._onClick)

    _onClick: =>
        @.trigger('click', @)
