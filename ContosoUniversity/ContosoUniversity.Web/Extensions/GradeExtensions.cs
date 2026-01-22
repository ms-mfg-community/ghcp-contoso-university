using ContosoUniversity.Core.Models;

namespace ContosoUniversity.Web.Extensions
{
    public static class GradeExtensions
    {
        public static decimal ToGradePoints(this Grade grade)
        {
            return grade switch
            {
                Grade.A => 4.0m,
                Grade.B => 3.0m,
                Grade.C => 2.0m,
                Grade.D => 1.0m,
                Grade.F => 0.0m,
                _ => 0.0m
            };
        }
    }
}
