using InventoryV3.Server.Models.Requests;
using System;
using System.Collections.Generic;

public class RequestInsertRequest
{
    public int? AlertID { get; set; }
    public DateTime? DateRequested { get; set; }
    public string Notes { get; set; }
    public List<RequestDetailInsertRequest> RequestDetailList { get; set; }
}
