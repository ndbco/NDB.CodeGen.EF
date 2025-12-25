using NDB.CodeGen.EF.Abstractions;
using NDB.CodeGen.EF.Models;

namespace NDB.CodeGen.EF.Implementations;

public sealed class DefaultCrudTemplateProvider : ICrudTemplateProvider
{
    public IReadOnlyList<CrudTemplate> GetTemplates() => new List<CrudTemplate>()
    {
        new("Add","Command","Add{{Entity}}Handler.cs","Add.tpl",CrudType.Command),
        new("Edit","Command","Edit{{Entity}}Handler.cs","Edit.tpl",CrudType.Command),
        new("Delete","Command","Delete{{Entity}}Handler.cs","Delete.tpl",CrudType.Command),
        new("GetById","Query","Get{{Entity}}ByIdHandler.cs","GetById.tpl",CrudType.Query),
        new("GetList","Query","Get{{Entity}}ListHandler.cs","GetList.tpl",CrudType.Query),
        new("API","","{{Entity}}Controller.cs","API.tpl",CrudType.API),
    };
}
