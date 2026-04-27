# CONTEXT.md 格式

## 结构

```md
# {上下文名称}

{一两句话描述这个上下文是什么以及为什么存在。}

## 语言

**Order**：
客户购买一件或多件商品的请求。
_避免使用_：Purchase, transaction

**Invoice**：
发货后发送给客户的付款请求。
_避免使用_：Bill, payment request

**Customer**：
下订单的个人或组织。
_避免使用_：Client, buyer, account

## 关系

- 一个 **Order** 生成一个或多个 **Invoice**
- 一个 **Invoice** 属于恰好一个 **Customer**

## 示例对话

> **开发者：** "当 **Customer** 下 **Order** 时，我们会立即创建 **Invoice** 吗？"
> **领域专家：** "不会——**Invoice** 只在 **Fulfillment** 确认后才生成。"

## 标记的歧义

- "account" 曾被用来同时表示 **Customer** 和 **User**——已解决：这是两个不同的概念。
```

## 规则

- **要有主见。**当同一个概念有多个词时，选择最好的一个，把其他的列为应避免的别名。
- **明确标记冲突。**如果某个术语被含混使用，在"标记的歧义"中明确指出，并给出明确的解决方案。
- **保持定义紧凑。**最多一句话。定义它是什么，而不是它做什么。
- **展示关系。**使用粗体术语名称，并在明显时表达基数关系。
- **只包含项目特定于该上下文的术语。**通用编程概念（超时、错误类型、工具模式）即使项目大量使用也不属于这里。在添加术语之前，问：这是此上下文中独特的概念，还是通用编程概念？只有前者才属于。
- **当存在自然聚类时，将术语分组到小标题下。**如果所有术语属于一个单一的内聚领域，扁平列表也可以。
- **编写示例对话。**开发者与领域专家之间的对话，展示术语如何自然交互并澄清相关概念之间的边界。

## 单上下文 vs. 多上下文仓库

**单上下文（大多数仓库）：** 仓库根目录下一个 `CONTEXT.md`。

**多上下文：** 仓库根目录下一个 `CONTEXT-MAP.md` 列出所有上下文、它们的位置以及它们之间的关系：

```md
# 上下文映射

## 上下文

- [Ordering](./src/ordering/CONTEXT.md) — 接收和跟踪客户订单
- [Billing](./src/billing/CONTEXT.md) — 生成发票并处理付款
- [Fulfillment](./src/fulfillment/CONTEXT.md) — 管理仓库拣货和发货

## 关系

- **Ordering → Fulfillment**：Ordering 发出 `OrderPlaced` 事件；Fulfillment 消费它们以开始拣货
- **Fulfillment → Billing**：Fulfillment 发出 `ShipmentDispatched` 事件；Billing 消费它们以生成发票
- **Ordering ↔ Billing**：共享类型 `CustomerId` 和 `Money`
```

技能会推断适用于哪种结构：

- 如果存在 `CONTEXT-MAP.md`，读取它以查找上下文
- 如果只有根目录 `CONTEXT.md`，则是单上下文
- 如果两者都不存在，在第一个术语确定时懒加载创建根 `CONTEXT.md`

当存在多个上下文时，推断当前主题与哪个相关。如果不清楚，询问。
