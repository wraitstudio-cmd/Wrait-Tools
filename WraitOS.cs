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
        // Yuvarlak Köşeler ve Pencere Sürükleme için Windows API'leri
        [DllImport("Gdi32.dll", EntryPoint = "CreateRoundRectRgn")]
        private static extern IntPtr CreateRoundRectRgn(int nLeftRect, int nTopRect, int nRightRect, int nBottomRect, int nWidthEllipse, int nHeightEllipse);
        
        [DllImport("user32.dll")]
        public static extern bool ReleaseCapture();
        [DllImport("user32.dll")]
        public static extern int SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);

        private string currentVersion = "1.0"; // BU KODDAKİ SÜRÜM
        private string repoRawUrl = "https://raw.githubusercontent.com/wraitstudio-cmd/WraitGame-Tool/main";

        public MainForm()
        {
            this.FormBorderStyle = FormBorderStyle.None;
            this.Size = new Size(320, 520); // Scale ayarı için sabit başlangıç
            this.BackColor = Color.FromArgb(10, 10, 15);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Region = Region.FromHrgn(CreateRoundRectRgn(0, 0, Width, Height, 25, 25));

            InitUI();
            CheckForUpdates();
        }

        private void InitUI()
        {
            // --- HEADER (Sürükleme Alanı) ---
            Panel header = new Panel { Size = new Size(this.Width, 65), Dock = DockStyle.Top, BackColor = Color.FromArgb(15, 15, 25) };
            header.MouseDown += (s, e) => { ReleaseCapture(); SendMessage(this.Handle, 0xA1, 0x2, 0); }; // TIKLA VE TAŞI ÖZELLİĞİ

            Label title = new Label { Text = "WRAIT OS CORE", ForeColor = Color.Cyan, Font = new Font("Consolas", 11, FontStyle.Bold), Left = 15, Top = 22, AutoSize = true, Enabled = false };
            
            Button closeBtn = new Button { Text = "X", Size = new Size(35, 35), Left = 270, Top = 15, FlatStyle = FlatStyle.Flat, ForeColor = Color.White, BackColor = Color.FromArgb(30, 30, 40) };
            closeBtn.FlatAppearance.BorderSize = 0;
            closeBtn.Click += (s, e) => Application.Exit();

            header.Controls.Add(title); header.Controls.Add(closeBtn);
            this.Controls.Add(header);

            // --- GİZLİ SCROLLBAR PANEL (Beyaz Barı Siler) ---
            Panel container = new Panel { Dock = DockStyle.Fill, AutoScroll = false };
            this.Controls.Add(container);

            FlowLayoutPanel toolPanel = new FlowLayoutPanel { 
                Width = container.Width + 25, // Scrollbar'ı sağa fırlatır
                Height = container.Height,
                Dock = DockStyle.Left, 
                BackColor = Color.FromArgb(10, 10, 15), 
                Padding = new Padding(15, 10, 15, 10),
                AutoScroll = true 
            };
            container.Controls.Add(toolPanel);

            // Araçları Otomatik Listele
            string toolsDir = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "Tools");
            if (Directory.Exists(toolsDir)) {
                foreach (string file in Directory.GetFiles(toolsDir, "*.bat")) {
                    Button btn = CreateMenuBtn(Path.GetFileNameWithoutExtension(file).ToUpper(), file);
                    toolPanel.Controls.Add(btn);
                }
            }

            // --- GÜNCELLEME ÇUBUĞU (Sadece Gerektiğinde) ---
            Button upBtn = new Button { 
                Text = "NEW UPDATE AVAILABLE! (CLICK)", Dock = DockStyle.Bottom, Height = 50, 
                BackColor = Color.FromArgb(0, 120, 215), ForeColor = Color.White, 
                Visible = false, FlatStyle = FlatStyle.Flat, Font = new Font("Consolas", 10, FontStyle.Bold)
            };
            upBtn.Click += (s, e) => StartFullUpdate();
            this.Controls.Add(upBtn);
            this.Tag = upBtn;
        }

        private Button CreateMenuBtn(string txt, string path) {
            Button btn = new Button { Text = txt, Size = new Size(265, 50), FlatStyle = FlatStyle.Flat, ForeColor = Color.LimeGreen, BackColor = Color.FromArgb(20, 20, 35), Margin = new Padding(0, 0, 0, 12), Font = new Font("Consolas", 9, FontStyle.Bold) };
            btn.FlatAppearance.BorderColor = Color.FromArgb(50, 50, 80);
            btn.Click += (s, e) => { try { Process.Start(new ProcessStartInfo(path) { Verb = "runas", UseShellExecute = true }); } catch { } };
            return btn;
        }

        private void CheckForUpdates() {
            try {
                // TLS Güvenlik Protokollerini Zorla (GitHub için Şart)
                ServicePointManager.Expect100Continue = true;
                ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072; // Tls12

                using (WebClient wc = new WebClient()) {
                    wc.Headers.Add("user-agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)");
                    // version.vrs dosyasını indir ve karşılaştır
                    string onlineVer = wc.DownloadString(repoRawUrl + "/version.vrs").Trim();
                    
                    if (onlineVer != currentVersion) {
                        Button upBtn = (Button)this.Tag;
                        upBtn.Visible = true;
                    }
                }
            } catch { /* Sessiz hata: İnternet yoksa butonu gösterme */ }
        }

        private void StartFullUpdate() {
            UpdateEngine engine = new UpdateEngine(repoRawUrl);
            engine.Show();
        }
    }

    public class UpdateEngine : Form {
        private RichTextBox log = new RichTextBox();
        private string url;

        public UpdateEngine(string repo) {
            this.url = repo;
            this.Size = new Size(400, 250);
            this.BackColor = Color.Black;
            this.FormBorderStyle = FormBorderStyle.None;
            this.StartPosition = FormStartPosition.CenterScreen;

            log.Dock = DockStyle.Fill; log.BackColor = Color.Black; log.ForeColor = Color.Cyan;
            log.Font = new Font("Consolas", 9); log.ReadOnly = true;
            this.Controls.Add(log);

            Timer t = new Timer(); t.Interval = 500;
            t.Tick += (s, e) => { t.Stop(); DoWork(); };
            t.Start();
        }

        private void DoWork() {
            log.AppendText(">> WRAIT REPO CONNECTING...\n");
            try {
                ServicePointManager.SecurityProtocol = (SecurityProtocolType)3072;
                using (WebClient wc = new WebClient()) {
                    wc.Headers.Add("user-agent", "Mozilla/5.0");
                    string baseDir = AppDomain.CurrentDomain.BaseDirectory;
                    string toolsDir = Path.Combine(baseDir, "Tools");
                    if (!Directory.Exists(toolsDir)) Directory.CreateDirectory(toolsDir);

                    log.AppendText(">> DOWNLOADING DRIVER COMPONENTS...\n");
                    // REPO'DAN DOSYALARI ÇEK
                    wc.DownloadFile(url + "/Tools/Driver.bat", Path.Combine(toolsDir, "Driver.bat"));
                    log.AppendText(">> [OK] Driver.bat Updated.\n");
                    
                    // İstersen buraya ana exe güncellemesini de ekleyebiliriz (Farklı isimle indirip bat ile değiştirterek)

                    log.SelectionColor = Color.Lime;
                    log.AppendText(">> ALL FILES UPDATED SUCCESSFULLY.\n");
                    log.AppendText(">> RESTART WRAIT OS TO APPLY CHANGES.");
                }
            } catch (Exception ex) {
                log.SelectionColor = Color.Red;
                log.AppendText(">> CRITICAL ERROR: " + ex.Message);
            }
        }
    }
}