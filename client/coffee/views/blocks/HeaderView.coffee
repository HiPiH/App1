#= extern Backbone.View

class HeaderView extends BaseView
    template: JST['b-header']

    initialize: ->
        _.extend(@, Backbone.Events)
        @._html = $(@.template())

        @.leftElement = @._html.find('.b-header-left')
        @.searchElement = @._html.find('.b-header-search')
        @.logo = @._html.find('.b-header-center')
        @.titleText = @._html.find('.b-header-title-text')
        @.title = @._html.find('.b-header-title');
        @._titleText = ''
        @.search = new SearchView();
        @.search.on('update', @._onSearch)
        @.search.on('cancel', @._onCancelSearch)

    render: ->
        HeaderView.__super__.render.apply(@)
        @._html

    setTitle: (title) ->
        if (title == null || title == '')
            @.title.hide();
            return;
            
        @.title.show()
        @._titleText = title
        @.titleText.html(title)

    getTitle:() ->
        return @._titleText

    deleteTitle: ->
        @.title.hide()
        @.titleText.html('')

    showButtonBack: ->
        @.leftElement.show()
        @._applyEvent()

    hideButtonBack: ->
        @.leftElement.hide()
        @.leftElement.off()

    _applyEvent: ->
        if app.device.type == Device.TYPE_DESKTOP
            @.leftElement.on('click', @_onClickBack)
        else
            @.leftElement.on('click', @_onClickBack)

    showSearch: =>
        @.logo.hide()
        @hideButtonBack()
        @.search.on('update', @_onSearchUpdate)
        @.search.on('clear', @_onSearchClear)
        @.searchElement.html(@.search.render())

    hideSearch: =>
        @.logo.show()
        @showButtonBack()
        @.search.off('update', @_onSearchUpdate)
        @.search.off('clear', @_onSearchClear)
        @.searchElement.html('')

    _onSearchUpdate: (text) =>
        @.trigger('searchUpdate', text)

    _onSearchClear: =>
        @.trigger('searchUpdate', '')

    _onClickBack: =>
        @.trigger('clickBack', '')

    _onCancelSearch: =>
        @.trigger('onCancelSearch', '')

