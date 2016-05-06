#= require ../../core/baseView.coffee


class ReportFormView extends BaseView
    @.REPORT_TYPE_STANDART = 'reportTypeStandart'
    @.REPORT_TYPE_CLIENT= 'reportTypeClient'
    @.REPORT_TYPE_SPA = 'reportTypeSPA'
    @.REPORT_SAVE_PREFIX = 'savedReport_'

    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-start'
    ###
    template: JST['b-report-form']

    _reportMask: {
        'Classic': {
            'CountInfo': 0,
            'CountReceipt': 0,
            'CountItem': 0,
            'CountPriority1': 0,
            'CountPriority2': 0,
            'CountPriority3': 0,
            'CountСash': 0
        },
        'Spa': {
            'CountInfo': 0,
            'CountReceipt': 0,
            'BuyingSumm': 0,
            'CountReceipt2': 0,
            'ProcedureCount': 0,
            'ProcedureSumm': 0
        }
    }
    ###
    #
    # params filed Array<Object> поля для отображения + id + value
    # params type String тип отчета
    # params sendReport Boolean создание(true)/редактирование(false) отчета
    ####
    constructor:(fields, type = ReportFormView.REPORT_TYPE_STANDART, sendReport = true) ->
        @._reportTypeName = 'Classic'
        @._sendReportData = {}
        @._validtation = true
        if type == ReportFormView.REPORT_TYPE_SPA
            @._reportTypeName = 'Spa'

        @.fields = fields
        @._reportType = type
        @._sendReport = sendReport
        @._lastShopModel = app.register.getItem(CheckinPageView.CACHE_CHECKIN_SHOP_MODEL, null)
        @.listItems = []
        @._mainView = app.mainView
        if sendReport == false
            @._getDataOfReport()
    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        ReportFormView.__super__.remove.apply(@)
        @.btnSendReport.remove()
        @.shopId.off('focus',@._showSearchShop)
        @._html.remove()
    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        ReportFormView.__super__.render.apply(@)
        @._html = $(@.template())

        @.errorMessage = @._html.find('.form-error-massage')
        @.reportBtnWrapper = @._html.find('.b-report-std-form-btn-send-data')

        _.each(@.fields, (field) =>
            if (field['hidden'] != true)
                infoView = new InfoView(field, @._reportType, @._sendReport)
                @.listItems.push(infoView)
                @._html.find('.input-group').append(infoView.render())
        )

        @._html.find('input').on('input',@._onKeyUp)

        @.btnSendReport = new ButtonView({text: getText('Отправить данные'),checkConnection:true})

        @.reportBtnWrapper.append(@.btnSendReport.render())

        @.listenTo(@.btnSendReport, 'click', @._onClickBtnSendReport)
        @.shopId = @._html.find('#ShopId')
        @._mainView.header.on('onCancelSearch', @._onCancelSearch)
        @.shopId.on('focus',@._showSearchShop)

        @._html

    ###
    # действия после отображения элемента
    #
    ###
    afterRender: =>

    _getDataOfReport: () ->
        reportData = app.register.getItem(ReportFormView.REPORT_SAVE_PREFIX + @._reportType, null)

        if !reportData
            return

        for savedKey, savedValue of reportData
            for item in @.fields
                if (item['id'] == savedKey)
                    if item['id'] == 'ShopId'
                        item['value'] = if @._lastShopModel then @._lastShopModel.id  else savedValue
                    else
                        item['value'] = savedValue

    _onClickBtnSendReport: =>
        if @._checkValidation()

            dataRequest = {}
            dataInfoName = 'data'

            action = SOAPRequests.ACTION_SET_REPORT
            inputs = @._html.find('.b-report-std-form input')

            $(inputs).each((i,e) =>
                @._sendReportData[$(e).attr('id')] = parseInt($(e).val() || 0)
            )

            if !@._sendReport
                action = SOAPRequests.ACTION_SET_CHANGE_DATA
                dataRequest['shopId'] = if @._lastShopModel then @._lastShopModel.id else 0
                dataInfoName = 'report'

            if @._sendReport
                @._sendReportData['ShopId'] = if @._lastShopModel then @._lastShopModel.id  else ''

            dataRequest[dataInfoName] = {}
            dataRequest[dataInfoName][@._reportTypeName] = @._getConfirmedReportData(@._sendReportData, @._reportTypeName)

            app.soap.send(action, dataRequest, @._onSuccessSend, @._onFailSend)
        else
            nativeAlert(getText('Неверный формат данных'))

    _clearSavedFields: ->
        for item in @.listItems
            item.clearSavedValue()

    _onSuccessSend: =>
        @._clearSavedFields()

        if app.auth.getUser().get('dayStatus') == 2
            app.auth.getUser().set('dayStatus', 3)

        app.register.setItem(CheckinPageView.CACHE_CHECKIN_SHOP_MODEL, @._lastShopModel)
        app.register.setItem(ReportFormView.REPORT_SAVE_PREFIX + @._reportType, @._sendReportData)
        app.router.navigate('menu/', {trigger: true})

    _onFailSend: (data) =>
        console.log(data)

    _onKeyUp: =>
        if @._html.find('input').hasClass('error')
            @._validtation = false
            @.errorMessage.show()
        else
            @._validtation = true
            @.errorMessage.hide()

    _getConfirmedReportData: (dataObj, reportTypeName) ->
        result = {}
        itemsByReport = @._reportMask[reportTypeName]

        for savedKey, savedValue of itemsByReport
            for editKey, editValue of dataObj
                if (savedKey && editKey && editKey == savedKey)
                    result[editKey] = editValue
        return result

    _checkValidation: ->
        return @._validtation

    _showSearchShop: =>
        @.listSearch = [];
        collection = app.multitone.getShopCollection()
        collection.each (model) =>
            @.listSearch.push(new ShopListItemView(model))
        @.listSearchView = new ListSearchShopView(@.listSearch)
        @.listSearchView.on(ListSearchShopView.EVENT_CHANGE_ITEM, @._onChangeItem)
        @._mainView.header.deleteTitle()
        @._mainView.showSearch(@.listSearchView)

    _onChangeItem:(model)=>
        @._mainView.header.setTitle(@._mainView.header.getTitle())
        @.shopId.val(model.get('id'))
        @._lastShopModel = {id: model.get('id'), name: model.get('name')}
        @._mainView.hideSearch()

    _onCancelSearch:=>
        @._mainView.header.setTitle(@._mainView.header.getTitle())
