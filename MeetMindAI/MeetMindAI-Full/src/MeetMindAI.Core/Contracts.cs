using MeetMindAI.Core.Models;
namespace MeetMindAI.Core.Contracts;
public interface IAuthService { Task<LoginResponse?> LoginAsync(LoginRequest request); }
public interface IMeetingService { Task<Meeting> CreateAsync(Guid userId,CreateMeetingRequest request); Task<IReadOnlyList<Meeting>> GetAsync(Guid userId); Task<MeetingSummary> SummarizeAsync(Guid meetingId); }
public interface IAiAssistant { Task<AssistantSuggestion> SuggestAsync(Guid meetingId,string question); }
