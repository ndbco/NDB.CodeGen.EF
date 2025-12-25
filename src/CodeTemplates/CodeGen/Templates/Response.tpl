using AutoMapper;
using {{ns}}.Data.Model;
using NDB.Kit.Mapping;

namespace {{ns}}.Core.Response
{
    public partial class {{Entity}}Response : IMapFrom<{{Entity}}Response, Data.Model.{{Entity}}>
    {
{{ResponseAttributes}}

        public void Mapping(IMappingExpression<Data.Model.{{Entity}}, {{Entity}}Response> map)
        {
            //custom mapping here
            //map.ForMember(d => d.object, opt => opt.MapFrom(s => s.EF_COLUMN));
        }
    }
}
