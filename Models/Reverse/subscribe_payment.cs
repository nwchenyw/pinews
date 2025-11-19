using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class subscribe_payment
{
    public int Id { get; set; }

    public int? User_Id { get; set; }

    public int? Subscriber_Id { get; set; }

    public int? Order_Id { get; set; }

    public int? Amount { get; set; }

    public string? Description { get; set; }

    public bool? IsComplete { get; set; }

    public DateTime? Pay_Time { get; set; }

    public DateTime? Due_Time { get; set; }
}
