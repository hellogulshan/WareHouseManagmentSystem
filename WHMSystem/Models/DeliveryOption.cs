using System;
using System.Collections.Generic;

namespace WHMSystem.Models;

public partial class DeliveryOption
{
    public int DeliveryOptionId { get; set; }

    public string DeliveryOptionName { get; set; } = null!;

    public bool? IsActive { get; set; }

    public virtual ICollection<Order> Orders { get; } = new List<Order>();
}
