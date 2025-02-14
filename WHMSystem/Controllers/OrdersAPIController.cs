using System;
using System.Data;
using Dapper;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System.Threading.Tasks;
using WHMSystem.Models;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;

namespace WHMSystem.Controllers
{
    
    [ApiController]
    public class OrdersAPIController : ControllerBase
    {
        private readonly IConfiguration _configuration;
        private readonly WhmsDbContext context;

        public OrdersAPIController(IConfiguration configuration, WhmsDbContext context)
        {
            _configuration = configuration;
            this.context = context;
        }


        //https://localhost:7192/api/placeOrder

        [HttpPost]
        [Route("api/placeOrder")] 
        public async Task<IActionResult> AddOrder([FromBody] OrderRequest orderRequest)
        {
            if (orderRequest == null || string.IsNullOrEmpty(orderRequest.ProductCode) ||
                string.IsNullOrEmpty(orderRequest.CustomerName) ||
                string.IsNullOrEmpty(orderRequest.CustomerAddress) ||
                orderRequest.DeliveryOptionId <= 0 || orderRequest.OrderQuantity <= 0)
            {
                return BadRequest("Invalid order request. Please provide valid order details.");
            }

            try
            {
                using (var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection")))
                {
                    var parameters = new DynamicParameters();
                    parameters.Add("@orderDate", orderRequest.OrderDate ?? DateTime.Now, DbType.Date); // Default to current date if null
                    parameters.Add("@customerName", orderRequest.CustomerName, DbType.String);
                    parameters.Add("@customerAddress", orderRequest.CustomerAddress, DbType.String);
                    parameters.Add("@deliveryOptionId", orderRequest.DeliveryOptionId, DbType.Int32);
                    parameters.Add("@productCode", orderRequest.ProductCode, DbType.String);
                    parameters.Add("@orderQuantity", orderRequest.OrderQuantity, DbType.Int32);

                    await connection.ExecuteAsync("pr_InsertOrder", parameters, commandType: CommandType.StoredProcedure);

                    return Ok(new { Message = "Order placed successfully." });
                }
            }
            catch (SqlException sqlEx)
            {
                return StatusCode(500, new { Error = "Database Error", Details = sqlEx.Message });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { Error = "Internal Server Error", Details = ex.Message });
            }
        }


        [HttpGet]
        [Route("api/getAllOrders")]
        public async Task<ActionResult<List<Product>>> GetAllPlacedOrders()
        {
            var data = await context.GetAllOrdersRequestDto
           .FromSqlRaw("exec dbo.pr_getAllOrders")
           .ToListAsync();

            if (data == null || data.Count == 0)
            {
                return NotFound("No products found.");
            }

            return Ok(data);
        }
    }
}
