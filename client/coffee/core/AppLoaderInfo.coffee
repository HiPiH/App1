class AppLoaderInfo
    @.EVENT_SUCCESS_LOAD = 'onSuccess'
    @.EVENT_FAIL_LOAD = 'onFailLoad'

    constructor: ->
        _.extend(@, Backbone.Events)

    load: ->
        app.soap.send(SOAPRequests.ACTION_GET_DAY_STATUS, '', @._onLoadDayStatus, @._onFailInitAppInfo)

    _onLoadDayStatus: (response) =>
        status = Config.STATUS_DAY[response]
        app.auth.getUser().set('dayStatus', status)
        app.soap.send(SOAPRequests.ACTION_GET_TYPE_EMPLOYEE, '', @._onLoadTypeEmployee, @._onFailInitAppInfo)

    _onLoadTypeEmployee: (response) =>
        status = Config.TYPE_EMPLOYEE[response]
        app.auth.getUser().set('employee', status)
        app.soap.send(SOAPRequests.ACTION_GET_SHOP_LIST, '', @._onLoadShopList, @._onFailInitAppInfo)

    _onLoadShopList: (response) =>
        app.multitone.getShopCollection().parseData(response['a:Shop'])
        @.trigger(AppLoaderInfo.EVENT_SUCCESS_LOAD)

    _onFailInitAppInfo: =>
        @.trigger(AppLoaderInfo.EVENT_FAIL_LOAD)
