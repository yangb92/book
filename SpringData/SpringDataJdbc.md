# Spring Data Jdbc

Spring Data 核心存储库的对象是`Respository`, 它使用 domain以及ID的类型作为domain类的参数来管理.这个接口主要作为一个标记接口来捕获要使用的类型，并帮助您发现扩展这个接口的接口, CrudRepository为正在管理的实体类提供了复杂的CRUD功能

`CrudRepository`  接口:

```java
public interface CrudRepository<T, ID> extends Repository<T, ID> {

  <S extends T> S save(S entity);      

  Optional<T> findById(ID primaryKey); 

  Iterable<T> findAll();               

  long count();                        

  void delete(T entity);               

  boolean existsById(ID primaryKey);   

  // … more functionality omitted.
}
```

>我们还提供了特定于持久性技术的抽象，比如JpaRepository或MongoRepository。这些接口扩展了CrudRepository，并公开了底层持久性技术的功能，以及与持久性技术无关的通用接口(如CrudRepository)。

在CrudRepository的上面还有一个PagingAndSortingRepository抽象，它添加了额外的方法来简化对实体的分页访问:

`PagingAndSortingRepository` interface

```java
public interface PagingAndSortingRepository<T, ID> extends CrudRepository<T, ID> {

  Iterable<T> findAll(Sort sort);

  Page<T> findAll(Pageable pageable);
}
```

要按页面大小20访问用户的第二个页面，可以执行以下操作:

```java
PagingAndSortingRepository<User, Long> repository = // … get access to a bean
Page<User> users = repository.findAll(PageRequest.of(1, 20));
```

除了查询方法之外，还提供了count和delete查询的查询派生。下面的列表显示了派生count查询的接口定义:

Example 5. Derived Count Query

```java
interface UserRepository extends CrudRepository<User, Long> {

  long countByLastname(String lastname);
}
```

Example 6. Derived Delete Query

```java
interface UserRepository extends CrudRepository<User, Long> {

  long deleteByLastname(String lastname);

  List<User> removeByLastname(String lastname);
}
```

## 扩展Respository功能

例子:

```java
@NoRepositoryBean
interface MyBaseRepository<T, ID> extends Repository<T, ID> {

  Optional<T> findById(ID id);

  <S extends T> S save(S entity);
}

interface UserRepository extends MyBaseRepository<User, Long> {
  User findByEmailAddress(EmailAddress emailAddress);
}
```



## 多数据源持久层

略, 详见官方文档

## 定义查询方法

repository代理有两种方法从方法名派生特定于仓库的查询:

* 通过直接从方法名派生查询。
* 通过使用手动定义的查询。

### 查询策略

构建在Spring Data存储库基础设施中的查询生成器机制对于在存储库实体上构建约束查询非常有用。该机制剥离前缀find ... By，read ... By，query ... By，count ... By，and get ...来自该方法并开始解析其余部分,引入子句可以包含进一步的表达式，比如使用Distinct在要创建的查询上设置不同的标志,但是，第一个By用作分隔符以指示实际条件的开始。您可以在实体属性上定义条件，并用and和Or连接它们.

以下示例显示了如何创建大量查询

```java
interface PersonRepository extends Repository<User, Long> {

  List<Person> findByEmailAddressAndLastname(EmailAddress emailAddress, String lastname);

  // Enables the distinct flag for the query
  List<Person> findDistinctPeopleByLastnameOrFirstname(String lastname, String firstname);
  List<Person> findPeopleDistinctByLastnameOrFirstname(String lastname, String firstname);

  // Enabling ignoring case for an individual property
  List<Person> findByLastnameIgnoreCase(String lastname);
  // Enabling ignoring case for all suitable properties
  List<Person> findByLastnameAndFirstnameAllIgnoreCase(String lastname, String firstname);

  // Enabling static ORDER BY for a query
  List<Person> findByLastnameOrderByFirstnameAsc(String lastname);
  List<Person> findByLastnameOrderByFirstnameDesc(String lastname);
}
```

但是，有一些一般要注意的事项：

* 表达式通常是属性遍历与可连接的操作符组合而成。可以使用AND和OR组合属性表达式,您还可以获得对属性表达式的Between、LessThan、GreaterThan和Like等操作符的支持,受支持的操作符可能因数据存储而异，因此请参考参考文档的适当部分
* 方法解析器支持为单个属性设置IgnoreCase标志,例如`findByLastnameIgnoreCase(…)`忽略大小写的类型的所有属性(通常是字符串实例，例如 findByLastnameAndFirstnameAllIgnoreCase(…))是否支持忽略案例可能因存储而异
* 您可以通过将OrderBy子句附加到引用属性的查询方法并提供排序方向(Asc或Desc)来应用静态排序。

## 属性表达式

属性表达式只能引用托管实体的直接属性，如上例所示。在查询创建时，您已经确保已解析的属性是托管域类的属性。不过，您也可以通过遍历嵌套属性来定义约束。考虑下面的方法:

```java
List<Person> findByAddressZipCode(ZipCode zipCode);
```

假设一个人有一个带邮政编码的地址,该方法创建属性遍历x.address.zipCode。解析算法首先将整个部分(AddressZipCode)解释为属性，然后检查域类是否包含该名称的属性(未大写)。如果算法成功，它将使用该属性,它使用这个属性。如果没有，该算法将驼峰情况部分的源从右侧分割为头和尾，并尝试在我们的示例中找到相应的属性,如果没有，该算法将驼峰情况部分的源代码从右侧分割为头部和尾部，并尝试在我们的示例中找到相应的属性AddressZip和Code,它需要尾巴并继续从那里建造分支，按照刚刚描述的方式将尾巴分开。 如果第一个分割不匹配，算法会将分割点移动到左侧（Address，ZipCode）并继续。

虽然这应该适用于大多数情况，但是算法可能选择了错误的属性。假设Person类也有一个addressZip属性。该算法将在第一轮分割中匹配，选择错误的属性，并失败(因为addressZip类型可能没有code属性)。

要解决这种模糊性，可以在方法名称中使用手动定义遍历点。我们的方法名如下

```java
List<Person> findByAddress_ZipCode(ZipCode zipCode);
```

## 特殊参数处理

分页和排序 需要传入特殊的参数: `Pageable` and `Sort`, 如下所示:

```java
Page<User> findByLastname(String lastname, Pageable pageable);

Slice<User> findByLastname(String lastname, Pageable pageable);

List<User> findByLastname(String lastname, Sort sort);

List<User> findByLastname(String lastname, Pageable pageable);
```

第一个方法允许您传递org.springframework.data.domain。查询方法的可分页实例，以便动态地将分页添加到静态定义的查询中。一个页面知道可用元素和页面的总数。它通过基础设施触发count查询来计算总数。由于这可能很昂贵(取决于所使用的商店)，您可以返回一个切片。一个切片只知道下一个切片是否可用，这在遍历较大的结果集时可能就足够了。

排序选项也通过Pageable实例处理。 如果只需要排序，请在方法中添加org.springframework.data.domain.Sort参数。 如您所见，也可以返回List。 在这种情况下，不会创建构建实际页面实例所需的其他元数据（反过来，这意味着不会发出必要的附加计数查询）。 相反，它限制查询仅查找给定范围的实体。

## 分段查询结构

查询方法的结果可以通过使用first或top关键字来限制,可以互换使用。可以将可选数值追加到top或first，以指定要返回的最大结果大小。如果省略该数字，则假设结果大小为1。下面的示例显示如何限制查询大小

```java
User findFirstByOrderByLastnameAsc();

User findTopByOrderByAgeDesc();

Page<User> queryFirst10ByLastname(String lastname, Pageable pageable);

Slice<User> findTop3ByLastname(String lastname, Pageable pageable);

List<User> findFirst10ByLastname(String lastname, Sort sort);

List<User> findTop10ByLastname(String lastname, Pageable pageable);
```

限制表达式也支持Distinct关键字。 此外，对于将结果集限制为一个实例的查询，支持使用Optional关键字将结果包装

## 返回集合或迭代的存储库方法

略

## 空值处理

从Spring Data 2.0开始，返回单个聚合实例的repository CRUD方法使用Java 8 s可选方法来表示可能没有值。除此之外，Spring Data支持在查询方法上返回以下包装器类型

- `com.google.common.base.Optional`
- `scala.Option`
- `io.vavr.control.Option`

也可以通过null值判断返回结果,返回集合、集合替代方案、包装器和流的存储库方法保证永远不会返回null，而是相应的空表示。有关详细信息，请参阅存储库查询返回类型

### 空值注释

