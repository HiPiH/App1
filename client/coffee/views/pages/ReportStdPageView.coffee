#= require ../../core/baseView.coffee


class ReportStdPageView extends BaseView
    ###
    # Возвращает необходимый темплейт
    # @template {function}
    ###
    template: JST['b-report-std-page']

    constructor: (sendReport = true) ->
        @._sendReport = sendReport
        ReportStdPageView.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        @._reportSpaContainer.remove()
        @._reportForm.remove()
        @._html.remove()
        ReportStdPageView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        ReportStdPageView.__super__.render.apply(@)
        @._html = $(@.template())
        @._reportSpaContainer = @._html.find('.b-report-std-container')
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
          ReportFormView.REPORT_TYPE_STANDART
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
            return getText('Редактировать стандартный отчет')
        else
            return getText('Стандартный отчет')
