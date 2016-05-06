class SOAPRequests
    @.ACTION_GET_SHOP_SCHEDULE = 'GetShopFromShedule'
    @.ACTION_GET_SHOP_LIST = 'GetShopList'
    @.ACTION_GET_TYPE_EMPLOYEE = 'GetTypeEmploye'
    @.ACTION_GET_DAY_STATUS = 'GetStatusDay'
    @.ACTION_GET_DATA = 'GetData'
    @.ACTION_SET_CHANGE_DATA = 'SetChangeData'
    @.ACTION_GET_PLAN = 'GetPlan'
    @.ACTION_GET_MONTH_RESULT_EMPLOYEE = 'GetMounthResultEmploye'
    @.ACTION_GET_MONTH_RESULT_SHOP = 'GetMounthResultShop'
    @.ACTION_GET_DAY_RESULT_EMPLOYEE = 'GetDayResultEmploye'

    @.ACTION_SET_CHECKIN = 'SetCheckInData'
    @.ACTION_SET_CHECKOUT = 'SetCheckOutData'
    @.ACTION_SET_REPORT = 'SetReportData'

    _enableLoading: true
    _countOfSendMessage: 0;

    constructor: ->
        _.extend(@, Backbone.Events)
        $.support.cors = true;

    enableLoading:(value) ->
        @._enableLoading = value

    showLoading: ->
        @.trigger('send:request')

    showSuccess: ->
        @.trigger('send:success')

    showFail: ->
        @.trigger('send:fail')

    send: (action, jsonData = {}, success = null, fail = null) =>
       new @._sendMessage(action, jsonData, success, fail)

    _sendMessage: (action, jsonData, success, fail) =>
        if @._enableLoading
            @.showLoading();

        @._countOfSendMessage++;

        $.ajax({
            type: "POST",
            url: Config.SERVER_URL,
            data: @.generateXml(action, jsonData),
            contentType: 'text/xml',
            beforeSend: (request) =>
                request.setRequestHeader("Authorization", "Basic " + app.auth.getUser().get('authKey'));
                request.setRequestHeader("SOAPAction", "http://tempuri.org/IWcfService/" + action);
            ,
            success: (response) =>
                @._success(response, success, action + 'Response', action + 'Result')
            ,
            error: (response) =>
                @._fail(response, fail)
        })

    generateXml: (action, dataJSON) ->
        strJsonToXml = @._jsonToXmlString(dataJSON)
        userId = app.auth.getUser().get('id')

        strXml = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"' +
            ' xmlns:tem="http://tempuri.org/" ' +
            'xmlns:ivr="http://schemas.datacontract.org/2004/07/IVR_WCF_MOBILE.AnyType"' +
            '><soapenv:Header/><soapenv:Body><tem:' + action + '>' +
            '<tem:userId>' + userId + '</tem:userId>' + strJsonToXml.toString() + '</tem:' + action +
            '></soapenv:Body></soapenv:Envelope>'

        return strXml

    _jsonToXmlString: (json, tag='tem') ->
        str = ""
        for key, value of json
            if json.hasOwnProperty(key)
                if typeof value == 'object'
                    value = @._jsonToXmlString(value, 'ivr')
                str += '<' + tag + ':' + key + '>' + value + '</' + tag + ':' + key + '>'

        return str

    _success: (response, success, actionResponse, actionResult) =>
        json = {}
        try
            json = $.xml2json(new XMLSerializer().serializeToString(response.documentElement));
            if json['s:Envelope']
                json = json['s:Envelope']

            if json['s:Body']
                json = json['s:Body']

            if json[actionResponse]
                json = json[actionResponse]

            if json[actionResult]
                json = json[actionResult]
        catch e
            console.log('error parse xml to json')

        @._countOfSendMessage--
        if (success)
            success(json)
            if @._enableLoading and @._countOfSendMessage <= 0
                @.showSuccess()

    _fail: (response, fail) =>
        json = {}
        try
            json = $.xml2json(response.responseText);
            if json['s:Envelope']
                json = json['s:Envelope']

            if json['s:Body']
                json = json['s:Body']

            if json['s:Fault']
                json = json['s:Fault']

            if json['detail']
                json = json['detail']

            if json['ExceptionService']
                json = json['ExceptionService']

            if json['TypeException']
                json = json['TypeException']
        catch e
            console.log('error parse xml to json')

        @._countOfSendMessage--

        if (fail)
            if @._enableLoading
                @.showFail()
            fail(json)
        else
            console.log(response)

        app.errorsManager.throwException(json)
