#= require ../../core/baseView.coffee


class ReportClientPageView extends BaseView
    ###
    # Возвращает необходимый темплейт
    # @template {function}
    ###
    template: JST['b-report-client-page']

    constructor: (sendReport = true) ->
        @._sendReport = sendReport
        ReportClientPageView.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        @._reportSpaContainer.remove()
        @._reportForm.remove()
        @._html.remove()
        ReportClientPageView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        ReportClientPageView.__super__.render.apply(@)
        @._html = $(@.template())
        @._reportSpaContainer = @._html.find('.b-report-client-container')
        @._reportForm = new ReportFormView(
          [
            {
              name: getText('Магазин')
              id:'ShopId',
              hidden: @._sendReport
            },
            {
              name: getText('Консультации'),
              id:'CountInfo'
            },
            {
              name: getText('Клиенты'),
              id:'CountReceipt'
            },
            {
              name: getText('Выручка'),
              id:'CountСash'
            },
            {
              name: getText('Продано штук'),
              id:'CountItem'
            },
            {
              name: getText('Приоритет1'),
              id:'CountPriority1'
            },
            {
              name: getText('Приоритет2'),
              id:'CountPriority2'
            },
            {
              name: getText('Thierry Mugler'),
              id:'CountPriority3'
            },
          ]
        ,
          ReportFormView.REPORT_TYPE_CLIENT
        ,
          @._sendReport
        )
        @._reportSpaContainer.html(@._reportForm.render())
        @._html

    ###
    # действия после отображения элемента
    #
    ###
    afterRender: =>

    headerTitle: =>
        if !@._sendReport
            return getText('Редактировать клиентский отчет')
        else
            return getText('Клиентский отчет')
