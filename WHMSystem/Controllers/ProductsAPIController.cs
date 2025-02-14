using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System.Data;
using WHMSystem.Models;
using Dapper;


namespace WHMSystem.Controllers
{
    [ApiController]
    public class ProductsAPIController : ControllerBase
    {
        private readonly WhmsDbContext context;
        private readonly IConfiguration _configuration;
        public ProductsAPIController(WhmsDbContext _context, IConfiguration configuration)
        {
            this.context = _context;
            _configuration = configuration;
        }


        //Get All Products
        //https://localhost:7192/api/GetAllProducts
        [HttpGet]
        [Route("api/GetAllProducts")]
        public async Task<ActionResult<List<Product>>> GetAllProducts()
        {
            var data = await context.ProductDto
           .FromSqlRaw("exec dbo.pr_GetAllProducts")
           .ToListAsync();

            if (data == null || data.Count == 0)
            {
                return NotFound("No products found.");
            }

            return Ok(data);
        }

        // Get a specific product by ID
        // https://localhost:7192/api/GetProductById/{id}
        [HttpGet]
        [Route("api/GetProductById/{id}")]
        public async Task<ActionResult<ProductDto>> GetProductById(int id)
        {
            var data = await context.ProductDto
               .FromSqlRaw("EXEC dbo.pr_GetProductById @p0", id)
               .ToListAsync();

            if (data == null || data.Count == 0)
            {
                return NotFound($"No product found with ID {id}");
            }

            return Ok(data.FirstOrDefault()); // Return single product
        }


        // Update Product API
        [HttpPut]
        [Route("api/UpdateProduct")]
        public async Task<IActionResult> UpdateProduct([FromBody] ProductDto product)
        {
            if (product == null || product.ProductId <= 0)
            {
                return BadRequest(new { message = "Invalid product data." });
            }

            try
            {
                var rowsAffectedParam = new Microsoft.Data.SqlClient.SqlParameter
                {
                    ParameterName = "@RowsAffected",
                    SqlDbType = System.Data.SqlDbType.Int,
                    Direction = System.Data.ParameterDirection.Output
                };

                await context.Database.ExecuteSqlRawAsync(
                    "EXEC dbo.pr_UpdateProduct @p0, @p1, @p2, @p3, @p4, @p5, @p6, @RowsAffected OUTPUT",
                    product.ProductId, 
                    product.ProductCode, 
                    product.ProductName,
                    product.WarrantyDate, 
                    product.ProductTypeID, 
                    product.ProductTypeName,
                    product.CurrentQuantity, 
                    rowsAffectedParam
                );

                int rowsAffected = (int)rowsAffectedParam.Value;

                if (rowsAffected > 0)
                {
                    return Ok(new { message = "Product updated successfully!" });
                }
                else
                {
                    return NotFound(new { message = "No changes were made. Either the product was not found or validation failed." });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while updating the product.", error = ex.Message });
            }
        }



        [HttpPost]
        [Route("api/AddProduct")]
        public async Task<IActionResult> AddProduct([FromBody] AddProductDto product)
        {
            // 🔹 Validate that no field is empty, null, or invalid
            if (string.IsNullOrWhiteSpace(product.ProductCode) ||
                string.IsNullOrWhiteSpace(product.ProductName) ||
                string.IsNullOrWhiteSpace(product.ProductTypeName) ||
                product.CurrentQuantity <= 0 ||
                product.WarrantyDate == null)
            {
                return BadRequest(new { message = "All fields are required and cannot be empty." });
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(_configuration.GetConnectionString("DefaultConnection")))
                {
                    await conn.OpenAsync();

                    // 🔹 Check if ProductCode already exists
                    using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Products WHERE ProductCode = @ProductCode", conn))
                    {
                        checkCmd.Parameters.AddWithValue("@ProductCode", product.ProductCode);
                        int existingCount = (int)await checkCmd.ExecuteScalarAsync();

                        if (existingCount > 0)
                        {
                            return BadRequest(new { message = "Give a new ProductCode, it already exists." });
                        }
                    }

                    // 🔹 Insert Product if all validations pass
                    using (SqlCommand cmd = new SqlCommand("pr_AddNewProduct", conn))
                    {
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Parameters.AddWithValue("@ProductCode", product.ProductCode);
                        cmd.Parameters.AddWithValue("@ProductName", product.ProductName);
                        cmd.Parameters.AddWithValue("@WarrantyDate", product.WarrantyDate); // Now required
                        cmd.Parameters.AddWithValue("@ProductTypeName", product.ProductTypeName);
                        cmd.Parameters.AddWithValue("@CurrentQuantity", product.CurrentQuantity);

                        await cmd.ExecuteNonQueryAsync();
                    }
                }

                return Ok(new { message = "Product added successfully!" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = "An error occurred while adding the product.", error = ex.Message });
            }
        }



        [HttpDelete]
        [Route("api/DeleteProduct/{id}")]
        
        public async Task<IActionResult> DeleteProduct(int id)
        {
            using (var connection = new SqlConnection(_configuration.GetConnectionString("DefaultConnection")))
            {
                await connection.OpenAsync();

                var parameters = new DynamicParameters();
                parameters.Add("@ProductID", id);

                // Capture RowsAffected from stored procedure
                var result = await connection.ExecuteScalarAsync<int>("pr_DeleteProductById", parameters, commandType: CommandType.StoredProcedure);

                if (result > 0)
                {
                    return Ok(new { message = "Product deleted successfully." });
                }
                else if (result == 0)
                {
                    return NotFound(new { message = "Product not found." });
                }
                else
                {
                    return BadRequest(new { message = "Error occurred while deleting product." });
                }
            }
        }






    }
}
