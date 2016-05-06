class Register
    ###
    # получение данных из локалсторедж
    #
    # @param {String} name
    # @param opational defaultValue
    #
    # @return {Object} JSONObject
    ###
    getItem: (name, defaultValue=null) ->
        result = window.localStorage.getItem(name)
        if not result
            return defaultValue

        JSON.parse(result)

    ###
    # сохранение данных из локалсторедж
    #
    # @param {String} name
    # @param  value
    ###
    setItem: (name, value) ->
        value = JSON.stringify(value)
        window.localStorage.setItem(name, value)

    ###
    # удвление данных из локалсторедж
    #
    # @param {String} name
    ###
    removeItem: (name) ->
        window.localStorage.removeItem(name)
