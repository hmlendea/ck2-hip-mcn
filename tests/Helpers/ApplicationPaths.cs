using System;
using System.IO;
using System.Reflection;

namespace McnTests.Helpers
{
    public sealed class ApplicationPaths
    {
        static string rootDirectory;

        /// <summary>
        /// The executing directory.
        /// </summary>
        public static string RootDirectory
        {
            get
            {
                if (rootDirectory == null)
                {
                    string executingDirectory = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);

                    rootDirectory = new DirectoryInfo(executingDirectory).Parent.Parent.Parent.Parent.FullName;
                }

                return rootDirectory;
            }
        }

        public static string DescriptorFile => Path.Combine(RootDirectory, "hip-more-cultural-names.mod");

        public static string ModDirectory => Path.Combine(RootDirectory, "hip-more-cultural-names");

        public static string CommonDirectory => Path.Combine(ModDirectory, "common");
        
        public static string CulturesDirectory => Path.Combine(CommonDirectory, "cultures");

        public static string DynastiesDirectory => Path.Combine(CommonDirectory, "dynasties");

        public static string LandedTitlesDirectory => Path.Combine(CommonDirectory, "landed_titles");

        public static string LocalisationDirectory => Path.Combine(ModDirectory, "localisation");
    }
}