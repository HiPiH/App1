#= require ../core/baseCollection.coffee

class CollectionPlan extends BaseCollection
    model: ModelPlanEmployee

    parseData: (arrayJson) =>
        arrayJson.forEach (element) =>
            model = new ModelPlanEmployee()
            model.parseData(element)
            @.add(model)
