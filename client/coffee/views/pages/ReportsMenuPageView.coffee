#= require ../../core/baseView.coffee


class ReportsMenuPageView extends BaseView
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-start'
    ###
    template: JST['b-reports-menu-page']

    constructor: ->
        ReportsMenuPageView.__super__.constructor.apply(@)
        @._dayStatus = app.auth.getUser().get('dayStatus')

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        @.btnStdReport.remove()
        @.btnClientReport.remove()
        @.btnSpaReport.remove()
        @.btnRpReport.remove()
        ReportsMenuPageView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        ReportsMenuPageView.__super__.render.apply(@)
        @._html = $(@.template())
        @.btnStdReportView = @._html.find('.b-reports-menu-btnStdReport')
        @.btnClientReportView = @._html.find('.b-reports-menu-btnClientReport')
        @.btnSpaReportView = @._html.find('.b-reports-menu-btnSpaReport')
        @.btnRpReportView = @._html.find('.b-reports-menu-btnRpReport')

        @.btnStdReport = new ButtonView({text: getText('Стандартный')})
        @.btnClientReport = new ButtonView({text: getText('Клиентский')})
        @.btnSpaReport = new ButtonView({text: getText('SPA')})
        @.btnRpReport = new ButtonView({text: getText('РК/РП')})

        @.btnStdReportView.html(@.btnStdReport.render())
        @.btnClientReportView.html(@.btnClientReport.render())
        @.btnSpaReportView.html(@.btnSpaReport.render())
        @.btnRpReportView.html(@.btnRpReport.render())

        @.listenTo(@.btnStdReport, 'click', @._onClickBtnStdReport)
        @.listenTo(@.btnClientReport, 'click', @._onClickBtnClientReport)
        @.listenTo(@.btnSpaReport, 'click', @._onClickBtnSpaReport)
        @.listenTo(@.btnRpReport, 'click', @._onClickBtnRpReport)

        if app.auth.getUser().get('employee') == 0
            @.btnRpReportView.hide()

        @._html

    ###
    # действия после отображения элемента
    #
    ###
    afterRender: =>

    headerTitle: =>
        return getText('Выбор отчета')

    _onClickBtnStdReport: ->
        route = 'menu/reports/checkin-standart/'
        if @._dayStatus == 2
            route = 'menu/reports/checkin-standart/report/'
        if @._dayStatus == 3
            route = 'menu/edit/std/'

        app.router.navigate(route, {trigger: true})

    _onClickBtnClientReport: ->
        route = 'menu/reports/checkin-client/'
        if @._dayStatus == 2
            route = 'menu/reports/checkin-client/report/'
        if @._dayStatus == 3
            route = 'menu/edit/client/'

        app.router.navigate(route, {trigger: true})

    _onClickBtnSpaReport: ->
        route = 'menu/reports/checkin-spa/'
        if @._dayStatus == 2
            route = 'menu/reports/checkin-spa/report/'
        if @._dayStatus == 3
            route = 'menu/edit/spa/'

        app.router.navigate(route, {trigger: true})

    _onClickBtnRpReport: ->
        app.router.navigate('menu/reports/checkin-rp/', {trigger: true})
