define (require) ->
    Backbone = require 'backbone'

    MainRouter = require 'routers/main'

    Views =
        Header: require 'views/ui/header'

    initialize: ->
        mainRouter = new MainRouter()

        header = new Views.Header managed: false
        $('.wrapper').prepend header.$el

        Backbone.history.start pushState: true   

        $(document).on 'click', 'a:not([data-bypass])', (e) ->
            href = $(@).attr 'href'
            
            if href?
                e.preventDefault()

                Backbone.history.navigate href, trigger: true