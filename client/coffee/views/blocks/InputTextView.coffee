#= extern Backbone.View

class InputTextView extends Backbone.View
    @.SIZE_LARGE = 'lg'
    @.SIZE_BIG = 'bg'
    @.SIZE_STANDARD = 'st'
    @.SIZE_SMALL = 'sm'
    @.SIZE_TINY = 'xs'

    @.TYPE_TEXT = 'text'
    @.TYPE_PASSWORD = 'password'
    @.TYPE_EMAIL = 'email'
    @.TYPE_NUMBER = 'number'

    template: JST['b-input']

    constructor: (placeholder, value, type=InputTextView.TYPE_TEXT,
                  size=InputTextView.SIZE_STANDARD,
                  style=null, maxlength=255, id = "") ->
        InputTextView.__super__.constructor.apply(@)

        @.placeholder= placeholder
        @.value = value
        @.type = type
        @.size = size
        @.style = style
        @.id = id
        @.maxlength = maxlength

    remove: ->
        if @.html
            @.html.off()
            @.html.remove()

        InputTextView.__super__.remove.apply(@)

    render: ->
        if @.type == InputTextView.TYPE_NUMBER
            @.type = 'tel'

        @.html = $(@.template(@))

        if @.type == InputTextView.TYPE_NUMBER
            @.html.find('.b-input').attr('pattern', '[0-9]*')

        @.html.on('keypress', @._onKeyPress)
        @.html.on('change keydown input', @._onKeyChange)
        @.html.on('input', @._onKeyUp)
        @.html

    getValue: ->
        @.html.val()

    clear: ->
        @.html.val('')

    setFocus: =>
        @.html.focus()

    _onKeyPress: (event) =>
        @.trigger('keypress', event)

    _onKeyChange: (event) =>
        @.trigger('change', event)

    _onKeyUp: (event) =>
        if @.type == 'tel'
            pattern = /^[0-9]*$/
            value = $(event.target).val()
            if(pattern.test(value))
                @.html.removeClass("error")
                @.trigger('input', event)
            else
                @.html.removeClass("error")
                @.html.addClass("error")
                @.trigger('inputError', event)
