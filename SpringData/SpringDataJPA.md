# Spring Data JPA

## Repostory

```java
@Repository
public interface AppUserRepostory extends JpaRepository<AppUser, Integer> {

}
```

## Example 使用

```java
public AppUser loadUserByUsername(String username) throws UsernameNotFoundException {
    AppUser user = new AppUser();
    user.setUsername(username);
    ExampleMatcher matcher = ExampleMatcher.matching().withIgnoreNullValues()
            .withMatcher("username", match -> match.contains() );
    Example<AppUser> example =Example.of(user,matcher);
    Optional<AppUser> optional = userRepostory.findOne(example);
      AppUser appUser = userRepostory.queryByUsername(username);
    if (!optional.isPresent()) {
        throw new UsernameNotFoundException("用户名不存在");
    }
    return optional.get();
}
```

