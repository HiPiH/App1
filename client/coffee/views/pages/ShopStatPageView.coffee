#= require ../../core/baseView.coffee


class ShopStatPageView extends BaseView
    @.DEFAULT_RESULTS = [
        {
            'shopId':getText('Все')
            'shopName':getText('Все')
            'a:Cash':0
            'a:Plan':0
            'a:CountPriority1':0
            'a:CountPriority2':0
            'a:CountPriority3':0
            'progressWidth':'width:'+0+'%'
            'done':0
        }
    ]
    @.calculateDone = (cash,plan) ->
        done = 0
        cash = if !_.isNaN(parseInt(cash)) then parseInt(cash) else 0
        plan = parseInt(plan)
        if (plan > 0 and cash >= 0 and !_.isNaN(plan))
            done = parseInt(cash)/parseInt(plan)*100
        return done.toFixed(1)

    @.calculateSum = (results) ->
        sumResults = {
            'a:Shop':{'a:Name':getText('Все'),'a:ShopId':0}
            'a:Cash':0
            'a:Plan':0
            'a:CountPriority1':0
            'a:CountPriority2':0
            'a:CountPriority3':0
            'shopId':0
            'shopName':getText('Все')
        }
        _.each(results,(e)->
            sumResults['a:Cash'] += parseInt(e['a:Cash'])
            sumResults['a:Plan'] += parseInt(e['a:Plan'])
            sumResults['a:CountPriority1'] += parseInt(e['a:CountPriority1'])
            sumResults['a:CountPriority2'] += parseInt(e['a:CountPriority2'])
            sumResults['a:CountPriority3'] += parseInt(e['a:CountPriority3'])
        )
        sumResults['done']  = ShopStatPageView.calculateDone(sumResults['a:Cash'],sumResults['a:Plan'])
        sumResults.progressWidth = 'width:'+sumResults['done']+'%'
        sumResults

    @.shopListMapper = (e) ->
        {
        'a:ShopId': e['a:Shop']['a:ShopId']
        'a:Name': e['a:Shop']['a:Name']
        }

    @.resultsMapper = (e) ->
        e['done'] = ShopStatPageView.calculateDone(e['a:Cash'],e['a:Plan'])
        e['shopId'] = e['a:Shop']['a:ShopId']
        e['shopName'] = e['a:Shop']['a:Name']
        e.progressWidth = 'width:'+e['done']+'%'
        e
    ###
    # Возвращает необходимый темплейт
    # @template {function} 'b-start'
    ###
    template: JST['b-shop-stat-page']

    constructor:->
        @._action = SOAPRequests.ACTION_GET_MONTH_RESULT_SHOP
        @.data = ShopStatPageView.DEFAULT_RESULTS
        @.sumResults = ShopStatPageView.DEFAULT_RESULTS
        @.allResults = []
        @._mainView = app.mainView

    ###
    # Действия при удалении вьюхи
    #
    # @return {Object} возвращает jq element
    ###
    remove: ->
        @._html.remove()
        ShopStatPageView.__super__.remove.apply(@)

    ###
    # Возвращаем вьюху
    #
    # @return {Object} возвращает jq element
    ###
    render: ->
        ShopStatPageView.__super__.render.apply(@)
        @._html = $(@.template(@))

        app.soap.send(@._action, '', @._onSuccessSend, @._onFailSend)

        @._html

    ###
    # действия после отображения элемента
    #
    ###
    afterRender: =>

    headerTitle: =>
        return getText('Статистика по магазинам')

    _showSearchShop: =>
        @.listSearch = [];
        @.allResults = _.map(@.results,(e)->
            return e
        )

        @.allResults.unshift(@.sumResults)

        shops = _.map(@.allResults,ShopStatPageView.shopListMapper)

        shopCollection = new CollectionShopInStats()
        shopCollection.parseData(shops)
        shopCollection.each (model) =>
            @.listSearch.push(new ShopListItemView(model))
        @.listSearchView = new ListSearchShopView(@.listSearch)
        @.listSearchView.on(ListSearchShopView.EVENT_CHANGE_ITEM, @._onChangeItem)

        @._mainView.header.deleteTitle()
        @._mainView.header.on('onCancelSearch', @._onCancelSearch)
        @._mainView.showSearch(@.listSearchView)

    _onSuccessSend: (result) =>
        @.results = _.map(result['a:MounthResultsShop'],ShopStatPageView.resultsMapper)

        @.sumResults = ShopStatPageView.calculateSum(@.results)

        @.data = @.sumResults

        @._html.html($(@.template(@)))
        @._applyEvent()

        @._html

    _applyEvent: =>
        if app.device.type == Device.TYPE_DESKTOP
            @._html.find('.shop').one('click', @._showSearchShop)
        else
            @._html.find('.shop').one('touchclick', @._showSearchShop)

    _onFailSend: (error) =>
        @._html.html($(@.template(@)))
        @._html

    _onChangeItem: (model) =>
        @.data = _.find(@.allResults,(result)->
            return parseInt(result['shopId']) == model.get('id')
        )

        @._mainView.hideSearch()
        @._mainView.header.setTitle(getText('Статистика по магазинам'))
        @._html.html($(@.template(@)))
        @._applyEvent()
        @._html

    _onCancelSearch:=>
        @._applyEvent()
        @._mainView.header.setTitle(@._mainView.header.getTitle())
