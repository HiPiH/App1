#= require ../core/baseModel.coffee

class UserModel extends BaseModel
    authKey: null
    employee: null
    dayStatus: null

    constructor: (params) ->
        UserModel.__super__.constructor.apply(@, [params])

    updateDayStatus: =>
        status = parseInt(@.get('dayStatus'))
        status++
        @.set('dayStatus', status)
