using AutoMapper;
using {{ns}}.Core.Contract;
using {{ns}}.Core.Response;
using {{ns}}.Data;
using NDB.Audit.EF.Extensions;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using NDB.Abstraction.Requests;
using NDB.Abstraction.Results;
using NDB.Kit.Ef;

namespace {{ns}}.Core.{{Entity}}.Query
{
    public sealed record Get{{Entity}}PagedQuery(ListRequest Request) : IRequest<Result>;

    internal class Get{{Entity}}PagedHandler : IRequestHandler<Get{{Entity}}PagedQuery, Result>
    {
        private readonly ILogger _logger;
        private readonly IMapper _mapper;
        private readonly ApplicationDBContext _context;

        public Get{{Entity}}PagedHandler(
            ILogger<Get{{Entity}}PagedHandler> logger,
            IMapper mapper,
            ApplicationDBContext context)
        {
            _logger = logger;
            _mapper = mapper;
            _context = context;
        }

        public async Task<Result> Handle(Get{{Entity}}PagedQuery request,CancellationToken cancellationToken)
        {
            try
            {
                var query = _context.{{Entity}}.ReadOnly()
                    .ApplySearch(request.Request.Search,{{Entity}}ListContract.AllowedFields)
                    .ApplyFilters(request.Request.Filters,{{Entity}}ListContract.AllowedFields)
                    .ApplySorts(request.Request.Sorts,{{Entity}}ListContract.AllowedFields);

                return await query.ToPagedResultAsync<Data.Model.{{Entity}},{{Entity}}Response>(request.Request.Paging,_mapper,cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex,"Failed Get Paged {{Entity}}");
                return Result.Fail(ResultStatus.Error,$"Failed Get Paged {{Entity}} : {ex.Message}");
            }
        }
    }
}