---
description: 'Guidelines for building C# applications with modern best practices'
applyTo: '**/*.cs'
---

# C# Instructions

> Guidelines and best practices for writing clean, maintainable, and performant C# code in .NET projects.

**Last Updated**: 2025-12-10  
**Applies To**: All C# source files (`.cs`) in the repository

---

## Overview

This instruction file defines C# coding standards that ensure consistency, readability, and maintainability across the codebase. These guidelines align with Microsoft's .NET coding conventions, Google's C# style guide, and incorporate modern C# language features.

**Target C# Version**: This instruction file targets the latest stable C# version (C# 12/13+). Use modern language features when targeting .NET 8 or later. Always prefer the latest language features unless constrained by target framework requirements.

All code contributions must adhere to these standards. Automated analyzers enforce many of these rules; others require code review verification.

### EditorConfig Integration

Apply code-formatting style defined in the project's `.editorconfig` file. When an `.editorconfig` exists, it takes precedence over general guidelines in this document for formatting rules it explicitly defines.

---

## Rules

### File Naming and Organization

#### Use PascalCase for File and Directory Names

All C# source files and directories must use PascalCase naming.

**Rationale**: Consistent with .NET conventions and ensures compatibility across case-sensitive and case-insensitive file systems.

```
// ✅ Correct
OrderService.cs
CustomerRepository.cs
Models/
Services/
Infrastructure/

// ❌ Incorrect
orderService.cs
customer-repository.cs
order_service.cs
models/
```

#### Match File Name to Primary Class Name

The file name should match the name of the primary class, struct, interface, or enum it contains.

**Rationale**: Makes it easy to locate type definitions and maintains a predictable project structure.

```
// ✅ Correct
// File: OrderService.cs
public class OrderService { }

// File: IOrderRepository.cs
public interface IOrderRepository { }

// File: OrderStatus.cs
public enum OrderStatus { }

// ❌ Incorrect
// File: Services.cs
public class OrderService { }
public class CustomerService { }
```

#### One Primary Type per File

Each file should contain one primary class, struct, interface, or enum. Small, tightly coupled helper types may be included in the same file.

**Rationale**: Improves navigability and makes version control diffs clearer.

```csharp
// ✅ Correct - One primary type
// File: Order.cs
public class Order { }

// ✅ Acceptable - Primary type with small nested or helper types
// File: Order.cs
public class Order
{
    public class OrderLine { }  // Nested type, OK
}

// ❌ Incorrect - Multiple unrelated types
// File: Models.cs
public class Order { }
public class Customer { }
public class Product { }
```

#### Prefer Flat Directory Structures

Keep directory structures as flat as practical. Avoid deeply nested folders.

**Rationale**: Deep nesting makes navigation difficult and often indicates over-engineering.

```
// ✅ Correct - Flat structure
src/
├── Controllers/
├── Services/
├── Repositories/
├── Models/
└── Extensions/

// ❌ Avoid - Overly nested
src/
├── Features/
│   └── Orders/
│       └── Services/
│           └── Implementations/
│               └── Internal/
```

#### Namespace Independence from Folder Structure

Namespaces should be logical and do not need to mirror folder structure exactly. Keep namespaces to a maximum of 2-3 levels deep.

```csharp
// ✅ Correct - Logical namespace
namespace MyApp.Services;

public class OrderService { }

// ✅ Acceptable - Does not match folder exactly
// File location: src/Features/Orders/OrderService.cs
namespace MyApp.Services;

// ❌ Avoid - Excessively deep namespaces
namespace MyApp.Features.Orders.Services.Implementations.Internal;
```

---

### Code Organization

#### Modifier Order

Apply modifiers in the following order:

```
public protected internal private new abstract virtual override sealed static readonly extern unsafe volatile async
```

**Rationale**: Consistent modifier ordering improves readability and is enforced by many analyzers.

```csharp
// ✅ Correct
public static readonly int MaxValue = 100;
private static volatile bool _isRunning;
public virtual async Task ProcessAsync() { }
protected internal override void OnExecute() { }

// ❌ Incorrect
static public readonly int MaxValue = 100;
volatile private static bool _isRunning;
async public virtual Task ProcessAsync() { }
```

#### Class Member Ordering

Organize class members in the following order:

1. **Nested types** (classes, enums, delegates, events)
2. **Constants and static readonly fields**
3. **Static fields**
4. **Instance fields**
5. **Properties**
6. **Constructors and finalizers**
7. **Methods**

Within each group, order by accessibility:
1. `public`
2. `internal`
3. `protected internal`
4. `protected`
5. `private`

**Rationale**: Predictable organization makes classes easier to navigate and understand.

```csharp
// ✅ Correct - Properly ordered
public class OrderService : IOrderService
{
    // 1. Nested types
    public enum ProcessingState { Pending, Complete }
    
    // 2. Constants and static readonly
    public const int MaxRetries = 3;
    private const string DefaultCurrency = "USD";
    
    // 3. Static fields
    private static readonly object _lock = new();
    
    // 4. Instance fields
    private readonly IOrderRepository _orderRepository;
    private readonly ILogger<OrderService> _logger;
    private int _retryCount;
    
    // 5. Properties
    public bool IsProcessing { get; private set; }
    
    // 6. Constructors
    public OrderService(IOrderRepository orderRepository, ILogger<OrderService> logger)
    {
        _orderRepository = orderRepository;
        _logger = logger;
    }
    
    // 7. Methods (public first, then private)
    public async Task<Order> ProcessOrderAsync(int id) { }
    
    private void ValidateOrder(Order order) { }
}
```

#### Using Directive Organization

Place `using` directives at the top of the file, outside the namespace. Order alphabetically with `System` namespaces first.

```csharp
// ✅ Correct
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Extensions.Logging;
using MyApp.Models;
using MyApp.Repositories;

namespace MyApp.Services;

public class OrderService { }
```

#### Group Interface Implementations

When a class implements multiple interfaces, group the implementation methods together where practical.

```csharp
// ✅ Correct - Grouped implementations
public class OrderService : IOrderService, IDisposable
{
    // IOrderService implementation
    public Task<Order> GetOrderAsync(int id) { }
    public Task SaveOrderAsync(Order order) { }
    
    // IDisposable implementation
    public void Dispose() { }
}
```

---

### Formatting and Whitespace

#### Indentation

Use 4 spaces for indentation. Do not use tabs.

```csharp
// ✅ Correct - 4 space indentation
public class OrderService
{
    public void Process()
    {
        if (condition)
        {
            DoSomething();
        }
    }
}
```

#### Line Length

Limit lines to 120 characters. Break long lines for readability.

#### Brace Style

Opening braces may be placed on the same line (K&R) or on a new line (Allman). Be consistent within a project.

```csharp
// ✅ Acceptable - Allman style (common in .NET)
public class OrderService
{
    public void Process()
    {
        if (condition)
        {
            DoSomething();
        }
        else
        {
            DoSomethingElse();
        }
    }
}

// ✅ Also acceptable - K&R style
public class OrderService {
    public void Process() {
        if (condition) {
            DoSomething();
        } else {
            DoSomethingElse();
        }
    }
}
```

> **Note**: Be consistent within a project. If the existing codebase uses Allman style (braces on new lines), continue using it.

#### Always Use Braces

Use braces for all control flow statements, even single-line bodies.

**Rationale**: Prevents bugs when adding statements and improves readability.

```csharp
// ✅ Correct
if (isValid)
{
    Process();
}

foreach (var item in items)
{
    Process(item);
}

// ❌ Incorrect
if (isValid)
    Process();

foreach (var item in items)
    Process(item);
```

#### Spacing Rules

- Add a space after `if`, `for`, `foreach`, `while`, `switch`, `catch`
- Add a space after commas
- Add a space around binary operators
- No space after opening parenthesis or before closing parenthesis
- No space between a unary operator and its operand

```csharp
// ✅ Correct
if (x > 0)
{
    var result = x + y;
    Process(a, b, c);
    count++;
}

// ❌ Incorrect
if(x>0)
{
    var result = x+y;
    Process(a,b,c);
    count ++;
}
```

#### Line Wrapping

When wrapping long lines, indent continuation lines by 4 spaces. Align parameters when practical.

```csharp
// ✅ Correct - Aligned parameters
public void ProcessOrder(int orderId,
                         string customerName,
                         decimal amount)
{
}

// ✅ Correct - Indented parameters (when alignment is impractical)
public void ProcessOrderWithVeryLongMethodName(
    int orderId,
    string customerName,
    decimal amount,
    CancellationToken cancellationToken)
{
}

// ✅ Correct - Fluent chain wrapping
var result = orders
    .Where(o => o.IsActive)
    .OrderBy(o => o.CreatedAt)
    .Select(o => o.Summary)
    .ToList();
```

#### Empty Blocks

Empty blocks may be concise.

```csharp
// ✅ Acceptable
void DoNothing() { }

// ✅ Also acceptable
void DoNothing()
{
}
```

---

### Naming Conventions

#### Use PascalCase for Public Members

Use PascalCase for all public and protected types, methods, properties, events, and constants.

**Rationale**: PascalCase is the established .NET convention for public API surfaces, ensuring consistency with the framework and third-party libraries.

```csharp
// ✅ Correct
public class CustomerService
{
    public const int MaxRetryCount = 3;
    public string CustomerName { get; set; }
    public event EventHandler<OrderEventArgs> OrderPlaced;
    
    public async Task<Customer> GetCustomerAsync(int id) { }
    protected virtual void OnOrderPlaced(OrderEventArgs e) { }
}

// ❌ Incorrect
public class customerService
{
    public const int max_retry_count = 3;
    public string customerName { get; set; }
    
    public async Task<Customer> getCustomerAsync(int id) { }
}
```

#### Use camelCase for Private Fields with Underscore Prefix

Prefix private, protected, internal, and protected internal fields with an underscore and use camelCase.

**Rationale**: The underscore prefix distinguishes fields from local variables and parameters, improving readability and preventing naming conflicts.

```csharp
// ✅ Correct
public class OrderService
{
    private readonly IOrderRepository _orderRepository;
    private readonly ILogger<OrderService> _logger;
    private int _retryCount;
    protected string _internalState;
    internal bool _isInitialized;
}

// ❌ Incorrect
public class OrderService
{
    private readonly IOrderRepository orderRepository;
    private readonly ILogger<OrderService> m_logger;
    private int RetryCount;
}
```

#### Naming Is Unaffected by Modifiers

The `const`, `static`, and `readonly` modifiers do not change naming conventions.

```csharp
// ✅ Correct
public const int MaxValue = 100;           // Public: PascalCase
private const int _maxRetries = 3;         // Private: _camelCase
public static readonly string AppName;     // Public: PascalCase
private static readonly object _lock;      // Private: _camelCase
```

#### Use camelCase for Parameters and Local Variables

Parameters and local variables use camelCase without prefixes.

```csharp
// ✅ Correct
public decimal CalculateTotal(IEnumerable<OrderLine> orderLines, decimal taxRate)
{
    var subtotal = orderLines.Sum(line => line.Amount);
    var taxAmount = subtotal * taxRate;
    return subtotal + taxAmount;
}

// ❌ Incorrect
public decimal CalculateTotal(IEnumerable<OrderLine> OrderLines, decimal TaxRate)
{
    var Subtotal = OrderLines.Sum(line => line.Amount);
}
```

#### Prefix Interfaces with 'I'

All interface names must begin with the letter 'I'.

```csharp
// ✅ Correct
public interface IOrderService { }
public interface IRepository<T> { }
public interface IAsyncDisposable { }

// ❌ Incorrect
public interface OrderService { }
public interface RepositoryInterface<T> { }
```

#### Acronym Casing

Treat acronyms as single words. Use PascalCase, not all caps.

**Rationale**: Improves readability, especially with multiple acronyms.

```csharp
// ✅ Correct
public class HttpClient { }
public class XmlParser { }
public string GetJsonResponse();
public class MyRpcService { }

// ❌ Incorrect
public class HTTPClient { }
public class XMLParser { }
public string GetJSONResponse();
public class MyRPCService { }
```

#### Suffix Async Methods with 'Async'

All methods returning `Task`, `Task<T>`, `ValueTask`, or `ValueTask<T>` must be suffixed with 'Async'.

**Rationale**: The suffix signals to callers that the method is asynchronous and should be awaited.

```csharp
// ✅ Correct
public Task<Order> GetOrderAsync(int id);
public ValueTask<bool> ValidateAsync(Order order);
public Task ProcessOrdersAsync(CancellationToken cancellationToken);

// ❌ Incorrect
public Task<Order> GetOrder(int id);
public ValueTask<bool> Validate(Order order);
public async Task ProcessOrders() { } // Missing Async suffix
```

#### Use Meaningful, Descriptive Names

Names should reveal intent. Avoid abbreviations except for universally understood terms.

```csharp
// ✅ Correct
public class CustomerOrderProcessor { }
public int CalculateMonthlyRevenue(DateTime month) { }
private readonly HttpClient _httpClient;
var activeCustomers = customers.Where(c => c.IsActive);

// ❌ Incorrect
public class CustOrdProc { }
public int CalcMonRev(DateTime m) { }
private readonly HttpClient _hc;
var ac = customers.Where(c => c.IsActive);
```

#### Boolean Naming Conventions

Prefix boolean properties and variables with `is`, `has`, `can`, `should`, or similar verbs.

```csharp
// ✅ Correct
public bool IsActive { get; set; }
public bool HasPermission { get; }
public bool CanExecute();
public bool ShouldRetry { get; }
var isValid = order.Validate();

// ❌ Incorrect
public bool Active { get; set; }
public bool Permission { get; }
public bool Execute();
var valid = order.Validate();
```

#### Use nameof Instead of String Literals

Use the `nameof` operator when referring to member names to ensure refactoring safety and compile-time validation.

**Rationale**: The `nameof` operator returns the name as a string at compile time. If the referenced member is renamed, the compiler will catch the error. String literals silently become incorrect.

```csharp
// ✅ Correct
public void ProcessOrder(Order order)
{
    ArgumentNullException.ThrowIfNull(order);
    // If 'order' is renamed, this will cause a compile error
    
    _logger.LogInformation("Executing {MethodName}", nameof(ProcessOrder));
}

public class Customer : INotifyPropertyChanged
{
    private string _name;
    
    public string Name
    {
        get => _name;
        set
        {
            _name = value;
            OnPropertyChanged(nameof(Name));  // Refactor-safe
        }
    }
}

// ❌ Incorrect - String literals don't update during refactoring
public void ProcessOrder(Order order)
{
    if (order == null)
        throw new ArgumentNullException("order");  // Won't update if parameter renamed
    
    _logger.LogInformation("Executing ProcessOrder");  // Won't update if method renamed
}
```

---

### The var Keyword

#### Use var When Type Is Obvious

Use `var` when the type is evident from the right-hand side of the assignment.

```csharp
// ✅ Correct - Type is obvious
var customer = new Customer();
var orders = new List<Order>();
var stream = File.OpenRead(path);
var dictionary = new Dictionary<string, int>();
```

#### Use var for Transient Variables

Use `var` for variables that are immediately passed to other methods.

```csharp
// ✅ Correct
var item = GetItem();
ProcessItem(item);
```

#### Avoid var with Basic Types

Use explicit types for basic types and literals where the type isn't immediately clear.

```csharp
// ✅ Correct - Explicit types for clarity
bool isValid = true;
int count = 0;
string name = "Default";
decimal price = 19.99m;

// ❌ Discouraged
var isValid = true;      // Not obvious it's bool
var count = 0;           // Not obvious it's int
var number = 12 * GetMultiplier();  // Unclear numeric type
```

#### Avoid var When Type Aids Understanding

When knowing the type significantly aids code comprehension, use explicit types.

```csharp
// ✅ Correct - Type aids understanding
IEnumerable<Order> orders = GetOrders();  // Clear it's IEnumerable, not List
IOrderService service = GetService();      // Clear it's the interface

// ❌ Discouraged
var orders = GetOrders();   // Is it List? Array? IEnumerable?
var result = Process();     // What type is result?
```

---

### Code Style

#### Use File-Scoped Namespaces

Use file-scoped namespace declarations (C# 10+) to reduce indentation.

**Note**: This is a modern convention. Older codebases may use block-scoped namespaces; be consistent within a project.

```csharp
// ✅ Correct (C# 10+)
namespace MyApp.Services;

public class OrderService { }

// ✅ Acceptable (older style, be consistent)
namespace MyApp.Services
{
    public class OrderService { }
}
```

#### Enable Nullable Reference Types

All projects must enable nullable reference types. Annotate nullability explicitly.

```csharp
// ✅ Correct - explicit nullability
public class CustomerService
{
    public Customer? GetCustomer(int id);           // May return null
    public Customer GetRequiredCustomer(int id);   // Never returns null
    public void Process(Customer customer);         // Parameter cannot be null
    public void ProcessOptional(Customer? customer); // Parameter may be null
}

// ❌ Incorrect - ambiguous nullability
public class CustomerService
{
    public Customer GetCustomer(int id);  // Unclear if null is possible
}
```

#### Use Expression-Bodied Members for Read-Only Properties

Use expression-bodied syntax for simple, read-only properties.

```csharp
// ✅ Correct - Expression body for read-only properties
public class Circle
{
    public double Radius { get; }
    public double Diameter => Radius * 2;
    public double Area => Math.PI * Radius * Radius;
}

// ✅ Correct - Traditional syntax for read-write or complex properties
public class Order
{
    private decimal _discount;
    
    public decimal Discount
    {
        get => _discount;
        set
        {
            ValidateDiscount(value);
            _discount = value;
        }
    }
}
```

#### Use Expression-Bodied Members Judiciously for Methods

For methods, prefer traditional block bodies. Expression bodies are acceptable for very simple methods.

```csharp
// ✅ Correct - Simple method with expression body
public override string ToString() => $"Order({Id})";
public bool IsValid() => Items.Count > 0 && Total > 0;

// ✅ Correct - Block body for methods with logic
public decimal CalculateTotal()
{
    var subtotal = Items.Sum(i => i.Price);
    var tax = subtotal * TaxRate;
    return subtotal + tax;
}
```

#### Use Pattern Matching

Prefer pattern matching over type checking and casting.

```csharp
// ✅ Correct
public decimal CalculateShipping(object item) => item switch
{
    Book { Pages: > 500 } => 5.99m,
    Book => 3.99m,
    Electronics e when e.Weight > 10 => 15.99m,
    Electronics => 7.99m,
    null => throw new ArgumentNullException(nameof(item)),
    _ => 4.99m
};

// Property pattern matching
if (customer is { IsActive: true, Orders.Count: > 0 })
{
    ProcessActiveCustomer(customer);
}

// ❌ Incorrect - old-style type checking
if (item is Book)
{
    var book = (Book)item;
    if (book.Pages > 500)
        return 5.99m;
}
```

#### Use Collection Expressions (C# 12+)

Use collection expressions for initializing collections.

```csharp
// ✅ Correct
int[] numbers = [1, 2, 3, 4, 5];
List<string> names = ["Alice", "Bob", "Charlie"];
Dictionary<string, int> scores = new() { ["Alice"] = 100, ["Bob"] = 95 };

// Spread operator
int[] combined = [..firstArray, ..secondArray, additionalValue];

// ❌ Incorrect
int[] numbers = new int[] { 1, 2, 3, 4, 5 };
List<string> names = new List<string> { "Alice", "Bob", "Charlie" };
```

#### Use Primary Constructors (C# 12+)

Use primary constructors for simple dependency injection and parameter capture.

```csharp
// ✅ Correct
public class OrderService(
    IOrderRepository orderRepository,
    ILogger<OrderService> logger) : IOrderService
{
    public async Task<Order?> GetOrderAsync(int id)
    {
        logger.LogDebug("Fetching order {OrderId}", id);
        return await orderRepository.GetByIdAsync(id);
    }
}

// ✅ Also correct - when field access is needed
public class OrderService : IOrderService
{
    private readonly IOrderRepository _orderRepository;
    private readonly ILogger<OrderService> _logger;
    
    public OrderService(IOrderRepository orderRepository, ILogger<OrderService> logger)
    {
        _orderRepository = orderRepository ?? throw new ArgumentNullException(nameof(orderRepository));
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }
}
```

#### Use Object Initializers for Plain Data Types

Object initializer syntax is appropriate for simple data objects. Avoid for types with required constructor logic.

```csharp
// ✅ Correct - Plain data type
var options = new RequestOptions
{
    Timeout = TimeSpan.FromSeconds(30),
    RetryCount = 3,
};

// ❌ Avoid - Type has constructor with validation
var order = new Order
{
    CustomerId = customerId,  // Should go through constructor
    Status = OrderStatus.New,
};

// ✅ Correct
var order = new Order(customerId);
```

#### Attribute Placement

Place attributes on separate lines above the member. Multiple attributes should each be on their own line.

```csharp
// ✅ Correct
[HttpGet]
[Authorize]
[ProducesResponseType(StatusCodes.Status200OK)]
public async Task<ActionResult<Order>> GetOrder(int id)
{
}

// ❌ Incorrect
[HttpGet, Authorize, ProducesResponseType(StatusCodes.Status200OK)]
public async Task<ActionResult<Order>> GetOrder(int id)
{
}
```

---

### Structs vs Classes

#### Default to Classes

Use classes for most types. Only use structs when specific conditions apply.

#### Use Structs for Small Value Types

Consider structs when:
- The type represents a single value (like `Point`, `Color`, `DateTime`)
- Instances are small (16 bytes or less)
- Instances are short-lived or embedded in other objects
- The type is immutable

```csharp
// ✅ Correct - Good struct candidates
public readonly struct Point(double x, double y)
{
    public double X { get; } = x;
    public double Y { get; } = y;
}

public readonly struct Money(decimal amount, string currency)
{
    public decimal Amount { get; } = amount;
    public string Currency { get; } = currency;
}

// ❌ Incorrect - Should be a class
public struct OrderProcessor  // Too complex, has behavior
{
    private readonly IOrderRepository _repository;
    public void Process() { }
}
```

#### Understand Struct Value Semantics

Remember that structs are passed by value. Assigning to a property of a returned struct does not modify the original.

```csharp
// ⚠️ Warning - This doesn't work as expected with structs
transform.Position.X = 10;  // If Position returns a struct, this modifies a COPY
```

---

### Parameters

#### Use out for Output-Only Parameters

Use `out` for parameters that are outputs only, not inputs. Place `out` parameters after all other parameters.

```csharp
// ✅ Correct
public bool TryGetValue(string key, out int value)
{
    // ...
}

public bool TryParse(string input, out DateTime result, out string errorMessage)
{
    // out parameters at the end
}
```

#### Use ref Sparingly

Only use `ref` when mutating an input is truly necessary. Do not use `ref` for performance optimization with structs.

```csharp
// ✅ Correct - Mutating input is necessary
public void Swap<T>(ref T a, ref T b)
{
    (a, b) = (b, a);
}

// ❌ Incorrect - Don't use ref for perf with structs
public void Process(ref LargeStruct data)  // Pass by value instead
{
}

// ❌ Incorrect - Don't use ref to replace a container
public void UpdateList(ref List<int> items)  // Just mutate the list
{
}
```

#### Use Named Arguments for Clarity

When argument meaning is not obvious, use named arguments, especially for boolean parameters.

```csharp
// ❌ Unclear
ProcessOrder(order, true, false, null);

// ✅ Clear
ProcessOrder(
    order,
    validateInventory: true,
    sendNotification: false,
    callback: null);

// ✅ Better - Use options object for many parameters
var options = new ProcessOrderOptions
{
    ValidateInventory = true,
    SendNotification = false,
};
ProcessOrder(order, options);
```

#### Consider Options Objects for Complex Methods

When a method has many configuration options, use an options object instead of multiple parameters.

```csharp
// ❌ Too many parameters
public void Export(
    string path,
    bool includeHeaders,
    bool compress,
    string encoding,
    int bufferSize,
    bool overwrite)
{
}

// ✅ Options object
public class ExportOptions
{
    public bool IncludeHeaders { get; init; } = true;
    public bool Compress { get; init; }
    public string Encoding { get; init; } = "UTF-8";
    public int BufferSize { get; init; } = 4096;
    public bool Overwrite { get; init; }
}

public void Export(string path, ExportOptions? options = null)
{
    options ??= new ExportOptions();
}
```

---

### Collections

#### Prefer List Over Arrays for Public APIs

Use `List<T>` for public variables, properties, and return types when the collection may change.

```csharp
// ✅ Correct
public List<Order> Orders { get; } = new();
public List<string> GetActiveUsers() { }

// Use arrays when size is fixed and known
private readonly int[] _lookupTable = new int[256];
```

#### Use Appropriate Collection Interfaces

For inputs, use the most restrictive interface. For outputs, consider ownership transfer.

```csharp
// ✅ Correct - Restrictive input types
public void Process(IReadOnlyList<Order> orders)  // Caller's list won't be modified
{
}

public void Process(IEnumerable<Order> orders)  // Only needs iteration
{
}

// ✅ Correct - Consider ownership for outputs
public IList<Order> GetOrders()  // Transfers ownership
{
    return new List<Order> { /* ... */ };
}

public IReadOnlyList<Order> GetOrdersReadOnly()  // Retains ownership
{
    return _orders.AsReadOnly();
}
```

#### Prefer Arrays for Multidimensional Data

```csharp
// ✅ Correct
int[,] matrix = new int[3, 3];
double[][] jaggedArray = new double[10][];
```

---

### Error Handling

#### Use Specific Exception Types

Throw and catch specific exception types. Create domain exceptions for business rule violations.

```csharp
// ✅ Correct
public class OrderNotFoundException : Exception
{
    public int OrderId { get; }
    
    public OrderNotFoundException(int orderId)
        : base($"Order with ID {orderId} was not found.")
    {
        OrderId = orderId;
    }
}

public async Task<Order> GetOrderAsync(int id)
{
    var order = await _repository.GetByIdAsync(id);
    return order ?? throw new OrderNotFoundException(id);
}

// ❌ Incorrect
public async Task<Order> GetOrderAsync(int id)
{
    var order = await _repository.GetByIdAsync(id);
    if (order == null)
        throw new Exception("Order not found"); // Too generic
    return order;
}
```

#### Use Guard Clauses

Validate arguments at method entry using guard clauses.

```csharp
// ✅ Correct
public void ProcessOrder(Order order, Customer customer)
{
    ArgumentNullException.ThrowIfNull(order);
    ArgumentNullException.ThrowIfNull(customer);
    ArgumentOutOfRangeException.ThrowIfNegativeOrZero(order.Quantity);
    
    // Method logic here
}

// ❌ Incorrect - validation mixed with logic
public void ProcessOrder(Order order, Customer customer)
{
    // Some logic...
    if (order == null) throw new ArgumentNullException(nameof(order));
    // More logic...
}
```

#### Never Swallow Exceptions Silently

Always log or handle exceptions meaningfully. Never use empty catch blocks.

```csharp
// ✅ Correct
try
{
    await ProcessPaymentAsync(order);
}
catch (PaymentGatewayException ex)
{
    _logger.LogError(ex, "Payment failed for order {OrderId}", order.Id);
    throw new OrderProcessingException("Payment processing failed", ex);
}

// ❌ Incorrect
try
{
    await ProcessPaymentAsync(order);
}
catch (Exception)
{
    // Silently swallowed - never do this
}
```

---

### Async/Await

#### Always Use CancellationToken

Accept and propagate `CancellationToken` in all async methods.

```csharp
// ✅ Correct
public async Task<IEnumerable<Order>> GetOrdersAsync(
    int customerId,
    CancellationToken cancellationToken = default)
{
    return await _dbContext.Orders
        .Where(o => o.CustomerId == customerId)
        .ToListAsync(cancellationToken);
}

// ❌ Incorrect
public async Task<IEnumerable<Order>> GetOrdersAsync(int customerId)
{
    return await _dbContext.Orders
        .Where(o => o.CustomerId == customerId)
        .ToListAsync(); // No cancellation support
}
```

#### Never Use async void

Use `async Task` instead of `async void` except for event handlers.

**Rationale**: Exceptions in `async void` methods cannot be caught and will crash the application.

```csharp
// ✅ Correct
public async Task ProcessDataAsync() { }

// ✅ Correct - event handler exception
private async void Button_Click(object sender, EventArgs e)
{
    try
    {
        await ProcessDataAsync();
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Button click processing failed");
    }
}

// ❌ Incorrect
public async void ProcessData() { } // Exceptions are unobservable
```

#### Avoid .Result and .Wait()

Never block on async code. Use `await` instead.

```csharp
// ✅ Correct
public async Task<Order> GetOrderAsync(int id)
{
    var order = await _repository.GetByIdAsync(id);
    return order;
}

// ❌ Incorrect - causes deadlocks
public Order GetOrder(int id)
{
    var order = _repository.GetByIdAsync(id).Result; // Deadlock risk
    return order;
}
```

#### Use ValueTask for Hot Paths

Use `ValueTask` when methods frequently complete synchronously.

```csharp
// ✅ Correct - frequently synchronous path
public ValueTask<Order?> GetCachedOrderAsync(int id)
{
    if (_cache.TryGetValue(id, out Order? order))
        return ValueTask.FromResult(order);
    
    return new ValueTask<Order?>(LoadFromDatabaseAsync(id));
}
```

---

### Delegates and Events

#### Use Invoke with Null Conditional

When calling delegates, use `Invoke()` with the null conditional operator.

**Rationale**: Clearly marks the call as a delegate invocation and is thread-safe.

```csharp
// ✅ Correct
public event EventHandler<OrderEventArgs>? OrderPlaced;

protected virtual void OnOrderPlaced(OrderEventArgs e)
{
    OrderPlaced?.Invoke(this, e);
}

// ❌ Incorrect
protected virtual void OnOrderPlaced(OrderEventArgs e)
{
    if (OrderPlaced != null)
        OrderPlaced(this, e);  // Race condition possible
}
```

---

### LINQ

#### Prefer Method Syntax Over Query Syntax

Use method syntax for LINQ queries. Use query syntax only for complex joins where it improves readability.

```csharp
// ✅ Correct
var activeOrders = orders
    .Where(o => o.Status == OrderStatus.Active)
    .OrderByDescending(o => o.CreatedAt)
    .Select(o => new OrderSummary(o.Id, o.Total))
    .ToList();

// ✅ Acceptable - complex join
var orderDetails =
    from order in orders
    join customer in customers on order.CustomerId equals customer.Id
    join product in products on order.ProductId equals product.Id
    select new { order, customer, product };
```

#### Prefer Imperative Code Over Long LINQ Chains

Mixing imperative code with heavily chained LINQ is often hard to read. Break up complex operations.

```csharp
// ✅ Correct - Clear and readable
var activeOrders = orders.Where(o => o.IsActive).ToList();
var sortedOrders = activeOrders.OrderBy(o => o.Date).ToList();

foreach (var order in sortedOrders)
{
    ProcessOrder(order);
}

// ❌ Avoid - Too much chaining with side effects
orders
    .Where(o => o.IsActive)
    .OrderBy(o => o.Date)
    .Select(o => { ProcessOrder(o); return o; })  // Side effect in LINQ
    .ToList();
```

#### Avoid Container.ForEach()

For anything longer than a single statement, use a regular `foreach` loop.

```csharp
// ✅ Acceptable for simple operations
items.ForEach(item => item.MarkProcessed());

// ✅ Correct for complex operations
foreach (var item in items)
{
    item.Validate();
    item.Process();
    item.Save();
}

// ❌ Avoid
items.ForEach(item =>
{
    item.Validate();
    item.Process();
    item.Save();
});
```

#### Materialize Queries When Appropriate

Call `ToList()`, `ToArray()`, or `ToDictionary()` to materialize queries when the result will be enumerated multiple times.

```csharp
// ✅ Correct
var activeCustomers = customers.Where(c => c.IsActive).ToList();
Console.WriteLine($"Count: {activeCustomers.Count}");
foreach (var customer in activeCustomers) { }

// ❌ Incorrect - query executes twice
var activeCustomers = customers.Where(c => c.IsActive);
Console.WriteLine($"Count: {activeCustomers.Count()}"); // First execution
foreach (var customer in activeCustomers) { } // Second execution
```

#### Avoid LINQ in Hot Paths

For performance-critical code, prefer loops over LINQ to avoid allocations.

```csharp
// ✅ Correct - hot path
public int SumPositive(int[] numbers)
{
    var sum = 0;
    foreach (var n in numbers)
    {
        if (n > 0) sum += n;
    }
    return sum;
}

// ❌ Avoid in hot paths - allocates
public int SumPositive(int[] numbers)
{
    return numbers.Where(n => n > 0).Sum();
}
```

---

### Constants and Fields

#### Prefer const Over Static Readonly

Use `const` when the value is truly compile-time constant. Use `static readonly` when the value is determined at runtime.

```csharp
// ✅ Correct
public const int MaxRetries = 3;                    // Compile-time constant
public const string DefaultName = "Unknown";        // Compile-time constant

public static readonly TimeSpan Timeout = TimeSpan.FromSeconds(30);  // Runtime
public static readonly Guid DefaultId = Guid.Empty;                   // Runtime
```

#### Use Field Initializers

Initialize fields at declaration when possible.

```csharp
// ✅ Correct
public class OrderService
{
    private readonly List<Order> _pendingOrders = new();
    private int _processedCount = 0;
    private bool _isInitialized = false;
}
```

#### Prefer Named Constants Over Magic Numbers

```csharp
// ✅ Correct
private const int MaxPasswordLength = 128;
private const int DefaultPageSize = 20;

if (password.Length > MaxPasswordLength) { }
var results = query.Take(DefaultPageSize);

// ❌ Incorrect
if (password.Length > 128) { }  // What is 128?
var results = query.Take(20);    // Why 20?
```

---

### Miscellaneous

#### Prefer Named Types Over Tuples for Public APIs

Use named classes or records instead of `Tuple<>` for return types, especially for complex data.

```csharp
// ✅ Correct
public record OrderResult(Order Order, bool IsNew, string Message);

public OrderResult CreateOrder(OrderRequest request)
{
    // ...
}

// ❌ Avoid for public APIs
public Tuple<Order, bool, string> CreateOrder(OrderRequest request)
{
    // ...
}

// ✅ Acceptable for internal/private methods
private (bool success, string error) ValidateInternal() { }
```

#### Avoid Using Aliases for Type Names

Don't use `using` aliases to rename types. This often indicates a need for a proper class.

```csharp
// ❌ Avoid
using CustomerList = List<Tuple<int, string, DateTime>>;

// ✅ Correct - Create a proper type
public record Customer(int Id, string Name, DateTime CreatedAt);
public class CustomerList : List<Customer> { }
```

#### Removing Items While Iterating

Use `RemoveAll` or create a new collection rather than modifying during iteration.

```csharp
// ✅ Correct - RemoveAll
items.RemoveAll(item => item.IsExpired);

// ✅ Correct - New collection
var activeItems = items.Where(item => !item.IsExpired).ToList();
items.Clear();
items.AddRange(activeItems);

// ❌ Incorrect - Modifying during iteration
foreach (var item in items)
{
    if (item.IsExpired)
        items.Remove(item);  // Throws InvalidOperationException
}
```

---

### Dependency Injection

#### Use Constructor Injection

Inject dependencies through constructors. Avoid property injection and service locator patterns.

```csharp
// ✅ Correct
public class OrderService
{
    private readonly IOrderRepository _orderRepository;
    private readonly IEmailService _emailService;
    
    public OrderService(IOrderRepository orderRepository, IEmailService emailService)
    {
        _orderRepository = orderRepository;
        _emailService = emailService;
    }
}

// ❌ Incorrect - service locator
public class OrderService
{
    private readonly IServiceProvider _serviceProvider;
    
    public void Process()
    {
        var repository = _serviceProvider.GetRequiredService<IOrderRepository>();
    }
}
```

#### Register Services with Appropriate Lifetimes

Choose service lifetimes carefully based on the service's state and dependencies.

```csharp
// Singleton: Stateless services, caches, configuration
services.AddSingleton<ICacheService, MemoryCacheService>();
services.AddSingleton<IConfiguration>(configuration);

// Scoped: Database contexts, unit of work, per-request state
services.AddScoped<IDbContext, AppDbContext>();
services.AddScoped<ICurrentUserService, CurrentUserService>();

// Transient: Lightweight, stateless services
services.AddTransient<IDateTimeProvider, DateTimeProvider>();
services.AddTransient<IGuidGenerator, GuidGenerator>();
```

---

### Security

#### Never Hardcode Secrets

Use configuration, environment variables, or secret managers for sensitive data.

```csharp
// ✅ Correct
public class PaymentService
{
    private readonly PaymentSettings _settings;
    
    public PaymentService(IOptions<PaymentSettings> settings)
    {
        _settings = settings.Value;
    }
}

// ❌ Incorrect
public class PaymentService
{
    private const string ApiKey = "sk_live_abc123"; // Never do this
}
```

#### Validate All Input

Validate and sanitize all external input, including user input, API requests, and file uploads.

```csharp
// ✅ Correct
public class CreateOrderCommandValidator : AbstractValidator<CreateOrderCommand>
{
    public CreateOrderCommandValidator()
    {
        RuleFor(x => x.CustomerId).NotEmpty();
        RuleFor(x => x.ProductId).NotEmpty();
        RuleFor(x => x.Quantity).InclusiveBetween(1, 1000);
        RuleFor(x => x.Email).EmailAddress().MaximumLength(256);
    }
}
```

#### Use Parameterized Queries

Never concatenate user input into SQL queries.

```csharp
// ✅ Correct
var customer = await _dbContext.Customers
    .FirstOrDefaultAsync(c => c.Email == email);

// ✅ Correct - raw SQL with parameters
var customers = await _dbContext.Customers
    .FromSqlInterpolated($"SELECT * FROM Customers WHERE Email = {email}")
    .ToListAsync();

// ❌ Incorrect - SQL injection vulnerability
var query = $"SELECT * FROM Customers WHERE Email = '{email}'";
```

---

### Performance

#### Use StringBuilder for String Concatenation in Loops

```csharp
// ✅ Correct
public string BuildReport(IEnumerable<ReportLine> lines)
{
    var sb = new StringBuilder();
    foreach (var line in lines)
    {
        sb.AppendLine($"{line.Date:d}: {line.Description}");
    }
    return sb.ToString();
}

// ❌ Incorrect - O(n²) allocations
public string BuildReport(IEnumerable<ReportLine> lines)
{
    var result = "";
    foreach (var line in lines)
    {
        result += $"{line.Date:d}: {line.Description}\n";
    }
    return result;
}
```

#### Use Span for Buffer Operations

Use `Span<T>` and `Memory<T>` to avoid allocations when working with buffers.

```csharp
// ✅ Correct
public static bool TryParseCoordinates(ReadOnlySpan<char> input, out double x, out double y)
{
    var commaIndex = input.IndexOf(',');
    if (commaIndex < 0)
    {
        x = y = 0;
        return false;
    }
    
    return double.TryParse(input[..commaIndex], out x)
        && double.TryParse(input[(commaIndex + 1)..], out y);
}
```

#### Dispose Resources Properly

Use `using` statements or implement `IDisposable` correctly.

```csharp
// ✅ Correct - using declaration
public async Task ProcessFileAsync(string path)
{
    await using var stream = File.OpenRead(path);
    await using var reader = new StreamReader(stream);
    var content = await reader.ReadToEndAsync();
}

// ✅ Correct - IDisposable implementation
public sealed class ResourceManager : IDisposable
{
    private bool _disposed;
    private readonly Stream _stream;
    
    public void Dispose()
    {
        if (_disposed) return;
        _stream.Dispose();
        _disposed = true;
    }
}
```

---

### Documentation

#### Document Public APIs with XML Comments

All public types and members must have XML documentation. When applicable, include `<example>` and `<code>` tags to demonstrate usage.

```csharp
/// <summary>
/// Processes customer orders and handles payment transactions.
/// </summary>
public interface IOrderService
{
    /// <summary>
    /// Submits an order for processing.
    /// </summary>
    /// <param name="order">The order to submit.</param>
    /// <param name="cancellationToken">Token to cancel the operation.</param>
    /// <returns>The result of the order submission.</returns>
    /// <exception cref="ArgumentNullException">Thrown when order is null.</exception>
    /// <exception cref="InvalidOrderException">Thrown when the order fails validation.</exception>
    /// <example>
    /// <code>
    /// var order = new Order(customerId, items);
    /// var result = await orderService.SubmitOrderAsync(order);
    /// if (result.IsSuccess)
    /// {
    ///     Console.WriteLine($"Order {result.OrderId} submitted successfully");
    /// }
    /// </code>
    /// </example>
    Task<OrderResult> SubmitOrderAsync(Order order, CancellationToken cancellationToken = default);
}

/// <summary>
/// Calculates the total price including tax.
/// </summary>
/// <param name="basePrice">The base price before tax.</param>
/// <param name="taxRate">The tax rate as a decimal (e.g., 0.08 for 8%).</param>
/// <returns>The total price including tax.</returns>
/// <example>
/// <code>
/// var total = CalculateTotal(100.00m, 0.08m);
/// // Returns 108.00m
/// </code>
/// </example>
public decimal CalculateTotal(decimal basePrice, decimal taxRate)
{
    return basePrice * (1 + taxRate);
}
```

---

### ASP.NET Core and Web API

#### Caching Strategies

Implement appropriate caching strategies based on data characteristics:

```csharp
// In-memory caching for frequently accessed, rarely changing data
services.AddMemoryCache();

// Distributed caching for multi-instance deployments
services.AddStackExchangeRedisCache(options =>
{
    options.Configuration = configuration.GetConnectionString("Redis");
});

// Response caching for GET endpoints
[HttpGet("{id}")]
[ResponseCache(Duration = 60, VaryByQueryKeys = new[] { "id" })]
public async Task<ActionResult<Order>> GetOrder(int id)
{
}
```

#### Pagination, Filtering, and Sorting

Implement pagination for large data sets to improve performance and usability.

```csharp
public class PagedRequest
{
    public int Page { get; init; } = 1;
    public int PageSize { get; init; } = 20;
    public string? SortBy { get; init; }
    public bool SortDescending { get; init; }
}

public class PagedResult<T>
{
    public IReadOnlyList<T> Items { get; init; } = [];
    public int TotalCount { get; init; }
    public int Page { get; init; }
    public int PageSize { get; init; }
    public int TotalPages => (int)Math.Ceiling(TotalCount / (double)PageSize);
}

[HttpGet]
public async Task<ActionResult<PagedResult<Order>>> GetOrders([FromQuery] PagedRequest request)
{
    var query = _dbContext.Orders.AsQueryable();
    
    var totalCount = await query.CountAsync();
    
    var items = await query
        .OrderByDescending(o => o.CreatedAt)
        .Skip((request.Page - 1) * request.PageSize)
        .Take(request.PageSize)
        .ToListAsync();
    
    return new PagedResult<Order>
    {
        Items = items,
        TotalCount = totalCount,
        Page = request.Page,
        PageSize = request.PageSize
    };
}
```

#### Health Checks

Implement health checks for monitoring application and dependency health.

```csharp
// Program.cs
builder.Services.AddHealthChecks()
    .AddDbContextCheck<AppDbContext>()
    .AddRedis(configuration.GetConnectionString("Redis")!)
    .AddCheck<CustomHealthCheck>("custom");

app.MapHealthChecks("/health", new HealthCheckOptions
{
    ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse
});

app.MapHealthChecks("/health/ready", new HealthCheckOptions
{
    Predicate = check => check.Tags.Contains("ready")
});

app.MapHealthChecks("/health/live", new HealthCheckOptions
{
    Predicate = _ => false  // Just checks if app is running
});
```

---

### Containerization and Deployment

#### Use .NET Built-in Container Support

Use .NET's built-in container support for containerizing applications when possible.

```bash
# Build and publish as a container image
dotnet publish --os linux --arch x64 -p:PublishProfile=DefaultContainer

# Or configure in csproj
```

```xml
<PropertyGroup>
  <ContainerRepository>myregistry.azurecr.io/myapp</ContainerRepository>
  <ContainerImageTag>$(Version)</ContainerImageTag>
</PropertyGroup>
```

**Rationale**: .NET's container publishing features handle many best practices automatically, including:
- Optimal base image selection
- Layer optimization
- Non-root user configuration

Only use manual Dockerfile creation when you need customizations beyond what .NET provides.

---

### Architecture and Design

#### Feature Folder Organization

For larger applications, consider organizing code by feature/domain rather than by technical layer.

```
src/
├── Features/
│   ├── Orders/
│   │   ├── CreateOrder/
│   │   │   ├── CreateOrderCommand.cs
│   │   │   ├── CreateOrderHandler.cs
│   │   │   └── CreateOrderValidator.cs
│   │   ├── GetOrder/
│   │   │   ├── GetOrderQuery.cs
│   │   │   └── GetOrderHandler.cs
│   │   └── OrderRepository.cs
│   └── Customers/
│       ├── CreateCustomer/
│       └── CustomerRepository.cs
├── Shared/
│   ├── Behaviors/
│   └── Exceptions/
└── Infrastructure/
    └── Persistence/
```

**Rationale**: Feature folders keep related code together, making it easier to understand and modify a feature without jumping between multiple directories.

#### Domain-Driven Design Considerations

When implementing domain logic:

- Define aggregate boundaries and consistency rules
- Use domain events for loose coupling between aggregates
- Encapsulate business rules within domain entities
- Use ubiquitous language consistently in code and documentation

See [dotnet-architecture.instructions.md](./dotnet-architecture.instructions.md) for detailed DDD guidance.

---

## Code Review Guidance

When reviewing code changes:

- Make only high confidence suggestions
- Write code with good maintainability practices
- Include comments on why certain design decisions were made
- Handle edge cases and write clear exception handling
- For libraries or external dependencies, mention their usage and purpose in comments

---

## Exceptions

### Legacy Code

Legacy code under active migration may defer compliance until refactoring is complete. Mark with:

```csharp
// LEGACY: [rule-name] - Migration planned for Q2 2025
#pragma warning disable CA1822
```

### Generated Code

Auto-generated code (EF migrations, gRPC clients, etc.) is exempt from style rules.

### Performance-Critical Sections

Performance-critical code may bypass certain patterns with documented justification:

```csharp
// PERF: Using array instead of List<T> to avoid heap allocation
// Benchmark: 50% reduction in GC pressure
```

---

## Related Instructions

- [csharp-testing.instructions.md](./csharp-testing.instructions.md) - Testing standards, project organization, and best practices
- [security.instructions.md](./security.instructions.md) - Security guidelines
- [api.instructions.md](./api.instructions.md) - API design standards
- [dotnet-architecture.instructions.md](./dotnet-architecture.instructions.md) - DDD, SOLID principles, and architectural patterns

---

## Changelog

| Date | Change |
|:-----|:-------|
| 2025-12-10 | Moved testing guidance to separate csharp-testing.instructions.md file |
| 2025-12-09 | Added C# version specification, expanded XML doc examples with example/code tags, added code review guidance per awesome-copilot recommendations |
| 2025-12-09 | Added .editorconfig integration, test naming conventions, ASP.NET Core/Web API guidance, containerization, feature folders, DDD references per awesome-copilot recommendations |
| 2025-12-09 | Added YAML front matter, nameof operator guidance per awesome-copilot recommendations |
| 2025-12-09 | Added file naming/organization, member ordering, formatting, var guidelines, struct guidance, parameter rules, delegate patterns, collection guidance per Google style guide |
| 2025-01-15 | Added C# 12 features (primary constructors, collection expressions) |
| 2024-10-01 | Added nullable reference type requirements |
| 2024-07-15 | Initial version |
