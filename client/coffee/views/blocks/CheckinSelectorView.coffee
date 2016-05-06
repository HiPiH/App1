class CheckinSelectorView extends Backbone.View
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-button'
    ###
    template: JST['b-checkin-selector']

    initialize: ->
        @.offlineMessage = new SendingRequestView()
    ###
    # Создает экземпляр CreateCategoryView
    #
    # @constructor
    # #params {boolean} edit (указывать при изменении категории)
    ###
    constructor: (indexSelect = 0) ->
        @._indexSelect = indexSelect
        @._html = ''

        CheckinSelectorView.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        if @._html
            @._html.remove()
        CheckinSelectorView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        @._html = $(@.template(@))
        @._html.find('.b-checkin-selector-item-standart')
            .html(getText('стандартный'))
        @._html.find('.b-checkin-selector-item-client')
            .html(getText('клиентский'))
        @._html.find('.b-checkin-selector-item-spa')
            .html(getText('spa'))
        @._html.find('.b-checkin-selector-item-rp')
            .html(getText('рк/рп'))

        @.items = @._html.children();
        $(@.items[@._indexSelect]).addClass('b-checkin-selector-arrow')
        @.content = $('.b-main')
        @._html


