import { Check, Close, Globe } from "../../../icons/lucide.js";
import { useI18n } from "../../../utils/i18n.js";

export default function LanguageSettingsModal({ open, onClose }) {
  const { lang, setLanguage, languages, t } = useI18n();

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-150 flex items-center justify-center bg-black/50 p-4 backdrop-blur-xs">
      <div className="w-full max-w-sm overflow-hidden rounded-2xl border border-sky-300/30 bg-white/95 dark:border-sky-500/20 dark:bg-slate-900/95 shadow-2xl">
        <div className="flex items-center justify-between border-b border-slate-100 dark:border-white/10 px-5 py-4">
          <div className="flex items-center gap-2.5">
            <Globe size={20} className="text-sky-500" />
            <h3 className="text-base font-bold text-slate-800 dark:text-slate-100">
              {t("language", "Language")}
            </h3>
          </div>
          <button
            type="button"
            onClick={onClose}
            className="flex h-8 w-8 items-center justify-center rounded-full text-slate-400 hover:bg-slate-100 dark:hover:bg-slate-800 hover:text-slate-700 dark:hover:text-slate-200"
          >
            <Close size={18} />
          </button>
        </div>

        <div className="max-h-[60vh] overflow-y-auto py-2">
          {languages.map((item) => {
            const isSelected = item.code === lang;
            return (
              <button
                key={item.code}
                type="button"
                onClick={() => {
                  setLanguage(item.code);
                  setTimeout(() => onClose?.(), 100);
                }}
                className={`flex w-full items-center justify-between px-5 py-3 text-left transition-colors cursor-pointer ${
                  isSelected
                    ? "bg-sky-500/10 text-sky-600 dark:text-sky-400 font-semibold"
                    : "text-slate-700 dark:text-slate-200 hover:bg-slate-50 dark:hover:bg-slate-800/60"
                }`}
              >
                <div>
                  <div className="text-sm">{item.nativeName}</div>
                  <div className="text-xs text-slate-400 dark:text-slate-500">
                    {item.name}
                  </div>
                </div>
                {isSelected ? <Check size={18} className="text-sky-500" /> : null}
              </button>
            );
          })}
        </div>
      </div>
    </div>
  );
}
