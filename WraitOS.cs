using System;
using System.Drawing;
using System.IO;
using System.Net;
using System.Diagnostics;
using System.Windows.Forms;
using System.Runtime.InteropServices;

namespace WraitOS
{
    static class Program
    {
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new MainForm());
        }
    }

    public class MainForm : Form
    {
        [DllImport("Gdi32.dll", EntryPoint = "CreateRoundRectRgn")]
        private static extern IntPtr CreateRoundRectRgn(int nLeftRect, int nTopRect, int nRightRect, int nBottomRect, int nWidthEllipse, int nHeightEllipse);
        
        [DllImport("user32.dll")]
        public static extern bool ReleaseCapture();
        [DllImport("user32.dll")]
        public static extern int SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);

        // --- AYARLAR ---
        private string currentVersion = "1.0"; 
        private string repoRawUrl = "https://raw.githubusercontent.com/wraitstudio-cmd/WraitGame-Tool/main";

        public MainForm()
        {
            this.FormBorderStyle = FormBorderStyle.None;
            this.Size = new Size(320, 520);
            this.BackColor = Color.FromArgb(10, 10, 15);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Region = Region.FromHrgn(CreateRoundRectRgn(0, 0, Width, Height, 25, 25));

            InitUI();
            CheckForUpdates(); // Program açılırken kontrol et
        }

        private void InitUI()
        {
            // HEADER
            Panel header = new Panel { Size = new Size(this.Width, 65), Dock = DockStyle.Top, BackColor = Color.FromArgb(15, 15, 25) };
            header.MouseDown += (s, e) => { ReleaseCapture(); SendMessage(this.Handle, 0xA1, 0x2, 0); };

            // İSTEDİĞİN YEŞİL LABEL
            Label title = new Label { 
                Text = "WRAIT OS ARAÇLARI", 
                ForeColor = Color.Lime, // Parlak Yeşil
                Font = new Font("Consolas", 11, FontStyle.Bold), 
                Left = 15, Top = 22, 
                AutoSize = true 
            };
            
            Button closeBtn = new Button { Text = "X", Size = new Size(35, 35), Left = 270, Top = 15, FlatStyle = FlatStyle.Flat, ForeColor = Color.White, BackColor = Color.FromArgb(30, 30, 40) };
            closeBtn.FlatAppearance.BorderSize = 0;
            closeBtn.Click += (s, e) => Application.Exit();

            header.Controls.Add(title); header.Controls.Add(closeBtn);
            this.Controls.Add(header);

            // SCROLL PANEL
            Panel container = new Panel { Dock = DockStyle.Fill, AutoScroll = false };
            this.Controls.Add(container);

            FlowLayoutPanel toolPanel = new FlowLayoutPanel { 
                Width = container.Width + 25, 
                Height = container.Height,
                Dock = DockStyle.Left, 
                BackColor = Color.FromArgb(10, 10, 15), 
                Padding = new Padding(15, 10, 15, 10),
                AutoScroll = true 
            };
            container.Controls.Add(toolPanel);

            // Bat dosyalarını yükle
            LoadTools(toolPanel);

            // GÜNCELLEME BUTONU
            Button upBtn = new Button { 
                Text = "YENİ GÜNCELLEME VAR! (TIKLA)", 
                Dock = DockStyle.Bottom, Height = 50, 
                BackColor = Color.FromArgb(0, 150, 0), // Koyu Yeşil
                ForeColor = Color.White, 
                Visible = false, 
                FlatStyle = FlatStyle.Flat, 
                Font = new Font("Consolas", 10, FontStyle.Bold)
            };
            upBtn.Click += (s, e) => StartFullUpdate();
            this.Controls.Add(upBtn);
            this.Tag = upBtn;
        }

        private void LoadTools(FlowLayoutPanel pnl)
        {
            string toolsDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Tools");
            if (Directory.Exists(toolsDir)) {
                foreach (string file in Directory.GetFiles(toolsDir, "*.bat")) {
                    Button btn = new Button { Text = Path.GetFileNameWithoutExtension(file).ToUpper(), Size = new Size(265, 50), FlatStyle = FlatStyle.Flat, ForeColor = Color.SpringGreen, BackColor = Color.FromArgb(20, 20, 35), Margin = new Padding(0, 0, 0, 12), Font = new Font("Consolas", 9, FontStyle.Bold) };
                    btn.FlatAppearance.BorderColor = Color.FromArgb(50, 50, 80);
                    btn.Click += (s, e) => { try { Process.Start(new ProcessStartInfo(file) { Verb = "runas", UseShellExecute = true }); } catch { } };
                    pnl.Controls.Add(btn);
                }
            }
        }

        private void CheckForUpdates()
        {
            try {
                ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072; // TLS 1.2
                using (WebClient wc = new WebClient()) {
                    wc.Headers.Add("user-agent", "WraitOS-Updater");
                    // GitHub'daki version.vrs içeriğini oku
                    string onlineVer = wc.DownloadString(repoRawUrl + "/version.vrs").Trim();
                    
                    // Eğer dosyadaki yazı (sürüm) bendekinden farklıysa butonu göster
                    if (onlineVer != currentVersion) {
                        Button upBtn = (Button)this.Tag;
                        upBtn.Visible = true;
                    }
                }
            } catch { }
        }

        private void StartFullUpdate()
        {
            UpdateEngine engine = new UpdateEngine(repoRawUrl);
            engine.Show();
        }
    }

    public class UpdateEngine : Form {
        private RichTextBox log = new RichTextBox();
        public UpdateEngine(string url) {
            this.Size = new Size(400, 250); this.BackColor = Color.Black; this.FormBorderStyle = FormBorderStyle.None; this.StartPosition = FormStartPosition.CenterScreen;
            log.Dock = DockStyle.Fill; log.BackColor = Color.Black; log.ForeColor = Color.Lime; log.ReadOnly = true;
            this.Controls.Add(log);
            RunUpdate(url);
        }

        private void RunUpdate(string url) {
            try {
                using (WebClient wc = new WebClient()) {
                    wc.Headers.Add("user-agent", "Mozilla/5.0");
                    string toolsDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Tools");
                    if (!Directory.Exists(toolsDir)) Directory.CreateDirectory(toolsDir);

                    log.AppendText(">> GÜNCELLEMELER DENETLENİYOR...\n");
                    // Örnek Dosyaları Çek (Github'da bu yollarda dosya olmalı)
                    wc.DownloadFile(url + "/Tools/Driver.bat", Path.Combine(toolsDir, "Driver.bat"));
                    log.AppendText(">> [TAMAM] Driver.bat güncellendi.\n");
                    
                    log.AppendText(">> SİSTEM GÜNCEL! LÜTFEN YENİDEN BAŞLAT.");
                }
            } catch (Exception ex) { log.AppendText(">> HATA: " + ex.Message); }
        }
    }
}