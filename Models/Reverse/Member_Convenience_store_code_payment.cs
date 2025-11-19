using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Member_Convenience_store_code_payment
{
    public int id { get; set; }

    public int? User_Id { get; set; }

    public int? StoreType { get; set; }

    public string? OrderID { get; set; }

    public string? e_orderno { get; set; }

    public string? PinCode { get; set; }

    public string? first_strcheck { get; set; }

    public string? Uni_num { get; set; }

    public string? CarrierType { get; set; }

    public string? CarrierId1 { get; set; }

    public string? CarrierId2 { get; set; }

    public string? NPOBAN { get; set; }

    public string? e_money { get; set; }

    public string? PayAmount { get; set; }

    public string? e_date { get; set; }

    public string? e_time { get; set; }

    public string? Barcode2 { get; set; }

    public string? Market_ID { get; set; }

    public string? Shop_Store_Name { get; set; }

    public string? Remark { get; set; }
}
