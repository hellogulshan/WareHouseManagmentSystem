using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using System.Data;
using Dapper;
using WHMSystem.Models;

namespace WHMSystem.Controllers
{
   
    [ApiController]
    public class DashboardAPIController : ControllerBase
    {
        private readonly IConfiguration _configuration;

        public DashboardAPIController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        //https://localhost:7192/api/GetDashboardMetrics
        [HttpGet]
        [Route("api/GetDashboardMetrics")]
        public async Task<IActionResult> GetDashboardMetrics()
        {
            try
            {
                using (var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection")))
                {
                    var metrics = await connection.QueryFirstOrDefaultAsync<DashboardDto>("pr_GetDashboardMetrics",
                        commandType: CommandType.StoredProcedure
                    );

                    if (metrics == null)
                    {
                        return NotFound(new { message = "Dashboard metrics not found." });
                    }

                    return Ok(metrics);
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { error = ex.Message });
            }
        }
    }
}
