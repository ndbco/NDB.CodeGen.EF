using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace NDB.CodeGen.EF.Utilities;

internal static class EfEntityExtensions
{
    public static string GetEntityName(this IEntityType entity)
        => entity.GetTableName() ?? entity.Name.Split('.').Last();
    public static (string Name, Type Type)? TryGetPrimaryKeyProperty(this IEntityType entity)
    {
        var pk = entity.FindPrimaryKey();
        if (pk == null)
            return null;

        var prop = pk.Properties.First();
        return (prop.Name, prop.ClrType);
    }
}
