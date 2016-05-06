class DayCalendarView extends Backbone.View
    ###
    # Возвращает необходимый темплейт
    # @template {function}
    ###
    template: JST['b-day-calendar']

    ###
    # Создает экземпляр DayCalendarView
    #
    # @constructor
    # #params {boolean} edit (указывать при изменении категории)
    ###
    constructor: (day, model) ->
        _.extend(@, Backbone.Events)
        @.day = day
        @.model = model
        DayCalendarView.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        if @.html
            @.html.off()
            @.html.remove()
        DayCalendarView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        @.html = $(@.template(@))

        @.view = @.html.find('.b-day-contents')
        @.view.html(@.day)
        if @.model
            if @.model.get('typeDay') == 'Standart' || @.model.get('typeDay') == 'Customer'
                @.view.addClass('day-contents-work-day__' + @.model.get('typeDay'))

        if @._isCurrentDay
            @.view.addClass('b-day-contents-current')

        @._applyEvent()
        @.html

    _applyEvent: ->
        if app.device.type == Device.TYPE_DESKTOP
            @.html.on('click', @._onClick)
        else
            @.html.on('touchclick', @._onClick)

    applyCurrentDay: ->
        @._isCurrentDay = true

    ###
    # тригер для клика
    #
    # @trigger {String} click
    ###
    _onClick: =>
        @.trigger('click', @)
