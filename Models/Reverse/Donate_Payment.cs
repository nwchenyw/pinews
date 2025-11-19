using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Donate_Payment
{
    public int Id { get; set; }

    public int? User_Id { get; set; }

    public int? Sponsor_Id { get; set; }

    public string? Sponsor_Name { get; set; }

    public string? Order_Id { get; set; }

    public int? Amount { get; set; }

    public bool? IsComplete { get; set; }

    public DateTime? Pay_Time { get; set; }
}
