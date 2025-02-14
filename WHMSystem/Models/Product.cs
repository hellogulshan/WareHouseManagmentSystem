using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace WHMSystem.Models;

public partial class Product
{
    public int ProductId { get; set; }

    public string ProductCode { get; set; } = null!;

    public string ProductName { get; set; } = null!;

    public DateTime? WarrantyDate { get; set; }

    public int ProductTypeId { get; set; }

    public int CurrentQuantity { get; set; }

    public virtual ICollection<OrderItem> OrderItems { get; } = new List<OrderItem>();

    public virtual ProductType ProductType { get; set; } = null!;
}

public class ProductDto
{
    [Key]
    public int ProductId { get; set; }

    public string ProductCode { get; set; } = null!;

    public string ProductName { get; set; } = null!;

    public DateTime? WarrantyDate { get; set; }

    public int CurrentQuantity { get; set; }

    public int ProductTypeID { get; set; }

    public string ProductTypeName { get; set; } = null!;
}


public class AddProductDto
{
    [Key]
    public int ProductId { get; set; }
    public string ProductCode { get; set; } = null!;
    public string ProductName { get; set; } = null!;
    public DateTime? WarrantyDate { get; set; }
    public string ProductTypeName { get; set; } = null!;
    public int CurrentQuantity { get; set; }
}
