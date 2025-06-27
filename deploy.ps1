# Friday JARVIS - Railway Deployment Script for Windows

Write-Host "🚀 تجهيز المشروع للنشر على Railway..." -ForegroundColor Green

# التحقق من وجود الملفات المطلوبة
if (-Not (Test-Path ".env")) {
    Write-Host "⚠️  ملف .env غير موجود. نسخ من .env.example..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "📝 يرجى تحديث ملف .env بمعلوماتك الصحيحة" -ForegroundColor Cyan
}

# تثبيت المتطلبات
Write-Host "📦 تثبيت المتطلبات..." -ForegroundColor Blue
pip install -r requirements.txt

# توليد التوكن
Write-Host "🔑 توليد التوكن..." -ForegroundColor Magenta
python generate_token.py

Write-Host "✅ المشروع جاهز للنشر على Railway!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 خطوات النشر:" -ForegroundColor Yellow
Write-Host "1. ارفع الكود إلى GitHub" -ForegroundColor White
Write-Host "2. اربط المستودع بـ Railway" -ForegroundColor White
Write-Host "3. أضف متغيرات البيئة في Railway:" -ForegroundColor White
Write-Host "   - LIVEKIT_API_KEY" -ForegroundColor Gray
Write-Host "   - LIVEKIT_API_SECRET" -ForegroundColor Gray
Write-Host "   - GOOGLE_API_KEY" -ForegroundColor Gray
Write-Host "   - OPENWEATHERMAP_API_KEY" -ForegroundColor Gray
Write-Host "4. انتظر اكتمال النشر" -ForegroundColor White
Write-Host ""
Write-Host "🎯 رابط LiveKit: wss://aivoic-tqnojuug.livekit.cloud" -ForegroundColor Cyan

# فتح متصفح على Railway
$choice = Read-Host "هل تريد فتح موقع Railway؟ (y/n)"
if ($choice -eq "y" -or $choice -eq "Y") {
    Start-Process "https://railway.app"
}
