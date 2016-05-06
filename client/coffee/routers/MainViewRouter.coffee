#= extern Backbone.Router


class MainViewRouter extends Backbone.Router
    @.TYPE_CHECKIN_STANDART = 0
    @.TYPE_CHECKIN_CLIENT = 1
    @.TYPE_CHECKIN_SPA = 2
    @.TYPE_CHECKIN_RP = 3

    routes:
        '': '_start'
        'auth/': '_authPage'
        'menu/': '_menuPage'
        'menu/reports/': '_reportsPage'
        'menu/reports/checkin-standart/': '_checkinStandart'
        'menu/reports/checkin-client/': '_checkinClient'
        'menu/reports/checkin-spa/': '_checkinSPA'
        'menu/reports/checkin-rp/': '_checkinRP'
        'menu/reports/checkin-standart/report/': '_reportStdPage'
        'menu/reports/checkin-spa/report/': '_reportSpaPage'
        'menu/reports/checkin-client/report/': '_reportClientPage'
        'menu/edit/': '_editReportMenuPage'
        'menu/edit/std/': '_editStdReportPage'
        'menu/edit/client/': '_editClientReportPage'
        'menu/edit/spa/': '_editSpaReportPage'
        'menu/stats/':'_menuStats'
        'menu/stats/consultant/': '_consultantStat'
        'menu/stats/shop/': '_shopStat'
        'menu/result/': '_result'
        'menu/plan/': '_planPage'


    _start: ->
        app.mainView.setView(new SplashScreenPageView())

    _authPage: ->
        app.mainView.setView(new AuthPageView())

    _menuPage: ->
        app.mainView.setView(new MenuPageView())

    _checkinStandart: ->
        app.mainView.setView(new CheckinPageView(MainViewRouter.TYPE_CHECKIN_STANDART))

    _checkinClient: ->
        app.mainView.setView(new CheckinPageView(MainViewRouter.TYPE_CHECKIN_CLIENT))

    _checkinSPA: ->
        app.mainView.setView(new CheckinPageView(MainViewRouter.TYPE_CHECKIN_SPA))

    _checkinRP: ->
        app.mainView.setView(new CheckinPageView(MainViewRouter.TYPE_CHECKIN_RP))

    _searchShop: ->
        app.mainView.setView(new SearchShopPageView())

    _consultantStat: ->
        app.mainView.setView(new ConsultantStatPageView())
        
    _reportsPage: ->
        app.mainView.setView(new ReportsMenuPageView())

    _reportStdPage: ->
        app.mainView.setView(new ReportStdPageView())

    _reportSpaPage: ->
        app.mainView.setView(new ReportSpaPageView())

    _reportClientPage: ->
        app.mainView.setView(new ReportClientPageView())

    _editReportMenuPage: ->
        app.mainView.setView(new EditReportMenuPageView())

    _editStdReportPage: ->
        app.mainView.setView(new ReportStdPageView(false))

    _editClientReportPage: ->
        app.mainView.setView(new ReportClientPageView(false))

    _editSpaReportPage: ->
        app.mainView.setView(new ReportSpaPageView(false))

    _menuStats: ->
        app.mainView.setView(new StatsMenuPageView())

    _shopStat: ->
        app.mainView.setView(new ShopStatPageView())

    _result: ->
        app.mainView.setView(new ResultPageView())

    _planPage: ->
        app.mainView.setView(new PlanPageView())
