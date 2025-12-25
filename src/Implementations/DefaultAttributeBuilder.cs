using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using NDB.CodeGen.EF.Abstractions;
using System.ComponentModel.DataAnnotations;

namespace NDB.CodeGen.EF.Implementations;

public sealed class DefaultAttributeBuilder : IAttributeBuilder
{
    private readonly IEntityRule _entityRule;
    public DefaultAttributeBuilder(IEntityRule entityRule)
    {
        _entityRule = entityRule;
    }
    public string BuildAdd(IEntityType entity)
        => Build(entity, p => $"                    {p.Name} = request.{p.Name},");

    public string BuildEdit(IEntityType entity)
        => Build(entity, p => $"                item.{p.Name} = request.{p.Name};");

    public string BuildContract(IEntityType entity)
        => string.Join(Environment.NewLine,
            entity.GetProperties().OrderBy(p => p.GetColumnOrder() ?? int.MaxValue)
                .Select(p => $"              nameof(Data.Model.{entity.Name}.{p.Name}),"));

    public string BuildResponse(IEntityType entity)
        => string.Join(Environment.NewLine,
            entity.GetProperties().OrderBy(p => p.GetColumnOrder() ?? int.MaxValue)
                .Select(p =>
                {
                    var t = ParseType(p.ClrType);
                    var n = p.IsNullable && t != "string" ? "?" : "";
                    return $"        public {t}{n} {p.Name} {{ get; set; }}";
                }));

    public string BuildRequest(IEntityType entity)
    {
        var lines = new List<string>();
        foreach (var p in entity.GetProperties().OrderBy(p => p.GetColumnOrder() ?? int.MaxValue))
        {
            if (_entityRule.IsExcluded(p.Name))
                continue;

            if (!p.IsNullable)
                lines.Add("        [Required]");

            var t = ParseType(p.ClrType);
            var n = p.IsNullable && t != "string" ? "?" : "";
            lines.Add($"        public {t}{n} {p.Name} {{ get; set; }}");
        }
        return string.Join(Environment.NewLine, lines);
    }

    public string BuildExport(IEntityType entity)
    {
        var i = 1;
        var lines = new List<string>();
        foreach (var p in entity.GetProperties().OrderBy(p => p.GetColumnOrder() ?? int.MaxValue))
        {
            var t = ParseType(p.ClrType);
            var n = p.IsNullable && t != "string" ? "?" : "";
            lines.Add($"        [ExcelColumn(\"{p.Name}\", Order = {i++})]");
            lines.Add($"        public {t}{n} {p.Name} {{ get; set; }}");
        }
        return string.Join(Environment.NewLine, lines);
    }

    public string ParseType(Type? clrType)
    {
        if (clrType == null)
            return "object";

        var t = Nullable.GetUnderlyingType(clrType) ?? clrType;
        if (t == typeof(Guid)) return "Guid";
        if (t == typeof(bool)) return "bool";
        if (t == typeof(DateTime)) return "DateTime";
        if (t == typeof(decimal)) return "decimal";
        if (t == typeof(int)) return "int";
        if (t == typeof(long)) return "long";
        if (t == typeof(string)) return "string";
        return t.Name;
    }

    private string Build(
        IEntityType entity,
        Func<IProperty, string> map)
        => string.Join(Environment.NewLine,
            entity.GetProperties().Where(p => !_entityRule.IsExcluded(p.Name))
              .OrderBy(p => p.GetColumnOrder() ?? int.MaxValue).Select(map));
}
