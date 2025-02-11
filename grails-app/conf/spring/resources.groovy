import store.UserPasswordEncoderListener
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder

beans = {
    passwordEncoder(BCryptPasswordEncoder)  // Now Spring can find this class

    userPasswordEncoderListener(UserPasswordEncoderListener) {
        passwordEncoder = ref('passwordEncoder')
    }
}
