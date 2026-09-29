using System.Security.Cryptography; using System.Text; using MeetMindAI.Core.Contracts; using MeetMindAI.Core.Models; using Microsoft.EntityFrameworkCore;
namespace MeetMindAI.Infrastructure;
public sealed class AuthService(AppDbContext db):IAuthService{
 public async Task<LoginResponse?> LoginAsync(LoginRequest r){var u=await db.Users.SingleOrDefaultAsync(x=>x.Email==r.Email); if(u is null)return null; if(u.PasswordHash!=Hash(r.Password))return null; return new("DEMO-JWT-TOKEN",new(u.Id,u.Name,u.Email));}
 static string Hash(string s)=>Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(s)));
}
public sealed class MeetingService(AppDbContext db):IMeetingService{
 public async Task<Meeting> CreateAsync(Guid uid,CreateMeetingRequest r){var e=new MeetingEntity{UserId=uid,Title=r.Title,StartedAt=DateTime.UtcNow};db.Meetings.Add(e);await db.SaveChangesAsync();return new(e.Id,e.Title,e.StartedAt,e.EndedAt,e.Status);}
 public async Task<IReadOnlyList<Meeting>> GetAsync(Guid uid)=>await db.Meetings.Where(x=>x.UserId==uid).OrderByDescending(x=>x.StartedAt).Select(x=>new Meeting(x.Id,x.Title,x.StartedAt,x.EndedAt,x.Status)).ToListAsync();
 public async Task<MeetingSummary> SummarizeAsync(Guid id){var e=await db.Summaries.SingleOrDefaultAsync(x=>x.MeetingId==id);return e is null?new(Guid.NewGuid(),id,"Your meeting summary will appear here.","No decisions captured yet.","No action items captured yet."):new(e.Id,e.MeetingId,e.Summary,e.Decisions,e.ActionItems);}
}
public sealed class AiAssistant(AppDbContext db):IAiAssistant{
 public async Task<AssistantSuggestion> SuggestAsync(Guid mid,string q){var answer=q.Contains("deadline",StringComparison.OrdinalIgnoreCase)?"A clear response is: We should confirm the target date, owner, and dependencies before committing.":"A concise response is: Let me confirm the context and give you a clear answer.";var e=new SuggestionEntity{MeetingId=mid,Question=q,Answer=answer};db.Suggestions.Add(e);await db.SaveChangesAsync();return new(e.Id,mid,q,answer,e.Confidence);}
}
