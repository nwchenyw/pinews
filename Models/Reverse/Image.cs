using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Image
{
    public int Id { get; set; }

    public int? Image_Type { get; set; }

    public string? Content_Type { get; set; }

    public string? File_Name { get; set; }

    public byte[]? Data { get; set; }

    public decimal? Size { get; set; }

    public int? User_id { get; set; }

    public DateTime? Upload_Time { get; set; }
}
