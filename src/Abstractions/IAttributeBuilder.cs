using Microsoft.EntityFrameworkCore.Metadata;

namespace NDB.CodeGen.EF.Abstractions;

public interface IAttributeBuilder
{
    string BuildAdd(IEntityType entity);
    string BuildEdit(IEntityType entity);
    string BuildRequest(IEntityType entity);
    string BuildResponse(IEntityType entity);
    string BuildContract(IEntityType entity);
    string BuildExport(IEntityType entity);
    string ParseType(Type? clrType);
}
