final String userTable = 'users';

class UserFields {
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
    final List<String> dependents; // dependents as string is temporary 
 
    const User({
        this.userId,
        required this.username,
        required this.password,
        required this.email,
        required this.dependents,
    });

    User copy({
     int? userId,
     String? username,
     String? password,
     String? email,
     List<String>? dependents,
    }) =>
        User(
            userId: userId ?? this.userId,
            username: username ?? this.username,
            password: password ?? this.password,
            email: email ?? this.email,
            dependents: dependents ?? this.dependents,
        );

    Map<String, Object?> toJson() => {
        UserFields.userId: userId,
        UserFields.username: username,
        UserFields.password: password,
        UserFields.email: email,
        UserFields.dependents: dependents,
    };
}
