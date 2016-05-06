#= extern Backbone.View

class SearchView extends Backbone.View
    template: JST['b-search']
    input: null
    clear: null

    initialize: ->
       _.extend(@, Backbone.Events)

    remove: ->
        @.html.remove()
        SearchView.__super__.remove.apply(@)

    render: ->
        @.html = $ @template(@)

        @.html.find('.b-search-input').attr(
            'placeholder', getText('Поиск')
        )
        @.btnCancel = @.html.find('.b-search-cancel')
        @.btnCancel.html(getText('Отмена'))

        @input = @.html.find('.b-search-input__inactive')
        @input.on('click', @_onClick)
        @input.on('input', @_onKeyUp)

        @clear = @.html.find('.b-search-clear')
        @clear.on('click', @_onClickClear)
        @.btnCancel.on('click', @_onClickCancel)

        @.html

    _onKeyUp: =>
        if @input.val().length
            @clear.show()
        else
            @clear.hide()

        if @input.val().length
            @.trigger('update', @input.val())
        else if @input.val().length == 0
            @.trigger('clear', @)

    _onClickClear: =>
        @input.val('')
        @clear.hide()
        @.trigger('clear', @)

    _onClickCancel: =>
        @input.val('')
        @clear.hide()
        @.trigger('cancel', @)