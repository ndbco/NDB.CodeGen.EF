using Microsoft.EntityFrameworkCore.Metadata;
using NDB.CodeGen.EF.Abstractions;
using NDB.CodeGen.EF.Utilities;

namespace NDB.CodeGen.EF.Engine;

public sealed class CrudTemplateEngine
{
    private readonly ICrudTemplateProvider _templates;
    private readonly ITemplateProvider _templateProvider;
    private readonly ITokenBuilder _tokenBuilder;
    private readonly IEntityRule _rule;

    public CrudTemplateEngine(
        ICrudTemplateProvider templates,
        ITemplateProvider templateProvider,
        ITokenBuilder tokenBuilder,
        IEntityRule rule)
    {
        _templates = templates;
        _templateProvider = templateProvider;
        _tokenBuilder = tokenBuilder;
        _rule = rule;
    }

    public void Generate(
        IEntityType entity,
        string contextNs,
        string modelNs,
        string basePath)
    {
        var tokens = _tokenBuilder.Build(entity, contextNs, modelNs);

        foreach (var tpl in _templates.GetTemplates())
        {
            if (_rule.IsView(entity) && tpl.Type == Models.CrudType.Command)
                continue;

            var template = _templateProvider.Load(tpl.TemplateFile);
            var content = TemplateRenderer.Render(template, tokens);

            var dir = Path.Combine(basePath, "Generated", entity.Name, tpl.Folder);
            Directory.CreateDirectory(dir);

            var file = tpl.FilePattern.Replace("{{Entity}}", entity.Name);
            File.WriteAllText(Path.Combine(dir, file), content);
        }
    }
}
