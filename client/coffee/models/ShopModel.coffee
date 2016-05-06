#= require ../core/baseModel.coffee

class ShopModel extends BaseModel
    id: null
    name: null

    constructor: (params) ->
        ShopModel.__super__.constructor.apply(@, [params])

    parseData: (data) ->
        @.set('id', parseInt(data['a:ShopId']))
        @.set('name', data['a:Name'])
