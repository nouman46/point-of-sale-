package store

class Setting {
    String key
    String value
    String type
    String description
    String category

    static constraints = {
        key unique: true
    }

    static mapping = {
        key column: '[key]'
    }
}