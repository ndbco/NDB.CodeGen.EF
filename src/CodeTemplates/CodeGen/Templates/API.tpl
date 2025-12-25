using Azure.Core;
using {{ns}}.Core.Request;
using {{ns}}.Core.{{Entity}}.Command;
using {{ns}}.Core.{{Entity}}.Query;
using MediatR;
using Microsoft.AspNetCore.Mvc;
using NDB.Abstraction.Requests;
using NDB.Abstraction.Results;

namespace {{ns}}.API.Controllers
{
    public partial class {{Entity}}Controller : BaseController<{{Entity}}Controller>
    {
        [HttpGet(template: "get/{id}")]
        public async Task<Result> Get({{PkType}} id)=> await _mediator.Send(new Get{{Entity}}ByIdQuery(id));

        [HttpGet(template: "list")]
        public async Task<Result> List(string search, int? page, int? page_size) =>
                await _mediator.Send(new Get{{Entity}}ListQuery(search, new PagingRequest() { Page = page ?? 1, PageSize = page_size ?? 20 }));

        [HttpPost(template: "list_page")]
        public async Task<Result> ListPage([FromBody] ListRequest request) => await _mediator.Send(new Get{{Entity}}PagedQuery(request));

        [HttpPost(template: "export")]
        public async Task<Result> Export([FromBody] ListRequest request) => await _mediator.Send(new Export{{Entity}}Query(request));
        [HttpPost(template: "add")]
        public async Task<Result> Add([FromBody] Add{{Entity}}Command command) => await _mediator.Send(command); 

        [HttpPut(template: "edit")]
        public async Task<Result> Edit([FromBody] Edit{{Entity}}Command command) => await _mediator.Send(command);

        [HttpDelete(template: "delete/{id}")]
        public async Task<Result> Delete({{PkType}} id)=> await _mediator.Send(new Delete{{Entity}}Command(id));
{{>block}}                  
        [HttpPut(template: "active/{id}/{value}")]
        public async Task<Result> Active({{PkType}} id, bool value) => await _mediator.Send(new Active{{Entity}}Command(id, value));
{{<block}}
    }
}

