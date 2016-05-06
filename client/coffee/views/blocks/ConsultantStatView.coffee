class ConsultantStatView extends Backbone.View
    ###
    # Возвращает необходимый темплейт
    ###
    template: JST['b-consultant-stat']

    STATE_OF_THEME_COLOR: {
        'default': 'state-grey',
        'g': 'state-green',
        'y' : 'state-yellow',
        'r' :'state-red'
    }

    ###
    # Создает экземпляр
    #
    # @constructor
    # #params {boolean}
    ###
    constructor: (modelUserStat) ->
        @.model = modelUserStat

        ConsultantStatView.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        @.html.remove()
        ConsultantStatView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        @.html = $(@.template(@))
        @.html.find('.b-consultant-stat-name').html(@.model.get('name'))

        @.stateCheckin = @.html.find('.b-consultant-stat-state-checkin')
        @.stateCheckOut = @.html.find('.b-consultant-stat-state-checkout')
        @.stateReport = @.html.find('.b-consultant-stat-state-report')

        checkinValue = @.model.get('checkinStatus')
        checkoutValue = @.model.get('checkoutStatus')
        reportValue = @.model.get('reportStatus')

        @.stateCheckin.addClass(@._getStateClass(checkinValue))
        @.stateCheckOut.addClass(@._getStateClass(checkoutValue))
        @.stateReport.addClass(@._getStateClass(reportValue))

        @.html

    _getStateClass: (value) ->
        if @.STATE_OF_THEME_COLOR[value]
            return @.STATE_OF_THEME_COLOR[value]

        return @.STATE_OF_THEME_COLOR['default']
