#= extern Backbone.View

class ListSearchShopView extends BaseListSearchView
    @.EVENT_CHANGE_ITEM = 'onChangeItem'
    @.NUMBER_ITEMS = 50
    template: JST['b-list-search-shop']

    constructor: (listShopModels = []) ->
        ListSearchShopView.__super__.constructor.apply(@)
        @._numberItems = 50
        @._lastIndex = 0
        @._fullShopListModels = listShopModels
        @._listShopModels = @._fullShopListModels


    remove: ->
        if @._listShopModels && @._listShopModels.length
            for i in [0..@._listShopModels.length - 1]
                @._listShopModels[i].off()
                @._listShopModels[i].remove()

        @._listShopModels = null
        @._html.remove()
        ListSearchShopView.__super__.remove.apply(@)

    render: ->
        @._html = $ @template(@)
        @.placeholder = @._html.find('.b-list-search-shop-placeholder')
        @.placeholder.hide()
        @.placeholderMessage = @._html.find('.b-list-search-shop-placeholder-message')
        @.placeholderMessage.html(getText("Ничего не найдено"))
        @.placeholderMessage.hide()
        $(window).on('scroll',@._onScrollDown)
        @.list = @._html.find('.b-list-search-shop-list')
        @._renderItems(@._lastIndex,ListSearchShopView.NUMBER_ITEMS)
        @._html

    onUpdateSearch: (value) ->
        if(value)
            find = false
            @._listShopModels = @._fullShopListModels
            @._listShopModels = _.filter(@._listShopModels,(item)->
                if(item.getModel().get('id').toString().indexOf(value) > -1)
                    find = true
                    return true
            )
            if !find
                @.placeholder.show()
                @.placeholderMessage.show()
                @.list.html('')
            else
                @._lastIndex = 0
                @.placeholder.hide()
                @.placeholderMessage.hide()
                @.list.html('')
                @._renderItems(@._lastIndex,ListSearchShopView.NUMBER_ITEMS)

    onClearSearch: ->
        @._listShopModels = @._fullShopListModels
        @._lastIndex = 0
        @.placeholder.hide()
        @.placeholderMessage.hide()
        @.list.html('')
        @._renderItems(@._lastIndex,ListSearchShopView.NUMBER_ITEMS)

    _getNextSet: (lastIndex) ->
        @._lastIndex = lastIndex + 49
        if(@._lastIndex <= @._listShopModels.length)
            @._renderItems(@._lastIndex, @._lastIndex + ListSearchShopView.NUMBER_ITEMS)
        else
            @._renderItems(lastIndex, @._listShopModels.length)

    _renderItems: (start, end)->
        @._listShopModels.slice(start, end).forEach (view) =>
            view.once('select', @._onChangeItem)
            @.list.append(view.render())

    _onChangeItem: (model) =>
        @.trigger(ListSearchShopView.EVENT_CHANGE_ITEM, model)

    _onScrollDown: =>
        scrollTop = $(window).scrollTop()
        windowHeight = $(window).height()
        documentHeight = $(document).height()
        fullContentHeight = scrollTop + windowHeight + 10
        if @._listShopModels && fullContentHeight >= documentHeight && @._listShopModels.length + 1 > ListSearchShopView.NUMBER_ITEMS
            @._getNextSet(@._lastIndex)
