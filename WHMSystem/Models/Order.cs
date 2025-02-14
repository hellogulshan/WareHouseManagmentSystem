using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WHMSystem.Models;

public partial class Order
{
    public int OrderId { get; set; }

    public DateTime OrderDate { get; set; }

    public string CustomerName { get; set; } = null!;

    public string CustomerAddress { get; set; } = null!;

    public int DeliveryOptionId { get; set; }

    public DateTime? FulfillmentDate { get; set; }

    public virtual DeliveryOption DeliveryOption { get; set; } = null!;

    public virtual ICollection<OrderItem> OrderItems { get; } = new List<OrderItem>();
}


public class PlaceOrderDto
{
    
    public int ProductId { get; set; }

    public string ProductCode { get; set; } = null!;

    public string ProductName { get; set; } = null!;

    public DateTime? WarrantyDate { get; set; }

    public int CurrentQuantity { get; set; }

    public int ProductTypeID { get; set; }

    public string ProductTypeName { get; set; } = null!;

    public int OrderId { get; set; }

    public DateTime OrderDate { get; set; }

    public string CustomerName { get; set; } = null!;

    public string DeliveryOption { get; set; } = null!;

    public string CustomerAddress { get; set; } = null!;

    public int DeliveryOptionID { get; set; }

    public DateTime? FulfillmentDate { get; set; }
}


public class OrderRequest
{
    public DateTime? OrderDate { get; set; } // Optional
    public string CustomerName { get; set; } = null!;
    public string CustomerAddress { get; set; } = null!;
    public int DeliveryOptionId { get; set; }
    public string ProductCode { get; set; } = null!;
    public int OrderQuantity { get; set; }
}

public class GetAllOrdersRequestDto
{
    [Key]
    public int OrderId { get; set; }
    public DateTime? OrderDate { get; set; } // Optional
    public string ProductName { get; set; } = null!;
    public DateTime? WarrantyDate { get; set; }
    public int Quantity { get; set; }
    public string CustomerName { get; set; } = null!;
    public string CustomerAddress { get; set; } = null!;
    public string DeliveryOptionName { get; set; } = null!;
    public DateTime? FulfillmentDate { get; set; }
}