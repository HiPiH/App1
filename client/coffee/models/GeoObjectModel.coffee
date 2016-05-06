#= require ../core/baseModel.coffee

class GeoObjectModel extends BaseModel
    latitude: null
    longitude: null

    constructor: (params) ->
        GeoObjectModel.__super__.constructor.apply(@, [params])
