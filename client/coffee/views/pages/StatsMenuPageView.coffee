#= require ../../core/baseView.coffee


class StatsMenuPageView extends BaseView
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-start'
    ###
    template: JST['b-stats-menu-page']

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        @.btnShopStat.remove()
        @.btnConsultantStat.remove()
        StatsMenuPageView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        StatsMenuPageView.__super__.render.apply(@)
        @._html = $(@.template())
        @.btnConsultantStatView = @._html.find('.b-stats-menu-btnConsultantStat')
        @.btnShopStatView = @._html.find('.b-stats-menu-btnShopStat')


        @.btnConsultantStat = new ButtonView({text: getText('по консультантам'),checkConnection:true})
        @.btnShopStat = new ButtonView({text: getText('по магазинам'),checkConnection:true})

        @.btnConsultantStatView.html(@.btnConsultantStat.render())
        @.btnShopStatView.html(@.btnShopStat.render())

        @.listenTo(@.btnConsultantStat, 'click', @._onClickBtnConsultantStat)
        @.listenTo(@.btnShopStat, 'click', @._onClickBtnShopStat)

        @._html

    ###
    # действия после отображения элемента
    #
    ###
    afterRender: =>

    headerTitle: =>
        return getText('Статистика')

    _onClickBtnConsultantStat: ->
        app.router.navigate('menu/stats/consultant/', {trigger: true})

    _onClickBtnShopStat: ->
        app.router.navigate('menu/stats/shop/', {trigger: true})
