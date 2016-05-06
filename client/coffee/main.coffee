#= require core/application.coffee

getText = $.i18n

nativeAlert = (message) ->
    if app.device.type == Device.TYPE_DESKTOP
        alert(message)
    else
        navigator.notification.alert(
          message,
          null,
          getText(Config.APP_NAME),
          getText('Ок')
        )

initApplication = ->
    $.support.cors = true
    new DateHelper()
    app.device = new Device()
    app.router = new MainViewRouter()
    app.translate = new Localization(runApplication)
    if app.device.os == Device.OS_WINPHONE
        StatusBar.hide()


runApplication = ->
    app.auth = new AuthOrange()
    app.errorsManager = new ErrorsManager()
    app.register = new Register()
    app.soap = new SOAPRequests()
    app.mainView = new MainView()
    app.soap.enableLoading(false)
    app.resize = null;
    app.device.enableOrientation(Device.ORIENTATION_PORTRAIT)

    app.multitone = new Multitone()
    app.loaderInfo = new AppLoaderInfo()

    Backbone.history.stop()
    Backbone.history.start()

    app.loaderInfo.on(AppLoaderInfo.EVENT_SUCCESS_LOAD, =>
        if app.device.os != Device.OS_WINPHONE
            app.device.enableOrientation(Device.ORIENTATION_UNLOCK)
        app.router.navigate('menu/', {trigger: true})
    )

    app.loaderInfo.on(AppLoaderInfo.EVENT_FAIL_LOAD, =>
        app.auth.logout()
    )

    if app.device.os == Device.OS_ANDROID
        app.resize = new ResizeHelper()
        $.ajaxSetup({ cache: false })
    else if app.device.os == Device.OS_IOS
        $.ajaxSetup({ cache: false, async: false })

    app.auth.on(AuthOrange.EVENT_AUTH_SUCCESS, =>
        $.ajaxSetup({ cache: false, async: true })
        if app.device.checkConnection() == false
            if app.device.os != Device.OS_WINPHONE
                app.device.enableOrientation(Device.ORIENTATION_UNLOCK)
            app.router.navigate('menu/', {trigger: true})
            return

        app.loaderInfo.load()
    )

    app.auth.on(AuthOrange.EVENT_AUTH_FAIL, =>
        app.soap.enableLoading(false)
        app.soap.showFail()
        if app.device.os != Device.OS_WINPHONE
            app.device.enableOrientation(Device.ORIENTATION_UNLOCK)
        app.router.navigate('auth/', {trigger: true})
    )

    setTimeout(app.auth.weakUpSession, 3000)

app = new Application()
app.on('ready', initApplication)
