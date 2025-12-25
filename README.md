# NDB.CodeGen.EF

`NDB.CodeGen.EF` is an **EF Core + Handlebars based design-time code generator** that helps you generate:

- Entity models
- DbContext
- CRUD (Command / Query)
- API / Handlers
- DTOs / Contracts

with **extensible and overridable templates**, without forking the library.

---

## Key Features

- EF Core Design-Time Code Generator
- Built on `EntityFrameworkCore.Scaffolding.Handlebars`
- Default templates embedded in `NDB.CodeGen.EF`
- **Partial template override from host project**
- Customizable:
  - Handlebars templates (`.hbs`)
  - Rules
  - Attribute builders
  - Token builders
- NuGet-ready
- CI / Docker friendly

---
## Installation

```bash
dotnet add package NDB.CodeGen.EF
```

## Prerequisites

- .NET SDK 8.0+
- EF Core 8.x
- SQL Server (or any EF Core supported provider)

---

## Install `dotnet-ef` Tool

Right click on project **`Inchcape.PDS.Data`**,  
choose **Open in Terminal**, then run:

```powershell
dotnet tool install --global dotnet-ef
````

or if already installed:

```powershell
dotnet tool update --global dotnet-ef
```

Verify installation:

```powershell
dotnet ef --version
```

---

## Recommended Project Structure

```text
Data
│
├─ Model/                         ← Scaffolded entity models
│
├─ CodeGen/
│  └─ CodeGenerator.cs            ← Design-time registration (REQUIRED)
│
├─ CodeTemplates/                 ← Optional host overrides
│  └─ Handlebars/
│     └─ CSharpEntityType.hbs     ← Example override
│
├─ ApplicationDbContext.cs
└─ Inchcape.PDS.Data.csproj
```

---

## ⚙Design-Time Setup (Required)

`NDB.CodeGen.EF` requires **design-time registration in the host project**.

You must create a class that implements `IDesignTimeServices`.

### Example: `CodeGen/CodeGenerator.cs`

```csharp
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using EntityFrameworkCore.Scaffolding.Handlebars;
using NDB.CodeGen.EF.Engine;
using NDB.CodeGen.EF.Implementations;
using NDB.CodeGen.EF.Generators;

public sealed class CodeGenerator : IDesignTimeServices
{
    public void ConfigureDesignTimeServices(IServiceCollection services)
    {
        services.AddHandlebarsScaffolding();

        services.AddSingleton<IEntityRule, DefaultEntityRule>();
        services.AddSingleton<IAttributeBuilder, DefaultAttributeBuilder>();
        services.AddSingleton<ITokenBuilder, DefaultTokenBuilder>();
        services.AddSingleton<ITemplateProvider, EmbeddedTemplateProvider>();
        services.AddSingleton<ICrudTemplateProvider, DefaultCrudTemplateProvider>();
        services.AddSingleton<CrudTemplateEngine>();

#pragma warning disable EF1001
        services.Replace(
            ServiceDescriptor.Singleton<ICSharpDbContextGenerator, DbContextCodeGenerator>());
#pragma warning restore EF1001
    }
}
```

> This file **must exist in the host project**
> EF Core does not reliably load `IDesignTimeServices` from class libraries.

---

## Sample Code (Copy & Paste)

A complete working example is provided in:

```text
src/Sample/
```

Inside the sample you will find:

* `CodeTemplates/CodeGen/CodeGenerator.cs`
* Example template overrides
* Ready-to-copy setup

Simply copy the contents into your host project and adjust namespaces if needed.

---

## Scaffolding Command Example

Run the following command from the **host project directory**:

```powershell
dotnet ef dbcontext scaffold "Data Source=[HOST];Initial Catalog=[YOURDB];User Id=[USERNAME];Password=[PASSWORD];
TrustServerCertificate=Yes" Microsoft.EntityFrameworkCore.SqlServer
--output-dir "Model" 
-c ApplicationDBContext 
--context-dir "." 
--namespace "Inchcape.Data.Model" 
--context-namespace "Inchcape.Data" 
--no-pluralize 
--no-onconfiguring
-f
```

### What this does

* Entity models generated into `Model/`
* `ApplicationDBContext` generated at project root
* Custom code generation (CRUD, API, etc.) executed automatically
* Templates resolved in this order:

  1. Host `CodeTemplates`
  2. Embedded templates from `NDB.CodeGen.EF`
  3. Default Handlebars templates

---

## Template Override (Optional)

To override a specific template, add it to the host project:

```text
CodeTemplates/
└─ Handlebars/
   └─ CSharpEntityType.hbs
```

Only the overridden template will be used.
All other templates fall back to the defaults.

---

## Summary

* `NDB.CodeGen.EF` handles **generation logic**
* Host project controls **design-time registration**
* Templates are **override-friendly**
* No need to fork or copy the generator

---
