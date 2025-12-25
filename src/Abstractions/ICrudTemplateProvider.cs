using NDB.CodeGen.EF.Models;

namespace NDB.CodeGen.EF.Abstractions;

public interface ICrudTemplateProvider
{
    IReadOnlyList<CrudTemplate> GetTemplates();
}
