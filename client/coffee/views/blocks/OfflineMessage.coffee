class OfflineMessage extends Backbone.View
    template: JST['b-offline-message']

    ###
    # Создает экземпляр OfflineMessage
    #
    # @constructor
    # #params {boolean} edit (указывать при изменении категории)
    ###
    constructor: () ->
        @.text = getText('нет соединения с интернетом')
        OfflineMessage.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        if @.html
            @.html.off()
            @.html.remove()
        OfflineMessage.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        @.html = $(@.template(@))
        @.html

