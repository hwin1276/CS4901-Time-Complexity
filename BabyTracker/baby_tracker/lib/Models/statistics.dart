final String statTable = 'stats';

class StatFields {
    static final String userId = '_id';
    static final String username = 'username';
    static final String password = 'password';
    static final String email = 'email';
    static final String dependents = 'dependents';
}

class User {
    final int? userId;
    final String username;
    final String password;
    final String email;
    final List<String> dependents = List<String>(5); // dependents as string is temporary 
 
    const User({
        this.userId,
        required this.username,
        required this.password,
        required this.email,
        required this.dependents[0],
    });
}
