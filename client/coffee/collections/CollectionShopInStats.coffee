#= require ../core/baseCollection.coffee

class CollectionShopInStats extends BaseCollection
    model: ShopModel


    parseData: (arrayJson) =>
        arrayJson.forEach (element) =>
            model = new ShopModel()
            model.parseData(element)
            @.add(model)


    getModelById: (id) =>
        modelFind = null

        @.each (model) =>
           if (model.get('id') == id)
               modelFind = model
               return

        return modelFind
