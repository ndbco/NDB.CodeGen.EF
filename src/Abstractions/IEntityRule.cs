using Microsoft.EntityFrameworkCore.Metadata;

namespace NDB.CodeGen.EF.Abstractions;

public interface IEntityRule
{
    bool IsView(IEntityType entity);
    bool HasActive(IEntityType entity);
    bool IsExcluded(string propertyName);
}
