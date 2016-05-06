#= require ../core/baseCollection.coffee

class CollectionStatisticEmployee extends BaseCollection
    model: UserStatisticModel


    parseData: (arrayJson) =>
        arrayJson.forEach (element) =>
            model = new UserStatisticModel()
            model.parseData(element)
            @.add(model)
