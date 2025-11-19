using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Member_Payment
{
    public int Id { get; set; }

    public int? User_Id { get; set; }

    public string? Order_Id { get; set; }

    public string? Buyer_Name { get; set; }

    public string? Buyer_Telm { get; set; }

    public string? Buyer_Mail { get; set; }

    public int? Amount { get; set; }

    public string? CarrierType { get; set; }

    public string? CarrierId1 { get; set; }

    public string? CarrierId2 { get; set; }

    public string? BuyerIdentifier { get; set; }

    public string? NPOBAN { get; set; }

    public bool? IsComplete { get; set; }

    public DateTime? Pay_Time { get; set; }

    public DateTime? Due_Time { get; set; }

    public string? Remark { get; set; }

    public int? User_Class { get; set; }
}
