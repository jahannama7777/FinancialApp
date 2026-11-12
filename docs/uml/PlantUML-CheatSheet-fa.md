# برگهی تقلب PlantUML — پروژهی بانک شخصی

> کد PlantUML همیشه **انگلیسی و LTR** نوشته میشود؛ متن فارسی فقط داخل `""` مجاز است.

## ۰. اسکلت هر فایل


# برگه‌ی تقلب PlantUML — پروژه‌ی بانک شخصی

> این فایل را کنار ادیتور باز نگه دارید. هر دستور، یک مثال کوتاه از پروژه‌ی خودمان دارد.
> کد PlantUML همیشه **انگلیسی و LTR** نوشته می‌شود؛ متن فارسی فقط داخل `""` مجاز است (و بهتر است نباشد).

---

## ۰. اسکلت هر فایل

```
@startuml نام-فایل
' این یک کامنت است
title عنوان نمودار

... محتوا ...

@enduml
```

| مورد | نکته |
|---|---|
| `@startuml` / `@enduml` | **اجباری**. بدون این دو، افزونه می‌گوید «No valid diagram found here». |
| `'` | کامنت تک‌خطی |
| `/' ... '/` | کامنت چندخطی |
| `title متن` | عنوان بالای نمودار |

**تنظیمات ظاهری (اختیاری، بگذارید برای آخر کار):**

```
skinparam monochrome true
skinparam shadowing false
skinparam defaultFontName "Consolas"
left to right direction     ' مخصوص use case، تا نمودار افقی پهن شود
```

---

## ۱. نمودار Use Case

### عناصر پایه

```
actor "کاربر" as U
usecase "واریز به بانک شخصی" as UC1
rectangle "برنامه‌ی مالی" {
  usecase "ورود" as UC0
  usecase "واریز" as UC1
}
```

| دستور | یعنی چه |
|---|---|
| `actor` | آدمک (شخص یا سیستم بیرونی) |
| `usecase` | بیضی (کاری که سیستم انجام می‌دهد) |
| `rectangle "..." { }` | کادر دور use caseها = **مرز سیستم** |
| `as UC1` | نام مستعار؛ از این به بعد فقط `UC1` می‌نویسید |

### رابطه‌ها

```
U --> UC1            ' کاربر با use case ارتباط دارد (Association)
UC1 ..> UC2 : <<include>>    ' UC1 همیشه UC2 را صدا می‌زند
UC3 ..> UC1 : <<extend>>     ' UC3 اختیاری روی UC1 سوار می‌شود
UC5 --|> UC4         ' Generalization: UC5 نوع خاصی از UC4 است
```

| نماد | نام | کِی استفاده کنیم |
|---|---|---|
| `-->` | Association | کاربر ↔ use case. **بدون برچسب.** |
| `..>` | Dependency | برای include و extend |
| `--|>` | Generalization | «هست یک نوع از» |

**تفاوت include و extend — این را حفظ کنید:**

| | Include | Extend |
|---|---|---|
| معنی | «همیشه بخشی از این کار است» | «اختیاری اضافه می‌شود» |
| جهت فلش | از کار اصلی ← به کار فرعی | از کار اختیاری ← به کار اصلی |
| مثال ما | واریز → ثبت تراکنش | اعلان قسط معوق → مشاهده‌ی اقساط |
| کجا می‌نویسیم | روی کار اصلی | روی کار اختیاری |

> نکته‌ای که در پروژه‌ی ما اشتباه شد: **انتقال آیتم** تراکنش نمی‌سازد، پس از آن هیچ Includeای بیرون نمی‌رود.

### یادداشت

```
note right of UC0
  ورود، پیش‌شرط همه‌ی کارهاست.
  پس به actor وصل می‌شود، نه به include.
end note
```

---

## ۲. نمودار Class

### کلاس

```
class Card {
  - id : UUID
  - balance : Decimal
  - isBank : boolean
  + deposit(amount : Decimal) : void
  + getAvailable() : Decimal
}
```

| نماد | دسترسی |
|---|---|
| `-` | private |
| `+` | public |
| `#` | protected |
| `~` | package |

### Enum — همیشه چندخطی

```
enum TransactionDirection {
  IN
  OUT
}
```

> **اشتباه رایج ما:** نوشتن `IN \n OUT` در یک خط. PlantUML آن را نمی‌شکند و کلمه‌ی عجیب می‌سازد. همیشه هر مقدار در خط جدا.

### رابطه‌ها

```
Card "1" -- "0..*" Transaction      ' Association: کارت تراکنش دارد
Loan "1" *-- "0..*" Installment     ' Composition: قسط بدون وام وجود ندارد
User "1" o-- "0..*" Card            ' Aggregation: کارت بدون کاربر هم معنی دارد
Loan --|> Transaction               ' Inheritance
DepositService ..> Card             ' Dependency: فقط استفاده می‌کند
```

| نماد | نام | معنی |
|---|---|---|
| `--` | Association | «دارد» / «مرتبط است» |
| `*--` | Composition | جزء بدون کل **نمی‌تواند** وجود داشته باشد |
| `o--` | Aggregation | جزء بدون کل **می‌تواند** وجود داشته باشد |
| `--|>` | Inheritance | «هست یک نوع از» |
| `..>` | Dependency | «استفاده می‌کند ولی مالک نیست» |

**Multiplicity:** `1`، `0..*`، `1..*`، `0..1` — کنار هر دو سر رابطه بنویسید.

### برچسب نقش

```
Loan "1" -- "0..*" Transaction : lender
Loan "1" -- "0..*" Transaction : borrower
```

> اگر دو رابطه‌ی هم‌شکل دارید، **باید** برچسب بزنید، وگرنه نمودار گیج‌کننده می‌شود. در پروژه‌ی ما وام هم قرض‌دهنده دارد هم قرض‌گیرنده.

### بسته‌بندی

```
package "Domain" {
  class Card
  class Transaction
}
```

### تنظیم چیدمان

```
' خطوط راست‌گوشه — در پروژه‌ی ما باعث به‌هم‌ریختگی شد، فعلاً استفاده نکنید
' skinparam linetype ortho
left to right direction
```

---

## ۳. نمودار Sequence

### عناصر

```
actor "User" as U
participant "Frontend (Next.js)" as FE
participant "Backend (NestJS)" as BE
database "Database (Prisma)" as DB
boundary "UI" as UI
control "Service" as SVC
entity "Model" as ENT
```

| نوع | شکل | کِی |
|---|---|---|
| `actor` | آدمک | کاربر واقعی |
| `participant` | مستطیل | هر نرم‌افزار/سرویس |
| `database` | استوانه | دیتابیس |
| `boundary` | مستطیل با خط | لایه‌ی رابط کاربری |
| `control` | دایره با فلش | لایه‌ی منطق |
| `entity` | دایره با خط | لایه‌ی داده |

### پیام‌ها

```
U -> FE : Enter amount
FE -> BE : POST /bank/deposits
BE -> BE : Verify token
BE --> FE : 200 + new balance
```

| نماد | معنی |
|---|---|
| `->` | درخواست / فراخوانی (خط پیوسته) |
| `-->` | پاسخ / بازگشت (خط نقطه‌چین) |
| `->>` / `-->>` | همان، ولی فلش تویی‌سر (برای async) |

> قاعده‌ی ساده: **هر چیزی که شروع می‌شود `->`، هر چیزی که برمی‌گردد `-->`.**

### بلوک‌های کنترلی

```
alt success
  BE -> DB : COMMIT
else error
  BE -> DB : ROLLBACK
end

opt موجودی کم است
  ...
end

loop برای هر قسط
  ...
end

group گروه دلخواه
  ...
end
```

| دستور | معنی |
|---|---|
| `alt` / `else` / `end` | if / else |
| `opt` / `end` | if بدون else |
| `loop` / `end` | حلقه |
| `group` / `end` | فقط برای دسته‌بندی بصری |

### فعال‌سازی (نشان دادن بازه‌ی اجرا)

```
BE -> DB : BEGIN
activate DB
DB --> BE : OK
deactivate DB
```

### شماره‌گذاری خودکار

```
autonumber
```

> این را در ابتدای فایل بگذارید تا پیام‌ها ۱، ۲، ۳... شماره بخورند. برای توضیح دادن به دیگران عالی است.

### یادداشت

```
note right of BE : اعتبارسنجی در بک‌اند، نه فقط فرم
note over BE, DB : یک تراکنش دیتابیسی
```

---

## ۴. خطاهای رایج و راه‌حل

| پیام / مشکل | علت | راه‌حل |
|---|---|---|
| `No valid diagram found here` | `@startuml`/`@enduml` نیست، یا فایل ذخیره نشده | `Ctrl+S`، بعد `Alt+D` |
| نمودار رسم می‌شود ولی چیدمان خراب | Graphviz نصب نیست | `!pragma layout smetana` در بالای فایل |
| متن فارسی برعکس/جدا می‌شود | فونت فارسی در PlantUML نصب نیست | نام‌ها را انگلیسی بنویسید (تصمیم پروژه‌ی ما) |
| Enum در یک خط شکسته نمی‌شود | از `\n` استفاده شده | هر مقدار در خط جدا |
| مسیرها ناخوانا می‌شوند | `linetype ortho` | حذفش کنید |
| فلش به جای درست وصل نمی‌شود | نام مستعار اشتباه | با `as` چک کنید |

### دستور `!pragma` برای نبود Graphviz

```
@startuml
!pragma layout smetana
...
@enduml
```

---

## ۵. قواعد پروژه‌ی ما (یادتان باشد)

1. **نام‌ها در PlantUML انگلیسی**، متن فارسی فقط در EA و داک Word.
2. **پول همیشه `Decimal`**، هرگز `float`.
3. **هر تغییر مالی یک `Transaction`** — نه جدول جدا برای واریز و برداشت.
4. **بانک شخصی = `Card` با `isBank = true`** — کلاس جدا نسازید.
5. **برداشت فقط برای قرض و سرمایه‌گذاری**؛ واریز از هر منبعی.
6. **انتقال آیتم تراکنش نمی‌سازد** → هیچ Includeای.
7. **ورود = پیش‌شرط**، نه Include.
8. **موجودی هم ذخیره می‌شود هم قابل بازمحاسبه است** (سؤال باز در داک).

---

## ۶. جایی که باید نگاه کنید

| چه می‌خواهید | کجا |
|---|---|
| همه‌ی دستورها | `plantuml.com/guide` |
| فقط sequence | `plantuml.com/sequence-diagram` |
| فقط class | `plantuml.com/class-diagram` |
| فقط use case | `plantuml.com/use-case-diagram` |
| همه‌ی `skinparam`ها | `plantuml.com/skinparam` |

---

## ۷. تمرین

1. `02-class.puml` را پاک کنید و فقط از روی `02-class.jpg` بازسازی کنید.
2. `03-sequence-deposit.puml` را پاک کنید و فقط از روی تصویر بازسازی کنید.
3. **بدون کمک**، نمودار sequence برای «برداشت از بانک شخصی» بسازید.
   تفاوت‌ها با واریز: چک موجودی کافی، و محدودیت منبع (فقط قرض/سرمایه‌گذاری).
