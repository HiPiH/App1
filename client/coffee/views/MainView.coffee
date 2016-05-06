class MainView extends Backbone.View
    template: JST['b-main']

    initialize: ->
        @.html = $('body')
        app.device.on('deviceOffline',@._onOffline)
        app.device.on('deviceOnline',@._onOnLine)
        @.offlineMessage = new OfflineMessage()
        @.sendingRequstView = new SendingRequestView()
        @.render()

    render: ->
        @._listRender = null
        @.html.html($(@.template()))
        @.header = new HeaderView()
        @.header.on('onCancelSearch', @hideSearch)
        @.header.on('searchUpdate', @_onSearch)
        @.header.on('clickBack', @_onClickBack)
        @.searchList = $('.b-app-search-list')
        @.searchList.hide()
        @.content = $('.b-main')
        @.html.find('.b-app').append(@.sendingRequstView.render())
        @.html.find('.b-app').append(@.offlineMessage.render())


    getView: ->
        return @.view

    setView: (view) ->
        if @._view
            view.mainView = null
            @._view.remove()

        document.addEventListener("backbutton", @._onClickBack, false)
        window.scrollTo(0,0)

        if (!view.needHeader())
            $('.b-app-header').hide()
        else
            $('.b-app-header').html(@.header.render())
            $('.b-app-header').show()

        @._enableHeaderMarginIOS()

        if(view.headerBackButton())
            @.header.showButtonBack()
        else
            @.header.hideButtonBack()

        if(view.headerTitle)
            @.header.setTitle(view.headerTitle())

        @._view = view
        @._view.setMainView(@)
        
        @.content.html(@._view.render())
        @._view.afterRender()

        if (app.resize)
            app.resize.update();

    showSearch: (listRender) ->
        @._listRender = listRender
        @.header.showSearch()
        @.content.hide()
        @.searchList.html(listRender.render())
        @.searchList.show()

    _onSearch: (data) =>
        if !@._listRender
            return
        if !data
            @._listRender.onClearSearch()
        else
            @._listRender.onUpdateSearch(data)

    hideSearch: =>
        if (@._listRender)
            @._listRender.remove()

        @._listRender = null

        @.header.hideSearch()
        @.searchList.hide()
        @.content.show()

    _onClickBack: =>
        if @._listRender
            @.hideSearch()
            return
        fragment = Backbone.history.getFragment()

        if fragment == 'menu/' || fragment == 'auth/'
            @._messageExitApp()
        else
            window.history.back()

    _messageExitApp: =>
        navigator.notification.confirm(
            getText('Вы действительно хотите выйти?'),
            @._onMessageExitConfirm,
            getText('Выход'),
            getText('Отмена,Ок')
        )

    _onMessageExitConfirm: (button) =>
        if button == 2
            navigator.app.exitApp()

    _onOffline:()=>
         @.html.find('.b-offline-message').show()

    _onOnLine:() =>
         @.html.find('.b-offline-message').hide()

    _enableHeaderMarginIOS: ->
        try
            if app.device.os == Device.OS_IOS and parseInt(app.device.version) >= 7
                $('body').css('margin-top', '20px')
                $('.b-app-header').css('top', '20px')
                $('.b-app-ios-header').show()
        catch e
            console.log(e)