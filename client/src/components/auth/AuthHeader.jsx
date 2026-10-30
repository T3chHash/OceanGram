import { Moon, Sun } from "../../icons/lucide.js";
import logo from "../../assets/oceangram-logo.png";

export default function AuthHeader({
  isLogin,
  isDark,
  themeToggleAnimating,
  onToggleTheme,
  title,
  subtitle,
}) {
  return (
    <div className="relative text-center">
      <div className="mx-auto mb-3 flex h-20 w-20 items-center justify-center">
        <img
          src={logo}
          alt="OceanGram"
          className="h-20 w-20 object-contain drop-shadow-[0_10px_25px_rgba(14,165,233,0.35)] transition-transform duration-300 hover:scale-105"
        />
      </div>
      <p className="text-xs font-semibold uppercase tracking-[0.25em] text-emerald-600 dark:text-emerald-300 sm:text-sm">
        {subtitle || (isLogin ? "Sign in" : "Create account")}
      </p>
      <h1 className="mt-2 text-2xl font-bold sm:mt-3 sm:text-3xl">
        {title || (isLogin ? "Welcome" : "Dive into OceanGram")}
      </h1>
      <button
        type="button"
        onClick={onToggleTheme}
        className="absolute right-0 top-0 flex h-8 w-8 items-center justify-center rounded-full border border-emerald-200 bg-white/80 text-emerald-700 transition dark:border-emerald-500/30 dark:bg-slate-950 dark:text-emerald-200 sm:h-10 sm:w-10"
        aria-label="Toggle dark mode"
      >
        {isDark ? (
          <Sun
            key="theme-sun"
            size={18}
            className={`icon-anim-spin-dir ${themeToggleAnimating ? "icon-theme-enter-sun" : ""}`}
          />
        ) : (
          <Moon
            key="theme-moon"
            size={18}
            className={`icon-anim-spin-left ${themeToggleAnimating ? "icon-theme-enter-moon" : ""}`}
          />
        )}
      </button>
    </div>
  );
}
