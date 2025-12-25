using EntityFrameworkCore.Scaffolding.Handlebars;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Scaffolding;
using Microsoft.Extensions.Options;
using NDB.CodeGen.EF.Engine;

namespace NDB.CodeGen.EF.Generators;

public sealed class DbContextCodeGenerator : HbsCSharpDbContextGenerator
{
    private readonly CrudTemplateEngine _engine;

    public DbContextCodeGenerator(
        IProviderConfigurationCodeGenerator provider,
        IAnnotationCodeGenerator annotation,
        IDbContextTemplateService template,
        IEntityTypeTransformationService transform,
        ICSharpHelper csharp,
        IOptions<HandlebarsScaffoldingOptions> options,
        CrudTemplateEngine engine)
        : base(provider, annotation, template, transform, csharp, options)
    {
        _engine = engine;
    }

    protected override void GenerateClass(
        IModel model,
        string contextName,
        string connectionString,
        bool suppressConnectionStringWarning,
        bool suppressOnConfiguring)
    {
        base.GenerateClass(
            model,
            contextName,
            connectionString,
            suppressConnectionStringWarning,
            suppressOnConfiguring);
        if (!TemplateData.TryGetValue("namespace", out var ns))
            throw new InvalidOperationException("Namespace not found");

        var contextNs = ns!.ToString()!;
        var modelNs = $"{contextNs}.Model";
        var basePath = Directory.GetCurrentDirectory();

        foreach (var entity in model.GetEntityTypes())
        {
            _engine.Generate(entity, contextNs, modelNs, basePath);
        }
    }
}
