---
description: 'Best practices for automated testing in C# using xUnit, Moq, and Microsoft.NET.Test.Sdk'
applyTo: '**/tests/unit/**/*.cs, **/tests/integration/**/*.cs'
---

# C# Testing Instructions

> Guidelines and best practices for writing maintainable, reliable, and effective automated tests in C# projects.

**Last Updated**: 2025-12-10  
**Applies To**: All C# test files in `tests/unit/` and `tests/integration/` folders

---

## Overview

This instruction file defines testing standards for C# projects using xUnit as the test framework, Moq for mocking, and Microsoft.NET.Test.Sdk as the test infrastructure. These guidelines ensure consistent, readable, and maintainable test code across the codebase.

**Testing Stack**:
- `Microsoft.NET.Test.Sdk` - Test infrastructure and execution
- `xUnit` - Test framework
- `xunit.runner.visualstudio` - Visual Studio and IDE test discovery
- `Moq` - Mocking framework

---

## Project Organization

### Test Project Structure

Separate unit tests and integration tests into distinct projects. This separation enables:
- Different execution times and frequencies (unit tests run on every build, integration tests on CI)
- Different dependencies (integration tests may need database, HTTP clients, etc.)
- Clearer test categorization and reporting

```
solution/
├── src/
│   ├── MyProject/
│   │   ├── MyProject.csproj
│   │   └── Services/
│   │       └── OrderService.cs
│   ├── MyProject.Core/
│   │   └── MyProject.Core.csproj
│   └── MyProject.Infrastructure/
│       └── MyProject.Infrastructure.csproj
├── tests/
│   ├── unit/
│   │   ├── MyProject.Tests.Unit/
│   │   │   ├── MyProject.Tests.Unit.csproj
│   │   │   └── Services/
│   │   │       └── OrderServiceTests.cs
│   │   ├── MyProject.Core.Tests.Unit/
│   │   │   └── MyProject.Core.Tests.Unit.csproj
│   │   └── MyProject.Infrastructure.Tests.Unit/
│   │       └── MyProject.Infrastructure.Tests.Unit.csproj
│   └── integration/
│       ├── MyProject.Tests.Integration/
│       │   ├── MyProject.Tests.Integration.csproj
│       │   └── Api/
│       │       └── OrdersEndpointTests.cs
│       └── MyProject.Infrastructure.Tests.Integration/
│           └── MyProject.Infrastructure.Tests.Integration.csproj
└── MySolution.sln
```

### Project Naming Convention

Follow these naming patterns for test projects:

| Source Project | Unit Test Project | Integration Test Project |
|:---------------|:------------------|:-------------------------|
| `MyProject` | `tests/unit/MyProject.Tests.Unit` | `tests/integration/MyProject.Tests.Integration` |
| `MyProject.Core` | `tests/unit/MyProject.Core.Tests.Unit` | `tests/integration/MyProject.Core.Tests.Integration` |
| `MyProject.Api` | `tests/unit/MyProject.Api.Tests.Unit` | `tests/integration/MyProject.Api.Tests.Integration` |

### Automatic Unit Test Project Creation

When creating a new source project, automatically create the corresponding unit test project in the `tests/unit/` folder. Integration test projects are created manually in the `tests/integration/` folder as needed.

```bash
# When creating a new project
dotnet new classlib -n MyProject.Core -o src/MyProject.Core

# Automatically create the unit test project in tests/unit/
dotnet new xunit -n MyProject.Core.Tests.Unit -o tests/unit/MyProject.Core.Tests.Unit
dotnet add tests/unit/MyProject.Core.Tests.Unit reference src/MyProject.Core
dotnet add tests/unit/MyProject.Core.Tests.Unit package Moq
dotnet sln add tests/unit/MyProject.Core.Tests.Unit

# Integration test projects are created manually as needed in tests/integration/
dotnet new xunit -n MyProject.Core.Tests.Integration -o tests/integration/MyProject.Core.Tests.Integration
dotnet add tests/integration/MyProject.Core.Tests.Integration reference src/MyProject.Core
dotnet add tests/integration/MyProject.Core.Tests.Integration package Moq
dotnet add tests/integration/MyProject.Core.Tests.Integration package Microsoft.AspNetCore.Mvc.Testing
dotnet sln add tests/integration/MyProject.Core.Tests.Integration
```

### Test Project File Template

Use this template for new unit test projects in `tests/unit/`:

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <IsPackable>false</IsPackable>
    <IsTestProject>true</IsTestProject>
  </PropertyGroup>

  <ItemGroup>
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.*" />
    <PackageReference Include="Moq" Version="4.*" />
    <PackageReference Include="xunit" Version="2.*" />
    <PackageReference Include="xunit.runner.visualstudio" Version="2.*">
      <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
      <PrivateAssets>all</PrivateAssets>
    </PackageReference>
    <PackageReference Include="coverlet.collector" Version="6.*">
      <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
      <PrivateAssets>all</PrivateAssets>
    </PackageReference>
  </ItemGroup>

  <ItemGroup>
    <!-- Note: Path goes up three levels from tests/unit/MyProject.Tests.Unit/ to reach src/ -->
    <ProjectReference Include="..\..\..\src\MyProject\MyProject.csproj" />
  </ItemGroup>

</Project>
```

### Integration Test Project Additions

Integration test projects in `tests/integration/` should include additional packages as needed:

```xml
<Project Sdk="Microsoft.NET.Sdk">

  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <ImplicitUsings>enable</ImplicitUsings>
    <Nullable>enable</Nullable>
    <IsPackable>false</IsPackable>
    <IsTestProject>true</IsTestProject>
  </PropertyGroup>

  <ItemGroup>
    <!-- Base testing packages (same as unit tests) -->
    <PackageReference Include="Microsoft.NET.Test.Sdk" Version="17.*" />
    <PackageReference Include="Moq" Version="4.*" />
    <PackageReference Include="xunit" Version="2.*" />
    <PackageReference Include="xunit.runner.visualstudio" Version="2.*">
      <IncludeAssets>runtime; build; native; contentfiles; analyzers; buildtransitive</IncludeAssets>
      <PrivateAssets>all</PrivateAssets>
    </PackageReference>
    
    <!-- Integration testing packages -->
    <PackageReference Include="Microsoft.AspNetCore.Mvc.Testing" Version="8.*" />
    <PackageReference Include="Testcontainers" Version="3.*" />
    <PackageReference Include="Respawn" Version="6.*" />
  </ItemGroup>

  <ItemGroup>
    <!-- Note: Path goes up three levels from tests/integration/MyProject.Tests.Integration/ to reach src/ -->
    <ProjectReference Include="..\..\..\src\MyProject\MyProject.csproj" />
  </ItemGroup>

</Project>
```

---

## File Organization

### Mirror Source Project Structure

Test files should mirror the folder structure of the source project they test.

```
src/MyProject/
├── Services/
│   ├── OrderService.cs
│   └── CustomerService.cs
├── Repositories/
│   └── OrderRepository.cs
└── Validators/
    └── OrderValidator.cs

tests/unit/MyProject.Tests.Unit/
├── Services/
│   ├── OrderServiceTests.cs
│   └── CustomerServiceTests.cs
├── Repositories/
│   └── OrderRepositoryTests.cs
└── Validators/
    └── OrderValidatorTests.cs

tests/integration/MyProject.Tests.Integration/
├── Api/
│   └── OrdersEndpointTests.cs
└── Repositories/
    └── OrderRepositoryIntegrationTests.cs
```

### Test File Naming

Name test files by appending `Tests` to the class being tested:

| Source File | Test File |
|:------------|:----------|
| `OrderService.cs` | `OrderServiceTests.cs` |
| `CustomerRepository.cs` | `CustomerRepositoryTests.cs` |
| `OrderValidator.cs` | `OrderValidatorTests.cs` |

### One Test Class per Source Class

Each source class should have exactly one corresponding test class. If a test class becomes too large, consider whether the source class has too many responsibilities.

```csharp
// ✅ Correct - One test class for OrderService
// File: tests/MyProject.Tests.Unit/Services/OrderServiceTests.cs
public class OrderServiceTests
{
    // All tests for OrderService
}

// ❌ Incorrect - Multiple test classes for the same source class
// File: tests/MyProject.Tests.Unit/Services/OrderServiceCreateTests.cs
// File: tests/MyProject.Tests.Unit/Services/OrderServiceUpdateTests.cs
```

### Shared Test Utilities

Place shared test utilities, fixtures, and helpers in dedicated folders within each test project:

```
tests/unit/MyProject.Tests.Unit/
├── _Builders/
│   ├── OrderBuilder.cs
│   └── CustomerBuilder.cs
├── _Helpers/
│   └── AssertionExtensions.cs
└── Services/
    └── OrderServiceTests.cs

tests/integration/MyProject.Tests.Integration/
├── _Fixtures/
│   ├── DatabaseFixture.cs
│   └── TestWebApplicationFactory.cs
├── _Builders/
│   ├── OrderBuilder.cs
│   └── CustomerBuilder.cs
├── _Helpers/
│   └── HttpClientExtensions.cs
└── Api/
    └── OrdersEndpointTests.cs
```

**Note**: The underscore prefix (`_Fixtures`, `_Builders`) ensures these folders sort to the top in file explorers.

For utilities shared across both unit and integration tests, consider creating a shared test utilities project:

```
tests/
├── shared/
│   └── MyProject.Tests.Shared/
│       ├── MyProject.Tests.Shared.csproj
│       ├── Builders/
│       │   ├── OrderBuilder.cs
│       │   └── CustomerBuilder.cs
│       └── Extensions/
│           └── AssertionExtensions.cs
├── unit/
│   └── MyProject.Tests.Unit/
└── integration/
    └── MyProject.Tests.Integration/
```

---

## Test Method Naming

### Use the MethodName_Condition_ExpectedResult Pattern

All test methods must follow the naming pattern: `MethodName_Condition_ExpectedResult()`

**Rationale**: This pattern makes test intent immediately clear and helps identify failures quickly in test reports.

```csharp
// ✅ Correct - Clear, descriptive names
[Fact]
public void ProcessOrder_WithValidOrder_ReturnsSuccessResult()

[Fact]
public void ProcessOrder_WithNullOrder_ThrowsArgumentNullException()

[Fact]
public void ProcessOrder_WhenInventoryInsufficient_ReturnsFailureResult()

[Fact]
public async Task GetOrderAsync_WithExistingId_ReturnsOrder()

[Fact]
public async Task GetOrderAsync_WithNonExistentId_ReturnsNull()

// ❌ Incorrect - Vague or non-descriptive names
[Fact]
public void TestProcessOrder()

[Fact]
public void ProcessOrderTest()

[Fact]
public void Test1()

[Fact]
public void ItShouldWork()
```

### Naming Components Explained

| Component | Description | Examples |
|:----------|:------------|:---------|
| **MethodName** | The method being tested | `ProcessOrder`, `GetOrderAsync`, `Validate` |
| **Condition** | The scenario or input state | `WithValidOrder`, `WhenInventoryInsufficient`, `WithNullInput` |
| **ExpectedResult** | What should happen | `ReturnsSuccessResult`, `ThrowsArgumentNullException`, `ReturnsNull` |

### Common Condition Prefixes

Use consistent prefixes for conditions:

- `With...` - Describes input parameters: `WithValidOrder`, `WithEmptyList`, `WithNullCustomer`
- `When...` - Describes system state: `WhenInventoryInsufficient`, `WhenUserNotAuthenticated`
- `Given...` - Alternative to When for BDD style: `GivenExpiredToken`, `GivenExistingOrder`
- `For...` - Describes the subject: `ForNewCustomer`, `ForPremiumUser`

### Common Result Suffixes

Use consistent suffixes for expected results:

- `Returns...` - For methods that return values: `ReturnsOrder`, `ReturnsNull`, `ReturnsEmptyList`
- `Throws...` - For exception testing: `ThrowsArgumentNullException`, `ThrowsInvalidOperationException`
- `Creates...` - For creation operations: `CreatesNewOrder`, `CreatesAuditLog`
- `Updates...` - For update operations: `UpdatesOrderStatus`, `UpdatesCustomerEmail`
- `Deletes...` - For deletion operations: `DeletesOrder`, `RemovesFromCache`
- `DoesNotThrow` - For negative exception tests: `DoesNotThrowException`
- `IsTrue/IsFalse` - For boolean results: `IsTrue`, `IsFalse`

---

## Test Structure

### Use the Arrange-Act-Assert Pattern

Structure all tests using the AAA pattern with clear section comments:

```csharp
[Fact]
public async Task ProcessOrder_WithValidOrder_ReturnsSuccessResult()
{
    // Arrange
    var order = new OrderBuilder()
        .WithCustomerId(1)
        .WithItems(new OrderItem("SKU-001", 2))
        .Build();
    
    var mockRepository = new Mock<IOrderRepository>();
    mockRepository
        .Setup(r => r.SaveAsync(It.IsAny<Order>(), It.IsAny<CancellationToken>()))
        .ReturnsAsync(true);
    
    var sut = new OrderService(mockRepository.Object);
    
    // Act
    var result = await sut.ProcessOrderAsync(order);
    
    // Assert
    Assert.True(result.IsSuccess);
    Assert.NotNull(result.OrderId);
    mockRepository.Verify(r => r.SaveAsync(order, It.IsAny<CancellationToken>()), Times.Once);
}
```

### Name the System Under Test "sut"

Use `sut` (system under test) as the variable name for the class being tested:

```csharp
// ✅ Correct
var sut = new OrderService(mockRepository.Object, mockLogger.Object);
var result = await sut.ProcessOrderAsync(order);

// ❌ Incorrect - unclear what's being tested
var service = new OrderService(mockRepository.Object, mockLogger.Object);
var orderService = new OrderService(mockRepository.Object, mockLogger.Object);
var target = new OrderService(mockRepository.Object, mockLogger.Object);
```

### Keep Tests Focused and Small

Each test should verify one behavior. If you need multiple asserts, ensure they all verify aspects of the same behavior.

```csharp
// ✅ Correct - Single behavior with related assertions
[Fact]
public void CreateOrder_WithValidData_ReturnsOrderWithCorrectProperties()
{
    // Arrange
    var customerId = 42;
    var items = new[] { new OrderItem("SKU-001", 2) };
    
    // Act
    var order = Order.Create(customerId, items);
    
    // Assert
    Assert.Equal(customerId, order.CustomerId);
    Assert.Equal(OrderStatus.Pending, order.Status);
    Assert.Single(order.Items);
    Assert.NotEqual(default, order.CreatedAt);
}

// ❌ Incorrect - Testing multiple behaviors
[Fact]
public void OrderServiceTests()
{
    var service = new OrderService();
    
    // Testing creation
    var order = service.Create(...);
    Assert.NotNull(order);
    
    // Testing update - this should be a separate test
    service.Update(order);
    Assert.Equal(OrderStatus.Updated, order.Status);
    
    // Testing deletion - this should be a separate test
    service.Delete(order);
}
```

---

## Test Class Organization

### Use Nested Classes to Group Related Tests

For classes with many methods, use nested classes to group tests by method:

```csharp
public class OrderServiceTests
{
    public class ProcessOrderAsync
    {
        [Fact]
        public async Task WithValidOrder_ReturnsSuccessResult()
        {
            // ...
        }
        
        [Fact]
        public async Task WithNullOrder_ThrowsArgumentNullException()
        {
            // ...
        }
        
        [Fact]
        public async Task WhenInventoryInsufficient_ReturnsFailureResult()
        {
            // ...
        }
    }
    
    public class GetOrderAsync
    {
        [Fact]
        public async Task WithExistingId_ReturnsOrder()
        {
            // ...
        }
        
        [Fact]
        public async Task WithNonExistentId_ReturnsNull()
        {
            // ...
        }
    }
    
    public class CancelOrderAsync
    {
        [Fact]
        public async Task WithPendingOrder_SetsStatusToCancelled()
        {
            // ...
        }
    }
}
```

### Share Setup with Constructor or Fixtures

Use the constructor for common setup that applies to all tests in a class:

```csharp
public class OrderServiceTests : IDisposable
{
    private readonly Mock<IOrderRepository> _mockRepository;
    private readonly Mock<ILogger<OrderService>> _mockLogger;
    private readonly OrderService _sut;
    
    public OrderServiceTests()
    {
        _mockRepository = new Mock<IOrderRepository>();
        _mockLogger = new Mock<ILogger<OrderService>>();
        _sut = new OrderService(_mockRepository.Object, _mockLogger.Object);
    }
    
    public void Dispose()
    {
        // Cleanup if needed
    }
    
    [Fact]
    public async Task ProcessOrder_WithValidOrder_ReturnsSuccessResult()
    {
        // Arrange
        var order = new OrderBuilder().Build();
        _mockRepository
            .Setup(r => r.SaveAsync(It.IsAny<Order>(), It.IsAny<CancellationToken>()))
            .ReturnsAsync(true);
        
        // Act
        var result = await _sut.ProcessOrderAsync(order);
        
        // Assert
        Assert.True(result.IsSuccess);
    }
}
```

### Use Class Fixtures for Expensive Setup

For expensive setup that should be shared across all tests in a class (like database connections), use `IClassFixture<T>`:

```csharp
public class DatabaseFixture : IAsyncLifetime
{
    public string ConnectionString { get; private set; } = default!;
    
    public async Task InitializeAsync()
    {
        // Start test database container
        ConnectionString = await StartTestDatabaseAsync();
    }
    
    public async Task DisposeAsync()
    {
        // Cleanup
        await StopTestDatabaseAsync();
    }
}

public class OrderRepositoryTests : IClassFixture<DatabaseFixture>
{
    private readonly DatabaseFixture _fixture;
    
    public OrderRepositoryTests(DatabaseFixture fixture)
    {
        _fixture = fixture;
    }
    
    [Fact]
    public async Task SaveAsync_WithNewOrder_PersistsToDatabase()
    {
        // Use _fixture.ConnectionString
    }
}
```

### Use Collection Fixtures for Cross-Class Sharing

For setup shared across multiple test classes, use collection fixtures:

```csharp
[CollectionDefinition("Database")]
public class DatabaseCollection : ICollectionFixture<DatabaseFixture>
{
    // This class has no code, it's just a marker
}

[Collection("Database")]
public class OrderRepositoryTests
{
    private readonly DatabaseFixture _fixture;
    
    public OrderRepositoryTests(DatabaseFixture fixture)
    {
        _fixture = fixture;
    }
}

[Collection("Database")]
public class CustomerRepositoryTests
{
    private readonly DatabaseFixture _fixture;
    
    public CustomerRepositoryTests(DatabaseFixture fixture)
    {
        _fixture = fixture;
    }
}
```

---

## Mocking with Moq

### Setup Mocks in Arrange Section

Configure mock behavior in the Arrange section, close to where it's relevant:

```csharp
[Fact]
public async Task ProcessOrder_WithValidOrder_SavesOrderToRepository()
{
    // Arrange
    var order = new OrderBuilder().Build();
    var mockRepository = new Mock<IOrderRepository>();
    
    mockRepository
        .Setup(r => r.SaveAsync(It.IsAny<Order>(), It.IsAny<CancellationToken>()))
        .ReturnsAsync(true);
    
    var sut = new OrderService(mockRepository.Object);
    
    // Act
    await sut.ProcessOrderAsync(order);
    
    // Assert
    mockRepository.Verify(
        r => r.SaveAsync(order, It.IsAny<CancellationToken>()),
        Times.Once);
}
```

### Use Strict Mocks Sparingly

Default to loose mocks. Use strict mocks only when you need to verify no unexpected calls are made:

```csharp
// ✅ Correct - Loose mock (default), only setup what you need
var mockRepository = new Mock<IOrderRepository>();
mockRepository
    .Setup(r => r.GetByIdAsync(It.IsAny<int>(), It.IsAny<CancellationToken>()))
    .ReturnsAsync(new Order());

// Use strict mocks only when necessary
var strictMock = new Mock<IOrderRepository>(MockBehavior.Strict);
strictMock
    .Setup(r => r.GetByIdAsync(1, It.IsAny<CancellationToken>()))
    .ReturnsAsync(new Order());
// Strict mock will throw if any other method is called
```

### Verify Interactions When Behavior Matters

Use `Verify` to confirm important interactions occurred:

```csharp
[Fact]
public async Task ProcessOrder_WithValidOrder_SendsConfirmationEmail()
{
    // Arrange
    var order = new OrderBuilder().WithCustomerEmail("test@example.com").Build();
    var mockEmailService = new Mock<IEmailService>();
    var sut = new OrderService(mockRepository.Object, mockEmailService.Object);
    
    // Act
    await sut.ProcessOrderAsync(order);
    
    // Assert
    mockEmailService.Verify(
        e => e.SendOrderConfirmationAsync(
            order.CustomerEmail,
            It.Is<OrderConfirmation>(c => c.OrderId == order.Id)),
        Times.Once);
}
```

### Use It.Is<T> for Specific Argument Matching

When you need to verify specific argument values:

```csharp
// Verify with specific argument matching
mockRepository.Verify(
    r => r.SaveAsync(
        It.Is<Order>(o => 
            o.CustomerId == 42 && 
            o.Status == OrderStatus.Pending),
        It.IsAny<CancellationToken>()),
    Times.Once);

// Verify any argument of type
mockRepository.Verify(
    r => r.SaveAsync(It.IsAny<Order>(), It.IsAny<CancellationToken>()),
    Times.Once);

// Verify specific value
mockRepository.Verify(
    r => r.GetByIdAsync(42, It.IsAny<CancellationToken>()),
    Times.Once);
```

### Setup Sequences for Multiple Calls

When a method is called multiple times with different results:

```csharp
[Fact]
public async Task RetryPolicy_WhenFirstCallFails_RetriesAndSucceeds()
{
    // Arrange
    var mockService = new Mock<IExternalService>();
    mockService
        .SetupSequence(s => s.CallAsync())
        .ThrowsAsync(new HttpRequestException())  // First call fails
        .ReturnsAsync(new Response { Success = true });  // Second call succeeds
    
    var sut = new ResilientService(mockService.Object);
    
    // Act
    var result = await sut.ExecuteWithRetryAsync();
    
    // Assert
    Assert.True(result.Success);
    mockService.Verify(s => s.CallAsync(), Times.Exactly(2));
}
```

---

## Test Data Builders

### Use the Builder Pattern for Test Data

Create builder classes to construct test objects with sensible defaults:

```csharp
// File: tests/unit/MyProject.Tests.Unit/_Builders/OrderBuilder.cs
public class OrderBuilder
{
    private int _customerId = 1;
    private string _customerEmail = "customer@example.com";
    private List<OrderItem> _items = new() { new OrderItem("SKU-001", 1, 10.00m) };
    private OrderStatus _status = OrderStatus.Pending;
    private DateTime _createdAt = DateTime.UtcNow;
    
    public OrderBuilder WithCustomerId(int customerId)
    {
        _customerId = customerId;
        return this;
    }
    
    public OrderBuilder WithCustomerEmail(string email)
    {
        _customerEmail = email;
        return this;
    }
    
    public OrderBuilder WithItems(params OrderItem[] items)
    {
        _items = items.ToList();
        return this;
    }
    
    public OrderBuilder WithNoItems()
    {
        _items = new List<OrderItem>();
        return this;
    }
    
    public OrderBuilder WithStatus(OrderStatus status)
    {
        _status = status;
        return this;
    }
    
    public OrderBuilder AsShipped()
    {
        _status = OrderStatus.Shipped;
        return this;
    }
    
    public OrderBuilder AsCancelled()
    {
        _status = OrderStatus.Cancelled;
        return this;
    }
    
    public Order Build()
    {
        return new Order
        {
            Id = Guid.NewGuid(),
            CustomerId = _customerId,
            CustomerEmail = _customerEmail,
            Items = _items,
            Status = _status,
            CreatedAt = _createdAt
        };
    }
}
```

### Usage Examples

```csharp
// Default order with sensible values
var order = new OrderBuilder().Build();

// Customized order
var premiumOrder = new OrderBuilder()
    .WithCustomerId(42)
    .WithItems(
        new OrderItem("SKU-001", 2, 99.99m),
        new OrderItem("SKU-002", 1, 149.99m))
    .Build();

// Order in specific state
var shippedOrder = new OrderBuilder()
    .AsShipped()
    .Build();

// Edge case - empty order
var emptyOrder = new OrderBuilder()
    .WithNoItems()
    .Build();
```

---

## Theory Tests for Data-Driven Testing

### Use [Theory] for Parameterized Tests

When testing the same behavior with different inputs:

```csharp
public class EmailValidatorTests
{
    [Theory]
    [InlineData("user@example.com", true)]
    [InlineData("user.name@example.com", true)]
    [InlineData("user@subdomain.example.com", true)]
    [InlineData("", false)]
    [InlineData("invalid", false)]
    [InlineData("@example.com", false)]
    [InlineData("user@", false)]
    public void IsValid_WithVariousInputs_ReturnsExpectedResult(string email, bool expected)
    {
        // Arrange
        var sut = new EmailValidator();
        
        // Act
        var result = sut.IsValid(email);
        
        // Assert
        Assert.Equal(expected, result);
    }
}
```

### Use [MemberData] for Complex Test Data

For complex objects or large data sets:

```csharp
public class OrderValidatorTests
{
    public static IEnumerable<object[]> InvalidOrderTestData =>
        new List<object[]>
        {
            new object[] { new OrderBuilder().WithNoItems().Build(), "Order must have items" },
            new object[] { new OrderBuilder().WithCustomerId(0).Build(), "Invalid customer" },
            new object[] { new OrderBuilder().WithItems(new OrderItem("", 1, 10m)).Build(), "Invalid SKU" },
        };
    
    [Theory]
    [MemberData(nameof(InvalidOrderTestData))]
    public void Validate_WithInvalidOrder_ReturnsExpectedError(Order order, string expectedError)
    {
        // Arrange
        var sut = new OrderValidator();
        
        // Act
        var result = sut.Validate(order);
        
        // Assert
        Assert.False(result.IsValid);
        Assert.Contains(expectedError, result.Errors.Select(e => e.Message));
    }
}
```

### Use [ClassData] for Reusable Test Data

For test data shared across multiple test classes:

```csharp
// File: tests/unit/MyProject.Tests.Unit/_TestData/InvalidEmailTestData.cs
public class InvalidEmailTestData : IEnumerable<object[]>
{
    public IEnumerator<object[]> GetEnumerator()
    {
        yield return new object[] { "" };
        yield return new object[] { "   " };
        yield return new object[] { "invalid" };
        yield return new object[] { "@example.com" };
        yield return new object[] { "user@" };
        yield return new object[] { "user@.com" };
    }
    
    IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
}

// Usage
[Theory]
[ClassData(typeof(InvalidEmailTestData))]
public void Validate_WithInvalidEmail_ReturnsFalse(string email)
{
    // ...
}
```

---

## Integration Testing

### Use WebApplicationFactory for API Testing

```csharp
// File: tests/integration/MyProject.Api.Tests.Integration/_Fixtures/TestWebApplicationFactory.cs
public class TestWebApplicationFactory : WebApplicationFactory<Program>
{
    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.ConfigureServices(services =>
        {
            // Remove the real database context
            var descriptor = services.SingleOrDefault(
                d => d.ServiceType == typeof(DbContextOptions<AppDbContext>));
            if (descriptor != null)
                services.Remove(descriptor);
            
            // Add test database
            services.AddDbContext<AppDbContext>(options =>
            {
                options.UseInMemoryDatabase("TestDb");
            });
            
            // Replace external services with fakes
            services.AddSingleton<IEmailService, FakeEmailService>();
        });
    }
}
```

### Integration Test Example

```csharp
// File: tests/integration/MyProject.Api.Tests.Integration/Api/OrdersEndpointTests.cs
public class OrdersEndpointTests : IClassFixture<TestWebApplicationFactory>
{
    private readonly HttpClient _client;
    private readonly TestWebApplicationFactory _factory;
    
    public OrdersEndpointTests(TestWebApplicationFactory factory)
    {
        _factory = factory;
        _client = factory.CreateClient();
    }
    
    [Fact]
    public async Task GetOrder_WithExistingId_ReturnsOkWithOrder()
    {
        // Arrange
        var orderId = await SeedTestOrderAsync();
        
        // Act
        var response = await _client.GetAsync($"/api/orders/{orderId}");
        
        // Assert
        response.EnsureSuccessStatusCode();
        var order = await response.Content.ReadFromJsonAsync<OrderDto>();
        Assert.NotNull(order);
        Assert.Equal(orderId, order.Id);
    }
    
    [Fact]
    public async Task GetOrder_WithNonExistentId_ReturnsNotFound()
    {
        // Act
        var response = await _client.GetAsync("/api/orders/99999");
        
        // Assert
        Assert.Equal(HttpStatusCode.NotFound, response.StatusCode);
    }
    
    [Fact]
    public async Task CreateOrder_WithValidData_ReturnsCreatedWithLocation()
    {
        // Arrange
        var request = new CreateOrderRequest
        {
            CustomerId = 1,
            Items = new[] { new OrderItemDto("SKU-001", 2) }
        };
        
        // Act
        var response = await _client.PostAsJsonAsync("/api/orders", request);
        
        // Assert
        Assert.Equal(HttpStatusCode.Created, response.StatusCode);
        Assert.NotNull(response.Headers.Location);
        
        var order = await response.Content.ReadFromJsonAsync<OrderDto>();
        Assert.NotNull(order);
        Assert.Equal(OrderStatus.Pending, order.Status);
    }
    
    private async Task<int> SeedTestOrderAsync()
    {
        using var scope = _factory.Services.CreateScope();
        var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
        
        var order = new Order { CustomerId = 1, Status = OrderStatus.Pending };
        dbContext.Orders.Add(order);
        await dbContext.SaveChangesAsync();
        
        return order.Id;
    }
}
```

---

## Exception Testing

### Use Assert.Throws for Synchronous Methods

```csharp
[Fact]
public void ProcessOrder_WithNullOrder_ThrowsArgumentNullException()
{
    // Arrange
    var sut = new OrderService(Mock.Of<IOrderRepository>());
    
    // Act & Assert
    var exception = Assert.Throws<ArgumentNullException>(
        () => sut.ProcessOrder(null!));
    
    Assert.Equal("order", exception.ParamName);
}
```

### Use Assert.ThrowsAsync for Async Methods

```csharp
[Fact]
public async Task ProcessOrderAsync_WithNullOrder_ThrowsArgumentNullException()
{
    // Arrange
    var sut = new OrderService(Mock.Of<IOrderRepository>());
    
    // Act & Assert
    var exception = await Assert.ThrowsAsync<ArgumentNullException>(
        () => sut.ProcessOrderAsync(null!));
    
    Assert.Equal("order", exception.ParamName);
}
```

### Test Exception Messages When Relevant

```csharp
[Fact]
public void Withdraw_WithInsufficientFunds_ThrowsInsufficientFundsException()
{
    // Arrange
    var account = new BankAccount(balance: 100m);
    
    // Act & Assert
    var exception = Assert.Throws<InsufficientFundsException>(
        () => account.Withdraw(150m));
    
    Assert.Equal(100m, exception.AvailableBalance);
    Assert.Equal(150m, exception.RequestedAmount);
    Assert.Contains("insufficient funds", exception.Message, StringComparison.OrdinalIgnoreCase);
}
```

---

## Async Testing Best Practices

### Always Await Async Operations

```csharp
// ✅ Correct
[Fact]
public async Task GetOrderAsync_WithValidId_ReturnsOrder()
{
    // Arrange
    var mockRepository = new Mock<IOrderRepository>();
    mockRepository
        .Setup(r => r.GetByIdAsync(1, It.IsAny<CancellationToken>()))
        .ReturnsAsync(new Order { Id = 1 });
    
    var sut = new OrderService(mockRepository.Object);
    
    // Act
    var result = await sut.GetOrderAsync(1);
    
    // Assert
    Assert.NotNull(result);
    Assert.Equal(1, result.Id);
}

// ❌ Incorrect - Missing await
[Fact]
public void GetOrderAsync_WithValidId_ReturnsOrder()
{
    var result = sut.GetOrderAsync(1).Result;  // Don't use .Result
}
```

### Test Cancellation Token Handling

```csharp
[Fact]
public async Task ProcessOrderAsync_WhenCancelled_ThrowsOperationCanceledException()
{
    // Arrange
    var cts = new CancellationTokenSource();
    var mockRepository = new Mock<IOrderRepository>();
    mockRepository
        .Setup(r => r.SaveAsync(It.IsAny<Order>(), It.IsAny<CancellationToken>()))
        .Returns(async (Order o, CancellationToken ct) =>
        {
            await Task.Delay(1000, ct);  // Simulate slow operation
            return true;
        });
    
    var sut = new OrderService(mockRepository.Object);
    
    // Act
    cts.CancelAfter(TimeSpan.FromMilliseconds(50));
    
    // Assert
    await Assert.ThrowsAsync<OperationCanceledException>(
        () => sut.ProcessOrderAsync(new Order(), cts.Token));
}
```

---

## Running Tests

### Command Line Execution

```bash
# Run all tests
dotnet test

# Run with detailed output
dotnet test --logger "console;verbosity=detailed"

# Run only unit tests (by folder)
dotnet test tests/unit/

# Run only integration tests (by folder)
dotnet test tests/integration/

# Run specific project
dotnet test tests/unit/MyProject.Tests.Unit

# Run tests matching a filter
dotnet test --filter "FullyQualifiedName~OrderService"
dotnet test --filter "Category=Integration"

# Run with code coverage
dotnet test --collect:"XPlat Code Coverage"

# Run unit tests with coverage (common CI scenario)
dotnet test tests/unit/ --collect:"XPlat Code Coverage"
```

### Categorize Tests with Traits

```csharp
[Trait("Category", "Integration")]
public class DatabaseTests
{
    [Fact]
    public async Task CanConnectToDatabase()
    {
        // ...
    }
}

[Trait("Category", "Unit")]
[Trait("Feature", "Orders")]
public class OrderServiceTests
{
    [Fact]
    public void ProcessOrder_WithValidOrder_Succeeds()
    {
        // ...
    }
}
```

---

## Exceptions

### Testing Private Methods

Do not test private methods directly. Test them through public methods that use them. If a private method is complex enough to warrant direct testing, consider extracting it to a separate class.

### Flaky Tests

If a test is flaky (intermittently failing), fix it immediately. Common causes:
- Shared state between tests
- Time-dependent logic
- External dependencies
- Race conditions in async code

### Slow Tests

Mark slow tests with a trait so they can be excluded from fast feedback loops:

```csharp
[Trait("Category", "Slow")]
[Fact]
public async Task LongRunningOperation_CompletesSuccessfully()
{
    // ...
}
```

---

## Related Instructions

- [csharp.instructions.md](./csharp.instructions.md) - General C# coding standards
- [csharp-testing.prompt.md](./csharp-testing.prompt.md) - Prompts for generating tests
- [dotnet-architecture.instructions.md](./dotnet-architecture.instructions.md) - Architecture patterns

---

## Changelog

| Date | Change |
|:-----|:-------|
| 2025-12-10 | Updated folder structure to separate unit tests (`tests/unit/`) and integration tests (`tests/integration/`) |
| 2025-12-10 | Initial version with xUnit, Moq, and Microsoft.NET.Test.Sdk best practices |
