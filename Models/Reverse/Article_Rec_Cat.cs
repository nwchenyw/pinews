using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Article_Rec_Cat
{
    public int Id { get; set; }

    public int? Article_id { get; set; }

    public int? Rec_cat_id { get; set; }
}
