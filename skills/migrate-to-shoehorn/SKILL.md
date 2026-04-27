---
name: migrate-to-shoehorn
description: 将测试文件中的 `as` 类型断言迁移到 @total-typescript/shoehorn。当用户提到 shoehorn、想要替换测试中的 `as` 或需要部分测试数据时使用。
---

# 迁移到 Shoehorn

## 为什么用 shoehorn？

`shoehorn` 允许你在测试中传递部分数据，同时保持 TypeScript 满意。它用类型安全的替代方案替换了 `as` 断言。

**仅限测试代码。** 不要在生产代码中使用 shoehorn。

`as` 在测试中的问题：

- 被训练不要使用它
- 必须手动指定目标类型
- 对故意错误的数据需要双重断言（`as unknown as Type`）

## 安装

```bash
npm i @total-typescript/shoehorn
```

## 迁移模式

### 大型对象中只需要少数属性

之前：

```ts
type Request = {
  body: { id: string };
  headers: Record<string, string>;
  cookies: Record<string, string>;
  // ...还有 20 个属性
};

it("根据 id 获取用户", () => {
  // 只关心 body.id 但必须伪造整个 Request
  getUser({
    body: { id: "123" },
    headers: {},
    cookies: {},
    // ...伪造全部 20 个属性
  });
});
```

之后：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

it("根据 id 获取用户", () => {
  getUser(
    fromPartial({
      body: { id: "123" },
    }),
  );
});
```

### `as Type` → `fromPartial()`

之前：

```ts
getUser({ body: { id: "123" } } as Request);
```

之后：

```ts
import { fromPartial } from "@total-typescript/shoehorn";

getUser(fromPartial({ body: { id: "123" } }));
```

### `as unknown as Type` → `fromAny()`

之前：

```ts
getUser({ body: { id: 123 } } as unknown as Request); // 故意错误的类型
```

之后：

```ts
import { fromAny } from "@total-typescript/shoehorn";

getUser(fromAny({ body: { id: 123 } }));
```

## 何时使用哪个

| 函数              | 用例                                               |
| ----------------- | -------------------------------------------------- |
| `fromPartial()`   | 传递部分数据，仍然通过类型检查                     |
| `fromAny()`       | 传递故意错误的数据（保留自动补全）                 |
| `fromExact()`     | 强制完整对象（以后可以换成 fromPartial）           |

## 工作流程

1. **收集需求** - 询问用户：
   - 哪些测试文件中有引起问题的 `as` 断言？
   - 是否处理的是大型对象，只有部分属性重要？
   - 是否需要在错误测试中传递故意错误的数据？

2. **安装和迁移**：
   - [ ] 安装：`npm i @total-typescript/shoehorn`
   - [ ] 查找带 `as` 断言的测试文件：`grep -r " as [A-Z]" --include="*.test.ts" --include="*.spec.ts"`
   - [ ] 将 `as Type` 替换为 `fromPartial()`
   - [ ] 将 `as unknown as Type` 替换为 `fromAny()`
   - [ ] 添加来自 `@total-typescript/shoehorn` 的导入
   - [ ] 运行类型检查以验证
