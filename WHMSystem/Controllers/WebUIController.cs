using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Net.Http;
using System.Threading.Tasks;
using System.Collections.Generic;
using WHMSystem.Models;
using System.Text;

namespace WHMSystem.Controllers
{
    public class WebUIController : Controller
    {
        private readonly HttpClient _httpClient;

        public WebUIController(IHttpClientFactory httpClientFactory)
        {
            _httpClient = httpClientFactory.CreateClient();
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            string apiUrl = "https://localhost:7192/api/GetAllProducts";

            HttpResponseMessage response = await _httpClient.GetAsync(apiUrl);

            if (response.IsSuccessStatusCode)
            {
                string data = await response.Content.ReadAsStringAsync();
                var products = JsonConvert.DeserializeObject<List<ProductDto>>(data);
                return View(products);
            }

            return View(new List<ProductDto>());
        }

        //Load the Place Order Page with Product Details
        [HttpGet]
        public async Task<IActionResult> Place_Order(int id)
        {
            string apiUrl = $"https://localhost:7192/api/GetProductById/{id}";

            HttpResponseMessage response = await _httpClient.GetAsync(apiUrl);
            if (response.IsSuccessStatusCode)
            {
                string data = await response.Content.ReadAsStringAsync();
                var product = JsonConvert.DeserializeObject<PlaceOrderDto>(data);
                return View(product);
            }

            return NotFound();
        }

        [HttpPost]
        public async Task<IActionResult> Place_Order(OrderRequest orderRequest)
        {
            if (orderRequest == null || orderRequest.OrderQuantity <= 0)
            {
                TempData["ErrorMessage"] = "Invalid order details!";
                return RedirectToAction("Index");
            }

            try
            {
                string apiUrl = "https://localhost:7192/api/placeOrder";
                var jsonContent = JsonConvert.SerializeObject(orderRequest);
                var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

                HttpResponseMessage response = await _httpClient.PostAsync(apiUrl, content);

                if (response.IsSuccessStatusCode)
                {
                    TempData["SuccessMessage"] = "Order placed successfully!";
                    return RedirectToAction("Index");
                }
                else
                {
                    string errorResponse = await response.Content.ReadAsStringAsync();
                    TempData["ErrorMessage"] = $"Error: {errorResponse}";
                }
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = $"An error occurred: {ex.Message}";
            }

            return RedirectToAction("Index");
        }
    }
}

