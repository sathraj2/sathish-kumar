using Microsoft.AspNetCore.SignalR;
using MeetMindAI.Core.Contracts; using MeetMindAI.Core.Models; using MeetMindAI.Infrastructure; using Microsoft.EntityFrameworkCore;
var b=WebApplication.CreateBuilder(args); b.Services.AddDbContext<AppDbContext>(o=>o.UseNpgsql(b.Configuration.GetConnectionString("Default"))); b.Services.AddScoped<IAuthService,AuthService>();b.Services.AddScoped<IMeetingService,MeetingService>();b.Services.AddScoped<IAiAssistant,AiAssistant>();b.Services.AddSignalR();b.Services.AddEndpointsApiExplorer();b.Services.AddSwaggerGen();
var app=b.Build(); using(var s=app.Services.CreateScope()){var db=s.ServiceProvider.GetRequiredService<AppDbContext>(); await db.Database.EnsureCreatedAsync(); if(!await db.Users.AnyAsync()){db.Users.Add(new UserEntity{Name="Demo User",Email="demo@meetmind.ai",PasswordHash=Convert.ToHexString(System.Security.Cryptography.SHA256.HashData(System.Text.Encoding.UTF8.GetBytes("Demo@123")))});await db.SaveChangesAsync();}}
app.UseSwagger();app.UseSwaggerUI();
app.MapGet("/api/health",()=>Results.Ok(new{status="ok",service="MeetMindAI.Api"}));
app.MapPost("/api/auth/login",async(LoginRequest r,IAuthService auth)=>{var x=await auth.LoginAsync(r);return x is null?Results.Unauthorized():Results.Ok(x);});
app.MapGet("/api/meetings",async(Guid userId,IMeetingService svc)=>Results.Ok(await svc.GetAsync(userId)));
app.MapPost("/api/meetings",async(Guid userId,CreateMeetingRequest r,IMeetingService svc)=>Results.Ok(await svc.CreateAsync(userId,r)));
app.MapPost("/api/meetings/{id:guid}/ask",async(Guid id,AskRequest r,IAiAssistant ai)=>Results.Ok(await ai.SuggestAsync(id,r.Question)));
app.MapGet("/api/meetings/{id:guid}/summary",async(Guid id,IMeetingService svc)=>Results.Ok(await svc.SummarizeAsync(id)));
app.MapHub<MeetingHub>("/hubs/meeting"); app.Run();
public sealed class MeetingHub:Microsoft.AspNetCore.SignalR.Hub { public Task SendTranscript(Guid meetingId,string speaker,string text)=>Clients.Group(meetingId.ToString()).SendAsync("transcript",speaker,text); public Task Join(Guid meetingId)=>Groups.AddToGroupAsync(Context.ConnectionId,meetingId.ToString()); }
