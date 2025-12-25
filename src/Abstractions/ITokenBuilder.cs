using Microsoft.EntityFrameworkCore.Metadata;

namespace NDB.CodeGen.EF.Abstractions;

public interface ITokenBuilder
{
    Dictionary<string, string> Build(
        IEntityType entity,
        string contextNs,
        string modelNs);
}
