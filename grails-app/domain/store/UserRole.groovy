package store

import grails.gorm.annotation.Entity

@Entity
class UserRole implements Serializable {
    AppUser user
    Role role

    static constraints = {
        user nullable: false
        role nullable: false
    }

    static mapping = {
        id composite: ['user', 'role']
        version false  // Disable version column
    }


    boolean equals(other) {
        if (!(other instanceof UserRole)) {
            return false
        }
        return other.user?.id == user?.id && other.role?.id == role?.id
    }

    int hashCode() {
        def builder = new org.apache.commons.lang.builder.HashCodeBuilder()
        builder.append user?.id
        builder.append role?.id
        return builder.toHashCode()
    }
}
