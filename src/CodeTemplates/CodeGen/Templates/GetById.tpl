using AutoMapper;
using {{ns}}.Core.Response;
using {{ns}}.Data;
using NDB.Audit.EF.Extensions;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using NDB.Abstraction.Results;

namespace {{ns}}.Core.{{Entity}}.Query
{
    public sealed record Get{{Entity}}ByIdQuery({{PkType}} {{PkName}}) : IRequest<Result>;

    internal class Get{{Entity}}ByIdHandler : IRequestHandler<Get{{Entity}}ByIdQuery, Result>
    {
        private readonly ILogger _logger;
        private readonly IMapper _mapper;
        private readonly ApplicationDBContext _db;

        public Get{{Entity}}ByIdHandler(
            ILogger<Get{{Entity}}ByIdHandler> logger,
            IMapper mapper,
            ApplicationDBContext db)
        {
            _logger = logger;
            _mapper = mapper;
            _db = db;
        }

        public async Task<Result> Handle(Get{{Entity}}ByIdQuery request,CancellationToken cancellationToken)
        {
            try
            {
                var entity = await _db.{{Entity}}.ReadOnly().FirstOrDefaultAsync(x => x.{{PkName}} == request.{{PkName}},cancellationToken);

                if (entity == null)
                    return Result.Fail(ResultStatus.NotFound,"{{Entity}} not found");

                var dto = _mapper.Map<{{Entity}}Response>(entity);
                return Result<{{Entity}}Response>.Ok(dto);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex,"Failed Get {{Entity}} By Id");
                return Result.Fail(ResultStatus.Error,$"Failed Get {{Entity}} : {ex.Message}");
            }
        }
    }
}
