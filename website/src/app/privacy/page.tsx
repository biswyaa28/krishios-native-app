import Navbar from "@/components/Navbar";
import Footer from "@/components/Footer";
import { ShieldCheck } from "lucide-react";

export default function PrivacyPage() {
  return (
    <main className="min-h-screen bg-[#F6F4ED] text-[#1A2919] relative">
      <Navbar />
      <div className="pt-36 pb-20 max-w-4xl mx-auto px-6 space-y-8">
        
        <div className="space-y-3">
          <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-[#233B22]/10 text-[#233B22] text-xs font-medium">
            <ShieldCheck className="w-3.5 h-3.5" />
            <span>PRIVACY POLICY</span>
          </div>
          <h1 className="text-3xl sm:text-5xl font-normal text-[#1A2919] tracking-tight text-serif-editorial">
            KrishiOS Privacy Policy
          </h1>
          <p className="text-[#4B5E4A] text-sm font-mono">
            Effective Date: July 24, 2026
          </p>
        </div>

        <div className="editorial-card rounded-3xl p-8 border border-[#1A2919]/10 space-y-6 text-[#4B5E4A] text-sm leading-relaxed bg-white">
          <section className="space-y-2">
            <h2 className="text-lg font-bold text-[#1A2919]">1. Offline-First Privacy Guarantee</h2>
            <p>
              KrishiOS is built with an offline-first architecture. All camera crop disease classifications performed using our local ONNX edge model execute 100% on device without transmitting raw camera image files to external servers.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-[#1A2919]">2. Local Data Storage & Hardware Encryption</h2>
            <p>
              Your diagnostic scan history, local agronomy cache, and user preference databases are stored on your smartphone using Hive database encryption. Encryption keys are protected using Android OS Hardware KeyStore and EncryptedSharedPreferences via <code className="text-[#233B22] font-mono">flutter_secure_storage</code>.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-[#1A2919]">3. Cloud Services & Firebase Authentication</h2>
            <p>
              If you choose to sign in to Cloud services, account data (email, display name) and community forum posts are managed securely via Firebase Authentication and Cloud Firestore. Firebase Security Rules enforce resource ownership check constraints.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-[#1A2919]">4. Weather & Geolocation Services</h2>
            <p>
              Localized weather forecasting queries device GPS coordinates via Open-Meteo REST API solely to emit local rain and temperature alerts. Geolocation coordinates are not sold or linked to personal identifiers.
            </p>
          </section>

          <section className="space-y-2">
            <h2 className="text-lg font-bold text-[#1A2919]">5. Contact Us</h2>
            <p>
              If you have questions regarding data security or privacy practices, please contact Team 4 Brain via our official GitHub repository.
            </p>
          </section>
        </div>

      </div>
      <Footer />
    </main>
  );
}
