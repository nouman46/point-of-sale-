// grails-app/conf/ThemeFilters.groovy
class ThemeFilters {
    def filters = {
        themeFilter(controller: '*', action: '*') {
            before = {
                controllerName != 'theme' // Exclude ThemeController
            }
            after = { model ->
                if (model) {
                    model.themeName = session.themeName ?: 'theme-default'
                }
            }
        }
    }
}