# 何时 Mock

只在**系统边界**处 Mock：

- 外部 API（支付、邮件等）
- 数据库（有时——优先使用测试数据库）
- 时间/随机性
- 文件系统（有时）

不要 Mock：

- 你自己的类/模块
- 内部合作者
- 你控制的任何东西

## 为可 Mock 性设计

在系统边界处，设计易于 Mock 的接口：

**1. 使用依赖注入**

从外部传入依赖，而不是在内部创建它们：

```typescript
// 易于 Mock
function processPayment(order, paymentClient) {
  return paymentClient.charge(order.total);
}

// 难以 Mock
function processPayment(order) {
  const client = new StripeClient(process.env.STRIPE_KEY);
  return client.charge(order.total);
}
```

**2. 优先使用 SDK 风格接口，而非通用获取器**

为每个外部操作创建具体函数，而不是一个带条件逻辑的通用函数：

```typescript
// 好：每个函数可独立 Mock
const api = {
  getUser: (id) => fetch(`/users/${id}`),
  getOrders: (userId) => fetch(`/users/${userId}/orders`),
  createOrder: (data) => fetch('/orders', { method: 'POST', body: data }),
};

// 差：Mock 需要在 Mock 内部写条件逻辑
const api = {
  fetch: (endpoint, options) => fetch(endpoint, options),
};
```

SDK 方法意味着：
- 每个 Mock 返回一个特定形状
- 测试设置中没有条件逻辑
- 更容易看到一个测试使用了哪些端点
- 每个端点的类型安全
