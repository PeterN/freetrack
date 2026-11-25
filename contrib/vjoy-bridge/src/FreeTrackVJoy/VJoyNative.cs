using System;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;

namespace FreeTrackVJoy
{
    /// <summary>
    /// Direct calls into vJoyInterface.dll. The DLL is NOT shipped with this program:
    /// it is loaded from the user's own vJoy install, so the DLL always matches the driver.
    /// </summary>
    internal static class VJoyNative
    {
        private const string Dll = "vJoyInterface.dll";

        public const uint HID_USAGE_X = 0x30;
        public const uint HID_USAGE_Y = 0x31;

        public enum VjdStat { Own = 0, Free = 1, Busy = 2, Missing = 3, Unknown = 4 }

        [DllImport(Dll, CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool vJoyEnabled();

        [DllImport(Dll, CallingConvention = CallingConvention.Cdecl)]
        public static extern VjdStat GetVJDStatus(uint rID);

        [DllImport(Dll, CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool AcquireVJD(uint rID);

        [DllImport(Dll, CallingConvention = CallingConvention.Cdecl)]
        public static extern void RelinquishVJD(uint rID);

        [DllImport(Dll, CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool GetVJDAxisExist(uint rID, uint axis);

        [DllImport(Dll, CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool SetAxis(int value, uint rID, uint axis);

        [DllImport(Dll, CallingConvention = CallingConvention.Cdecl)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool ResetVJD(uint rID);

        /// <summary>Find vJoyInterface.dll in the vJoy install folder (or next to the exe as a fallback).</summary>
        public static void InstallResolver()
        {
            NativeLibrary.SetDllImportResolver(typeof(VJoyNative).Assembly, (name, asm, path) =>
            {
                if (!name.Equals(Dll, StringComparison.OrdinalIgnoreCase)) return IntPtr.Zero;
                string arch = Environment.Is64BitProcess ? "x64" : "x86";
                string[] candidates =
                {
                    Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), "vJoy", arch, Dll),
                    Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFiles), "vJoy", Dll),
                    Path.Combine(AppContext.BaseDirectory, Dll),
                };
                foreach (var c in candidates)
                    if (File.Exists(c) && NativeLibrary.TryLoad(c, out var h)) return h;
                return IntPtr.Zero; // falls back to normal search; a clear error is shown if missing
            });
        }
    }
}
