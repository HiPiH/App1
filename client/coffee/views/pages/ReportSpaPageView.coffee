#= require ../../core/baseView.coffee


class ReportSpaPageView extends BaseView
    ###
    # Возвращает необходимый темплейт
    # @template {function}
    ###
    template: JST['b-report-spa-page']

    constructor: (sendReport = true) ->
        @._sendReport = sendReport
        ReportSpaPageView.__super__.constructor.apply(@)

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        @._reportSpaContainer.remove()
        @._reportForm.remove()
        @._html.remove()
        ReportSpaPageView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        ReportSpaPageView.__super__.render.apply(@)
        @._html = $(@.template())
        @._reportSpaContainer = @._html.find('.b-report-spa-container')
        @._reportForm = new ReportFormView(
          [
            {
              name: getText('Магазин')
              id: 'ShopId',
              hidden: @._sendReport
            },
            {
              name: getText('Консультации'),
              id: 'CountInfo'
            },
            {
              name: getText('Клиенты'),
              id: 'CountReceipt'
            },
            {
              name: getText('Сумма процедур'),
              id: 'ProcedureSumm'
            },
            {
              name: getText('Кол-во процедур'),
              id: 'ProcedureCount'
            },
            {
              name: getText('Сумма после процедур'),
              id: 'BuyingSumm'
            },
            {
              name: getText('Кол-во после процедур'),
              id: 'CountReceipt2'
            }
          ]
        ,
          ReportFormView.REPORT_TYPE_SPA
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
            return getText('Редактировать SPA отчет')
        else
            return getText('SPA отчет')
