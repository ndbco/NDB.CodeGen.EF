using AutoMapper;
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
    public sealed record Get{{Entity}}ListQuery(string search,PagingRequest paging) : IRequest<Result>;

    internal class Get{{Entity}}ListHandler : IRequestHandler<Get{{Entity}}ListQuery, Result>
    {
        private readonly ILogger _logger;
        private readonly IMapper _mapper;
        private readonly ApplicationDBContext _context;

        public Get{{Entity}}ListHandler(
            ILogger<Get{{Entity}}ListHandler> logger,
            IMapper mapper,
            ApplicationDBContext context)
        {
            _logger = logger;
            _mapper = mapper;
            _context = context;
        }

        public async Task<Result> Handle(Get{{Entity}}ListQuery request,CancellationToken cancellationToken)
        {
            try
            {
                var query = _context.{{Entity}}.ReadOnly();

                if (!string.IsNullOrWhiteSpace(request.search))
                    query = query.Where(x =>x.ToString()!.Trim().ToUpper().Contains(request.search.Trim().ToUpper()));

                return await query.ToPagedResultAsync<Data.Model.{{Entity}},{{Entity}}Response>(request.paging,_mapper,cancellationToken);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex,"Failed Get List {{Entity}}");
                return Result.Fail(ResultStatus.Error,$"Failed Get List {{Entity}} : {ex.Message}");
            }
        }
    }
}
