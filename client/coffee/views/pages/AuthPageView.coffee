#= require ../../core/baseView.coffee


class AuthPageView extends BaseView
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-start'
    ###
    template: JST['b-auth-page']

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        @.inputId.off()
        @.inputPass.off()
        @.btnSignIn.off()

        @.inputId.remove()
        @.inputPass.remove()
        @.btnSignIn.remove()
        @._html.remove()

        AuthPageView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        AuthPageView.__super__.render.apply(@)
        @._html = $(@.template())

        @.inputIDView = @._html.find('.b-auth-id')
        @.inputPassView = @._html.find('.b-auth-password')
        @.buttonSignInView = @._html.find('.b-auth-sign-in')
        @.errorView = @._html.find('.b-auth-error')
        @.errorView.html(getText('Неверный ID или пароль'))
        @.errorView.hide()

        @.inputId = new InputTextView(getText('Ваш id'), '', InputTextView.TYPE_NUMBER)
        @.inputPass = new InputTextView(
            getText('Пароль'), '', InputTextView.TYPE_PASSWORD,
            InputTextView.SIZE_BIG
        )
        @.btnSignIn = new ButtonView({text: getText('Авторизация'),checkConnection:true})

        @.inputIDView.html(@.inputId.render())
        @.inputPassView.html(@.inputPass.render())
        @.buttonSignInView.html(@.btnSignIn.render())

        @.btnSignIn.disable()

        @.listenTo(@.btnSignIn, 'click', @._onClickBtnSignIn)
        @.listenTo(@.inputId, 'inputError', @._onWrongFormat)
        @.listenTo(@.inputId, 'input', @._onRightFormat)

        @.listenTo(@.inputId, 'change', @._checkInputs)
        @.listenTo(@.inputPass, 'change', @._checkInputs)

        @._html

    ###
    # действия после отображения элемента
    #
    ###
    afterRender: =>

    needHeader: =>
        return false

    _checkInputs: =>
        if (@.inputId.getValue().length <= 0 or @.inputPass.getValue().length <= 0)
            @.btnSignIn.disable()
        else
            @.btnSignIn.enable()

    _onClickBtnSignIn: =>
        app.auth.once(AuthOrange.EVENT_AUTH_FAIL, @._onFailLogin)
        app.auth.login(@.inputId.getValue(), @.inputPass.getValue())

    _onFailLogin: (xhr) =>
        if xhr && xhr['status'] && xhr['status'] == AuthOrange.ERROR_USER_NOT_FOUND
            @.errorView.html(getText('Пользователь не найден'))
        else
            @.errorView.html(getText('Неверный пароль'))

        @.errorView.show()

    _onWrongFormat: =>
        @.errorView.html('')
        @.errorView.html(getText('Неверный формат')).show()

    _onRightFormat: =>
        @.errorView.html('').hide()
