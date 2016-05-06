#= require ../../core/baseView.coffee


class MenuPageView extends BaseView
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-start'
    ###
    template: JST['b-menu-page']

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        @.btnOrder.remove()
        @.btnEdit.remove()
        @.btnPlan.remove()
        @.btnResult.remove()
        @.btnStat.remove()
        @.btnExit.remove()
        @._html.remove()
        MenuPageView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        MenuPageView.__super__.render.apply(@)
        @._html = $(@.template())

        @.btnOrderView = @._html.find('.b-menu-page-btnOrder')
        @.btnEditView = @._html.find('.b-menu-page-btnEdit')
        @.btnPlanView = @._html.find('.b-menu-page-btnPlane')
        @.btnResultView = @._html.find('.b-menu-page-btnResult')
        @.btnStatView = @._html.find('.b-menu-page-btnStatistic')
        @.btnExitView = @._html.find('.b-menu-page-btnExit')

        @.btnOrder = new ButtonMainMenuView({text: getText('Отчет'), style: 'report',checkConnection: true})
        @.btnEdit = new ButtonMainMenuView({text: getText('Править'), style: 'edit',checkConnection: true})
        @.btnPlan = new ButtonMainMenuView({text: getText('План'), style: 'plan'})
        @.btnResult = new ButtonMainMenuView({text: getText('Результат'), style: 'result', checkConnection: true})
        @.btnStat = new ButtonMainMenuView({text: getText('Статистика'), style: 'statistics', checkConnection: true})
        @.btnExit = new ButtonMainMenuView({text: getText('Выход'), style: 'logout'})

        @.btnOrderView.html(@.btnOrder.render())
        @.btnEditView.html(@.btnEdit.render())
        @.btnPlanView.html(@.btnPlan.render())
        @.btnResultView.html(@.btnResult.render())
        @.btnStatView.html(@.btnStat.render())
        @.btnExitView.html(@.btnExit.render())

        @.listenTo(@.btnOrder, 'click', @._onClickBtnOrder)
        @.listenTo(@.btnEdit, 'click', @._onClickBtnEdit)
        @.listenTo(@.btnPlan, 'click', @._onClickBtnPlane)
        @.listenTo(@.btnResult, 'click', @._onClickBtnResult)
        @.listenTo(@.btnStat, 'click', @._onClickBtnStat)
        @.listenTo(@.btnExit, 'click', @._onClickBtnExit)

        @._checkMenuByDay()

        @._html

    ###
    # действия после отображения элемента
    #
    ###
    afterRender: =>
        app.soap.enableLoading(true)
        app.soap.showSuccess()

    ###
    # будет ли кнопка назад в заголовке
    #
    ###
    headerBackButton: ->
        return false

    headerTitle: =>
        return null

    _onClickBtnOrder: ->
        @._getStatusDay(@._openOrder)

    _onClickBtnEdit: ->
        @._getStatusDay(@._openReportOrder)

    _onClickBtnPlane: ->
        app.router.navigate('menu/plan/', {trigger: true})

    _onClickBtnResult: ->
        app.router.navigate('menu/result/', {trigger: true})

    _onClickBtnStat: ->
        app.router.navigate('menu/stats/', {trigger: true})

    _onClickBtnExit: ->
        app.device.enableGeoposition(false)
        app.auth.logout()

    _getStatusDay: (callBack) ->
        app.soap.send(SOAPRequests.ACTION_GET_DAY_STATUS, '', (response) =>
            status = Config.STATUS_DAY[response]
            app.auth.getUser().set('dayStatus', status)
            @._checkMenuByDay()

            if callBack
                callBack()
        )

    _openOrder: =>
        statusDay = app.auth.getUser().get('dayStatus')
        lastCheckinType = app.register.getItem(CheckinPageView.LAST_CHECKIN_TYPE, null)

        if statusDay == 0
            app.register.setItem(CheckinPageView.LAST_CHECKIN_TYPE, null)
            lastCheckinType = null

        if (statusDay == 1 && lastCheckinType != null)
            @._openCheckOutByType(lastCheckinType)
            return

        if (statusDay == 2 && lastCheckinType != null)
            @._openReportByType(lastCheckinType)
            return

        if (app.auth.getUser().get('dayStatus') == 0 and app.auth.getUser().get('employee') == 1)
            app.router.navigate('menu/reports/checkin-rp/', {trigger: true})
            return

        if statusDay >= 3
            nativeAlert(getText('Действие недоступно!'))
            return

        app.router.navigate('menu/reports/', {trigger: true})

    _openReportOrder: =>
        if (app.auth.getUser().get('dayStatus') < 3)
            nativeAlert(getText('Действие недоступно'))
            return

        lastCheckinType = app.register.getItem(CheckinPageView.LAST_CHECKIN_TYPE, null)
        if (app.auth.getUser().get('dayStatus') == 3 && lastCheckinType != null)
            @._openEditReportByType(lastCheckinType)
            return

        app.router.navigate('menu/', {trigger: true})

    _openCheckOutByType: (type) ->
        route = ''

        if type == MainViewRouter.TYPE_CHECKIN_STANDART
            route = 'menu/reports/checkin-standart/'
        else if type == MainViewRouter.TYPE_CHECKIN_CLIENT
            route = 'menu/reports/checkin-client/'
        else if type == MainViewRouter.TYPE_CHECKIN_RP
            route = 'menu/reports/checkin-rp/'
        else if type == MainViewRouter.TYPE_CHECKIN_SPA
            route =  'menu/reports/checkin-spa/'

        app.router.navigate(route, {trigger: true})

    _openReportByType: (type) ->
        route = ''

        if type == MainViewRouter.TYPE_CHECKIN_STANDART
            route = 'menu/reports/checkin-standart/report/'
        else if type == MainViewRouter.TYPE_CHECKIN_CLIENT
            route = 'menu/reports/checkin-client/report/'
        else if type == MainViewRouter.TYPE_CHECKIN_SPA
            route =  'menu/reports/checkin-spa/report/'

        app.router.navigate(route, {trigger: true})

    _openEditReportByType:(type) ->
        route = ''
        if type == MainViewRouter.TYPE_CHECKIN_STANDART
            route = 'menu/edit/std/'
        else if type == MainViewRouter.TYPE_CHECKIN_CLIENT
            route = 'menu/edit/client/'
        else if type == MainViewRouter.TYPE_CHECKIN_SPA
            route =  'menu/edit/spa/'

        app.router.navigate(route, {trigger: true})

    _checkMenuByDay: =>
        if app.auth.getUser().get('dayStatus') < 2 and app.device.geopositionEnabled() == false
            app.device.enableGeoposition(true)

        if app.auth.getUser().get('dayStatus') < 2
            app.device.updateGeoposition()

        if app.auth.getUser().get('dayStatus') >= 2
            app.device.enableGeoposition(false)

        if app.auth.getUser().get('dayStatus') < 3
            @.btnOrder.enable()
            @.btnEdit.disable()
        else
            @.btnEdit.enable()
            @.btnOrder.disable()

        if app.auth.getUser().get('employee') != 1
            @.btnStat.disable()
            @.btnPlan.enable()
            @.btnResult.enable()
        else
            @.btnStat.enable()
            @.btnPlan.disable()
            @.btnResult.disable()
