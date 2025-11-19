using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Microsoft.AspNet.SignalR;
using Newtonsoft.Json;

namespace piNews
{
  public class PushHub : Hub
  {
    //public void Hello()
    //{
    //  Clients.All.hello();
    //  Context.Headers["Auth"].ToString();
    //}
    //public void Send(string name, string message)
    //{
    //  // Call the broadcastMessage method to update clients.
    //  Clients.All.broadcastMessage(name, message);
    //}

    UserClass uc = new UserClass();

    public class msg_list
    {
      public string name { get; set; }
      public string msg { get; set; }
    }

    public class msg_user_list
    {
      public string user { get; set; }
      public string name { get; set; }
      public string msg { get; set; }
    }

    public void showMsg(string hash) //server端加密，client端認證
    {

      string arr = uc.DecryptString(hash, "kb53229980");
      if (arr != hash)
      {
        Clients.All.showErr(Context.User.Identity.Name);

        msg_list ls = JsonConvert.DeserializeObject<msg_list>(arr);

        Clients.All.broadcastMessage(ls.name, ls.msg);
      }
      else
      {
        Clients.Client(Context.ConnectionId).showErr("Oops!something went wrong :O");
      }
    }

    public void showUserMsg(string hash) //server端加密，client端認證
    {

      string arr = uc.DecryptString(hash, "kb53229980");
      if (arr != hash)
      {
        msg_user_list ls = JsonConvert.DeserializeObject<msg_user_list>(arr);
        Clients.User(ls.user).broadcastMessage(ls.name, ls.msg);
      }
    }

    public Task JoinRoom(string hash)
    {
      string roomName = uc.DecryptString(hash, "kb53229980");
      if (roomName != hash)
      {
        return Groups.Add(Context.ConnectionId, roomName);
      }
      return Task.CompletedTask;
    }

    public Task LeaveRoom(string hash)
    {
      string roomName = uc.DecryptString(hash, "kb53229980");
      if (roomName != hash)
      {
        return Groups.Remove(Context.ConnectionId, roomName);
      }
      return Task.CompletedTask;
    }
  }
}