textTrimming = (jqElement, options=null) ->
    if not options
        options = {}

    if not options.offsetX
        options.offsetX = 0

    if not options.endString
        options.endString = '...'

    elementText = $.trim(jqElement.text())
    myParrentWidth = jqElement.parent().width()
    calcParentWidth = myParrentWidth - options.offsetX

    if jqElement.width() >= calcParentWidth and calcParentWidth > 0
        jqElement.hide()
        divideText = elementText

        while true
            divideText = $.trim(
                divideText.substr(0, parseInt(divideText.length / 2))
            )
            jqElement.html(divideText + options.endString)
            if (jqElement.width() < calcParentWidth)
                break

        start = divideText.length
        next = 0
        while true
            next++
            addText = elementText.substr(start, next)
            newText = divideText + addText + options.endString
            jqElement.html(newText)

            if jqElement.width() >= calcParentWidth or \
               start + next >= elementText.length

                addText = elementText.substr(start, next - 2)
                newText = divideText + addText + options.endString
                jqElement.html(newText)
                jqElement.show()
                break
