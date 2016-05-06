class AuthOrange
    @.ERROR_USER_NOT_FOUND = 204
    @.EVENT_AUTH_SUCCESS = 'onSuccess'
    @.EVENT_AUTH_FAIL = 'onFail'

    _user: null
    _id: null

    constructor: ->
        _.extend(@, Backbone.Events)
        @._authValue = null

    weakUpSession: =>
        @._authValue = app.register.getItem('auth', null)
        @._id = app.register.getItem('id', null)

        if @._authValue != null && @._id != null
            if app.device.checkConnection() == false # для работы без инэта
                @._onSuccessFakeAuth()
                return

            @._requestAuth(@._authValue)
        else
            @._onFailAuth()

        return @._authValue;

    login: (id, pass) ->
        if !id || id.length == 0
            data = {'status': AuthOrange.ERROR_USER_NOT_FOUND}
            @._onFailAuth(data)
            return

        try
            @._authValue = btoa(id + ":" + pass)
            @._id = id
            @._requestAuth()
        catch e
            @._onFailAuth()

    logout: ->
        app.register.setItem('auth', null)
        app.register.setItem('id', null)
        @._onFailAuth()

    getUser: ->
        return @._user

    _requestAuth: ->
        app.soap.showLoading()
        $.ajax({
            type: "GET",
            url: Config.SERVER_URL,
            data: {},
            contentType: 'text/plain charset=UTF-8',
            beforeSend: (request) =>
                request.setRequestHeader("Authorization", "Basic " + @._authValue);
                request.setRequestHeader("login", @._id);
            ,
            success: @._onSuccessAuth
            ,
            error: @._onFailAuth
        })

    _onSuccessAuth: (data, message, xhr) =>
        if xhr && xhr['status'] && xhr['status'] == AuthOrange.ERROR_USER_NOT_FOUND
            @._onFailAuth(xhr)
            return;

        app.register.setItem('auth', @._authValue)
        app.register.setItem('id', @._id)

        @._user = new UserModel()
        @._user.set('id', @._id)
        @._user.set('authKey', @._authValue)

        @.trigger(AuthOrange.EVENT_AUTH_SUCCESS)

    _onSuccessFakeAuth: ->
        @._user = new UserModel()
        @._user.set('id', @._id)
        @._user.set('authKey', @._authValue)

        @.trigger(AuthOrange.EVENT_AUTH_SUCCESS)

    _onFailAuth: (data) =>
        app.register.setItem('auth', null)
        app.register.setItem('id', null)
        @.trigger(AuthOrange.EVENT_AUTH_FAIL, data)
