using EntityFrameworkCore.Scaffolding.Handlebars;
using EntityFrameworkCore.Scaffolding.Handlebars.Internal;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;
using NDB.CodeGen.EF.Abstractions;
using NDB.CodeGen.EF.Engine;
using NDB.CodeGen.EF.Generators;
using NDB.CodeGen.EF.Implementations;

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



