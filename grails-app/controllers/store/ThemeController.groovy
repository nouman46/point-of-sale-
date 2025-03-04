package store

class ThemeController {

    def selectTheme() {
        render(view: "selectTheme")
    }

    def switchTheme(String theme) {
        def validThemes = ['default', 'dark', 'blue-ocean', 'warm-sunset']
        if (theme in validThemes) {
            session.themeName = "theme-${theme}"
        } else {
            session.themeName = 'theme-default'
        }
        redirect(controller: "dashboard", action: "dashboard")
    }
}