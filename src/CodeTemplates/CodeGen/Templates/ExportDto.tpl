using AutoMapper;
using {{ns}}.Core.Response;
using NDB.Kit.Mapping;
using NDB.Kit.Excel;

namespace {{ns}}.Core.Export
{
    public partial class {{Entity}}ExportDto : IMapObject<{{Entity}}Response, {{Entity}}ExportDto>
    {
{{ExportAttributes}}

        public void Mapping(IMappingExpression<{{Entity}}Response, {{Entity}}ExportDto> map)
        {
            //custom mapping here
            //map.ForMember(d => d.object, opt => opt.MapFrom(s => s.EF_COLUMN));
        }
    }
}