using System;
using System.Collections.Generic;

namespace PiNewsCore.Models.Reverse;

public partial class Article_Image
{
    public int id { get; set; }

    public int? article_id { get; set; }

    public int? image_id { get; set; }
}
