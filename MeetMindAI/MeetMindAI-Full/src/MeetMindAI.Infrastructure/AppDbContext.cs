using Microsoft.EntityFrameworkCore;
namespace MeetMindAI.Infrastructure;
public sealed class AppDbContext(DbContextOptions<AppDbContext> options):DbContext(options)
{
 public DbSet<UserEntity> Users=>Set<UserEntity>(); public DbSet<MeetingEntity> Meetings=>Set<MeetingEntity>(); public DbSet<TranscriptEntity> Transcripts=>Set<TranscriptEntity>(); public DbSet<SuggestionEntity> Suggestions=>Set<SuggestionEntity>(); public DbSet<SummaryEntity> Summaries=>Set<SummaryEntity>();
 protected override void OnModelCreating(ModelBuilder b){ b.Entity<UserEntity>().HasIndex(x=>x.Email).IsUnique(); b.Entity<MeetingEntity>().HasIndex(x=>x.UserId); b.Entity<TranscriptEntity>().HasIndex(x=>x.MeetingId); b.Entity<SuggestionEntity>().HasIndex(x=>x.MeetingId); }
}
public sealed class UserEntity{public Guid Id{get;set;}=Guid.NewGuid();public string Name{get;set;}="";public string Email{get;set;}="";public string PasswordHash{get;set;}="";}
public sealed class MeetingEntity{public Guid Id{get;set;}=Guid.NewGuid();public Guid UserId{get;set;}public string Title{get;set;}="";public DateTime StartedAt{get;set;}public DateTime? EndedAt{get;set;}public string Status{get;set;}="Live";}
public sealed class TranscriptEntity{public Guid Id{get;set;}=Guid.NewGuid();public Guid MeetingId{get;set;}public string Speaker{get;set;}="User";public string Text{get;set;}="";public DateTimeOffset Timestamp{get;set;}=DateTimeOffset.UtcNow;}
public sealed class SuggestionEntity{public Guid Id{get;set;}=Guid.NewGuid();public Guid MeetingId{get;set;}public string Question{get;set;}="";public string Answer{get;set;}="";public string Confidence{get;set;}="Medium";}
public sealed class SummaryEntity{public Guid Id{get;set;}=Guid.NewGuid();public Guid MeetingId{get;set;}public string Summary{get;set;}="";public string Decisions{get;set;}="";public string ActionItems{get;set;}="";}
