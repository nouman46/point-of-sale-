package store

import groovy.transform.CompileStatic

@CompileStatic
class UserPasswordEncoderListener {

//    @Autowired
//    SpringSecurityService springSecurityService
//
//    @Listener(User)
//    void onPreInsertEvent(PreInsertEvent event) {
//        encodePasswordForEvent(event)
//    }
//
//    @Listener(User)
//    void onPreUpdateEvent(PreUpdateEvent event) {
//        encodePasswordForEvent(event)
//    }
//
//    private void encodePasswordForEvent(AbstractPersistenceEvent event) {
//        if (event.entityObject instanceof User) {
//            User u = event.entityObject as User
//            if (u.password && ((event instanceof  PreInsertEvent) || (event instanceof PreUpdateEvent && u.isDirty('password')))) {
//                event.getEntityAccess().setProperty('password', encodePassword(u.password))
//            }
//        }
//    }
//
//    private String encodePassword(String password) {
//        springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
//    }
}
