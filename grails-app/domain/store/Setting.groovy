package store

class Setting {
    String key
    String value
    String type
    String description
    String category
    AppUser createdBy  // NEW FIELD to track the creator


    static constraints = {
        key unique: true
        createdBy nullable: false  // Ensure creator is always recorded

    }

    static mapping = {
        key column: '[key]'
    }
}
