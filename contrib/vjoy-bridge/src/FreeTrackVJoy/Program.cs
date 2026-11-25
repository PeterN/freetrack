using System;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Threading;
using System.Windows.Forms;
using FreeTrackVJoy.Core;

namespace FreeTrackVJoy
{
    internal static class Program
    {
        [STAThread]
        private static void Main(string[] args)
        {
            // Only one bridge at a time, or two copies would fight over the vJoy device.
            using var single = new Mutex(true, @"Local\FreeTrackVJoyBridge", out bool first);
            if (!first)
            {
                MessageBox.Show("FreeTrack for vJoy is already running. Look for its icon near the clock.", "FreeTrack for vJoy");
                return;
            }

            VJoyNative.InstallResolver();
            ApplicationConfiguration.Initialize();

            string settingsPath = Path.Combine(AppContext.BaseDirectory, "settings.json");
            string? json = null;
            try { if (File.Exists(settingsPath)) json = File.ReadAllText(settingsPath); }
            catch (Exception) { /* locked or unreadable: use defaults */ }
            var settings = BridgeSettings.Parse(json);

            bool launchFreeTrack = !args.Contains("--no-launch", StringComparer.OrdinalIgnoreCase);
            Application.Run(new TrayContext(settings, launchFreeTrack));
        }
    }

    internal sealed class TrayContext : ApplicationContext
    {
        private readonly NotifyIcon _icon;
        private readonly OutputLoop _loop;
        private readonly BridgeSettings _settings;
        private readonly ToolStripMenuItem _statusItem;
        private readonly ToolStripMenuItem _toggleItem;
        private readonly System.Windows.Forms.Timer _uiTimer;

        public TrayContext(BridgeSettings settings, bool launchFreeTrack)
        {
            _settings = settings;
            _loop = new OutputLoop(settings);

            _statusItem = new ToolStripMenuItem("Starting...") { Enabled = false };
            _toggleItem = new ToolStripMenuItem("Stop output", null, (_, _) => Toggle());
            var menu = new ContextMenuStrip();
            menu.Items.Add(_statusItem);
            menu.Items.Add(new ToolStripSeparator());
            menu.Items.Add(_toggleItem);
            menu.Items.Add("Open FreeTrack", null, (_, _) => LaunchFreeTrack(showErrors: true));
            menu.Items.Add(new ToolStripSeparator());
            menu.Items.Add("Exit", null, (_, _) => ExitThread());

            _icon = new NotifyIcon
            {
                Icon = SystemIcons.Application,
                Text = "FreeTrack for vJoy",
                ContextMenuStrip = menu,
                Visible = true,
            };

            // If Windows logs off or shuts down, centre the axes and let go of vJoy first.
            Microsoft.Win32.SystemEvents.SessionEnding += (_, _) => _loop.Stop();

            if (launchFreeTrack) LaunchFreeTrack(showErrors: false);
            if (settings.Problem != null)
                _icon.ShowBalloonTip(15_000, "FreeTrack for vJoy - check settings", settings.Problem, ToolTipIcon.Warning);
            StartOutput();

            _uiTimer = new System.Windows.Forms.Timer { Interval = 500 };
            _uiTimer.Tick += (_, _) => RefreshStatus();
            _uiTimer.Start();
        }

        private void StartOutput()
        {
            string? error = _loop.Start();
            if (error != null)
                _icon.ShowBalloonTip(10_000, "FreeTrack for vJoy", error, ToolTipIcon.Warning);
            RefreshStatus();
        }

        private void Toggle()
        {
            if (_loop.Running) _loop.Stop(); else StartOutput();
            RefreshStatus();
        }

        private void RefreshStatus()
        {
            // The loop may stop itself after an error; keep the button text honest.
            _statusItem.Text = _settings.Problem != null ? _loop.Status + "  (settings.json problem - using defaults)" : _loop.Status;
            _toggleItem.Text = _loop.Running ? "Stop output (centre axes)" : "Start output";
            string tip = "FreeTrack for vJoy - " + _loop.Status;
            _icon.Text = tip.Length > 63 ? tip.Substring(0, 63) : tip; // Windows limit
        }

        private void LaunchFreeTrack(bool showErrors)
        {
            if (Process.GetProcessesByName("Freetrack").Length > 0) return; // already running

            string path = _settings.FreeTrackPath;
            if (string.IsNullOrWhiteSpace(path))
            {
                // Look for FreeTrack next to this exe, e.g. .\FreeTrack\Freetrack.exe
                path = new[]
                {
                    Path.Combine(AppContext.BaseDirectory, "FreeTrack", "Freetrack.exe"),
                    Path.Combine(AppContext.BaseDirectory, "Freetrack.exe"),
                    Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ProgramFilesX86), "FreeTrack", "Freetrack.exe"),
                }.FirstOrDefault(File.Exists) ?? "";
            }

            if (!File.Exists(path))
            {
                if (showErrors)
                    MessageBox.Show("Could not find Freetrack.exe. Put the path in settings.json (FreeTrackPath).", "FreeTrack for vJoy");
                return;
            }

            try
            {
                Process.Start(new ProcessStartInfo(path) { WorkingDirectory = Path.GetDirectoryName(path)!, UseShellExecute = true })?.Dispose();
            }
            catch (Exception e) when (showErrors)
            {
                MessageBox.Show("Could not start FreeTrack: " + e.Message, "FreeTrack for vJoy");
            }
            catch (Exception) { }
        }

        protected override void ExitThreadCore()
        {
            _uiTimer.Stop();
            _loop.Dispose(); // centres axes and releases vJoy
            _icon.Visible = false;
            _icon.Dispose();
            base.ExitThreadCore();
        }
    }
}
