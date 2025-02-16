using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Collections.Generic;
using WHMSystem.Models;

namespace WHMSystem.Controllers
{
    public class AdminPanelController : Controller
    {
        private readonly IHttpClientFactory _httpClientFactory;

        public AdminPanelController(IHttpClientFactory httpClientFactory)
        {
            _httpClientFactory = httpClientFactory;
        }


        public async Task<IActionResult> Index()
        {
            DashboardDto metrics = new DashboardDto();
            var client = _httpClientFactory.CreateClient();
            string apiUrl = "https://localhost:7192/api/GetDashboardMetrics";
            HttpResponseMessage response = await client.GetAsync(apiUrl);
            if (response.IsSuccessStatusCode)
            {
                string data = await response.Content.ReadAsStringAsync();
                metrics = JsonConvert.DeserializeObject<DashboardDto>(data);
            }
            return View(metrics);
        }

        public async Task<IActionResult> Product()
        {
            string apiUrl = "https://localhost:7192/api/GetAllProducts";
            var client = _httpClientFactory.CreateClient();

            HttpResponseMessage response = await client.GetAsync(apiUrl);

            if (response.IsSuccessStatusCode)
            {
                string data = await response.Content.ReadAsStringAsync();
                var products = JsonConvert.DeserializeObject<List<ProductDto>>(data);
                return View(products);
            }

            return View(new List<ProductDto>());
        }

        public async Task<IActionResult> UpdateProduct(int id)
        {
            string apiUrl = $"https://localhost:7192/api/GetProductById/{id}";
            var client = _httpClientFactory.CreateClient();

            HttpResponseMessage response = await client.GetAsync(apiUrl);
            if (response.IsSuccessStatusCode)
            {
                string data = await response.Content.ReadAsStringAsync();
                var product = JsonConvert.DeserializeObject<ProductDto>(data);
                return View(product);
            }

            return NotFound();
        }

        [HttpPost]
        public async Task<IActionResult> UpdateProduct(ProductDto product)
        {
            if (!ModelState.IsValid)
            {
                TempData["ErrorMessage"] = "Invalid input! Please check the fields.";
                return View(product);
            }

            string apiUrl = "https://localhost:7192/api/UpdateProduct";
            var jsonData = JsonConvert.SerializeObject(product);
            var content = new StringContent(jsonData, Encoding.UTF8, "application/json");

            var client = _httpClientFactory.CreateClient();
            HttpResponseMessage response = await client.PutAsync(apiUrl, content);

            if (response.IsSuccessStatusCode)
            {
                TempData["SuccessMessage"] = "Product updated successfully!";
                return RedirectToAction("Product");
            }
            else
            {
                string errorMessage = await response.Content.ReadAsStringAsync();
                TempData["ErrorMessage"] = "Failed to update product. " + errorMessage;
            }

            return View(product);
        }

        [HttpGet]
        public async Task<IActionResult> AddProduct()
        {
            string apiUrl = "https://localhost:7192/api/GetAllProducts";
            var client = _httpClientFactory.CreateClient();

            HttpResponseMessage response = await client.GetAsync(apiUrl);

            List<ProductDto> products = new List<ProductDto>();

            if (response.IsSuccessStatusCode)
            {
                string data = await response.Content.ReadAsStringAsync();
                products = JsonConvert.DeserializeObject<List<ProductDto>>(data);
            }

            ViewBag.ExistingProducts = products.Select(p => p.ProductTypeName).Distinct().ToList();
            return View();
        }

        [HttpPost]
        public async Task<IActionResult> AddProduct(AddProductDto product)
        {
            if (string.IsNullOrWhiteSpace(product.ProductCode))
            {
                TempData["ErrorMessage"] = "Product Code is required.";
                return RedirectToAction("AddProduct");
            }

            if (string.IsNullOrWhiteSpace(product.ProductName))
            {
                TempData["ErrorMessage"] = "Please select or enter a Product Name.";
                return RedirectToAction("AddProduct");
            }

            string apiUrl = "https://localhost:7192/api/AddProduct";
            var jsonData = JsonConvert.SerializeObject(product);
            var content = new StringContent(jsonData, Encoding.UTF8, "application/json");

            var client = _httpClientFactory.CreateClient();
            HttpResponseMessage response = await client.PostAsync(apiUrl, content);

            if (response.IsSuccessStatusCode)
            {
                TempData["SuccessMessage"] = "Product added successfully!";
                return RedirectToAction("Product");
            }
            else
            {
                string errorMessage = await response.Content.ReadAsStringAsync();
                TempData["ErrorMessage"] = "Failed to add product. " + errorMessage;
                return RedirectToAction("AddProduct");
            }
        }

        [HttpGet]
        public async Task<IActionResult> DeleteProduct(int id)
        {
            string apiUrl = $"https://localhost:7192/api/DeleteProduct/{id}";
            var client = _httpClientFactory.CreateClient();

            HttpResponseMessage response = await client.DeleteAsync(apiUrl);

            if (response.IsSuccessStatusCode)
            {
                TempData["SuccessMessage"] = "Product ID" + " " + id + " " + ",Deleted Successfully!";
            }
            else
            {
                TempData["ErrorMessage"] = "Failed to delete product.";
            }

            return RedirectToAction("Product");
        }



        public async Task<IActionResult> OrdersRequest()
        {
            string apiUrl = "https://localhost:7192/api/getAllOrders";
            var client = _httpClientFactory.CreateClient();

            HttpResponseMessage response = await client.GetAsync(apiUrl);

            if (response.IsSuccessStatusCode)
            {
                string data = await response.Content.ReadAsStringAsync();
                var products = JsonConvert.DeserializeObject<List<GetAllOrdersRequestDto>>(data);
                return View(products);
            }

            return View(new List<GetAllOrdersRequestDto>());
        }

    }
}
