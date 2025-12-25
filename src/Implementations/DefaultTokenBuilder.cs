using Microsoft.EntityFrameworkCore.Metadata;
using NDB.CodeGen.EF.Abstractions;
using NDB.CodeGen.EF.Utilities;

namespace NDB.CodeGen.EF.Implementations;

public sealed class DefaultTokenBuilder : ITokenBuilder
{
    private readonly IAttributeBuilder _attr;
    private readonly IEntityRule _rule;

    public DefaultTokenBuilder(
        IAttributeBuilder attr,
        IEntityRule rule)
    {
        _attr = attr;
        _rule = rule;
    }

    public Dictionary<string, string> Build(
        IEntityType entity,
        string contextNs,
        string modelNs)
    {
        var pk = entity.TryGetPrimaryKeyProperty();
        string namespaces = contextNs;
        int index_namespace = contextNs.LastIndexOf('.');
        if (index_namespace >=0)
            namespaces= contextNs.Substring(0, index_namespace);
        return new()
        {
            ["ns"] = namespaces,
            ["modelNs"] = modelNs,
            ["Entity"] = entity.Name,
            ["PkName"] = pk?.Name ?? "",
            ["PkType"] = _attr.ParseType(pk?.Type),
            ["AddAttributes"] = _attr.BuildAdd(entity),
            ["EditAttributes"] = _attr.BuildEdit(entity),
            ["RequestAttributes"] = _attr.BuildRequest(entity),
            ["ResponseAttributes"] = _attr.BuildResponse(entity),
            ["ContractAttributes"] = _attr.BuildContract(entity),
            ["ExportAttributes"] = _attr.BuildExport(entity),
            ["Block"] = _rule.HasActive(entity) ? "true" : "false",
            ["IsView"] = _rule.IsView(entity) ? "true" : "false"
        };
    }
}
