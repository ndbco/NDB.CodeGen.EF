using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;
using NDB.CodeGen.EF.Abstractions;

namespace NDB.CodeGen.EF.Implementations;

public sealed class DefaultEntityRule : IEntityRule
{
    private static readonly HashSet<string> Excluded =
        new(StringComparer.OrdinalIgnoreCase)
        {
            "id","active","isactive","isdeleted",
            "createby","create_by","createdby","created_by",
            "createdate","create_date",
            "updateby","update_by","updatedby","updated_by",
            "updatedate","update_date"
        };

    public bool IsView(IEntityType entity)
        => entity.GetViewName() != null || entity.GetViewSchema() != null;

    public bool HasActive(IEntityType entity)
        => entity.GetProperties()
            .Any(p => p.Name.Equals("Active", StringComparison.OrdinalIgnoreCase));

    public bool IsExcluded(string propertyName)
        => Excluded.Contains(propertyName);
}
