import { useState } from "react";
import { Sparkles, Smile, Close } from "../../icons/lucide.js";

const EMOJI_CATEGORIES = [
  {
    name: "Smileys",
    emojis: ["😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "🥹", "😊", "😇", "🙂", "😉", "😍", "🥰", "😘", "😋", "😜", "🤪", "😎", "🤩", "🥳", "😏", "😒", "😞", "😔", "😟", "😕", "🙁", "😣", "😢", "😭", "😤", "😠", "😡", "🤬", "🤯", "😳", "🥵", "🥶", "😱", "😨", "😰", "🤔", "🫣", "🤫", "🫡", "🫠", "🤐", "😴"],
  },
  {
    name: "Gestures",
    emojis: ["👍", "👎", "👌", "🤌", "✌️", "🤞", "🫰", "🤟", "🤘", "🤙", "👈", "👉", "👆", "🖕", "👇", "☝️", "🫵", "👋", "🤚", "🖐️", "✋", "🖖", "👏", "🙌", "👐", "🤲", "🤝", "🙏", "✍️", "💅", "🤳", "💪"],
  },
  {
    name: "Hearts & Fire",
    emojis: ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎", "💔", "❤️‍🔥", "❤️‍🩹", "❣️", "💕", "💞", "💓", "💗", "💖", "💘", "💝", "🔥", "✨", "⚡", "💥", "💫", "🌟", "⭐", "🎉", "🎊"],
  },
  {
    name: "Ocean & Vibes",
    emojis: ["🌊", "🫧", "🐳", "🐋", "🐬", "🦭", "🦈", "🐙", "🦑", "🦐", "🦞", "🦀", "🐡", "🐠", "🐟", "🏝️", "🏖️", "⛵", "🚤", "🚢", "⚓", "🛸", "🚀", "🪐", "💎", "👑", "🔮", "🧿"],
  },
];

const TELEGRAM_STICKERS = [
  { id: "ocean_wave", label: "Ocean Wave", emoji: "🌊", size: "text-6xl" },
  { id: "cool_whale", label: "Blue Whale", emoji: "🐳", size: "text-6xl" },
  { id: "fire_heart", label: "Heart on Fire", emoji: "❤️‍🔥", size: "text-6xl" },
  { id: "party_popper", label: "Party Time", emoji: "🎉", size: "text-6xl" },
  { id: "rocket_ship", label: "To The Moon", emoji: "🚀", size: "text-6xl" },
  { id: "cool_sunglasses", label: "Super Cool", emoji: "😎", size: "text-6xl" },
  { id: "exploding_head", label: "Mind Blown", emoji: "🤯", size: "text-6xl" },
  { id: "crying_laughing", label: "Dead Laughing", emoji: "🤣", size: "text-6xl" },
  { id: "sparkle_star", label: "Shining Star", emoji: "✨", size: "text-6xl" },
  { id: "diamond_gem", label: "Diamond Gem", emoji: "💎", size: "text-6xl" },
  { id: "love_kiss", label: "Blowing Kiss", emoji: "😘", size: "text-6xl" },
  { id: "thumbs_up_fire", label: "Approved!", emoji: "👍", size: "text-6xl" },
  { id: "crown_king", label: "King Crown", emoji: "👑", size: "text-6xl" },
  { id: "dolphin_splash", label: "Dolphin", emoji: "🐬", size: "text-6xl" },
  { id: "octopus_hug", label: "Octopus", emoji: "🐙", size: "text-6xl" },
  { id: "thunder_bolt", label: "Thunder Bolt", emoji: "⚡", size: "text-6xl" },
];

export default function EmojiStickerPicker({
  open,
  onClose,
  onSelectEmoji,
  onSendSticker,
}) {
  const [tab, setTab] = useState("emoji");

  if (!open) return null;

  return (
    <div className="absolute bottom-14 right-2 z-50 flex h-80 w-72 sm:w-80 flex-col overflow-hidden rounded-2xl border border-sky-400/30 bg-white/95 shadow-2xl backdrop-blur-xl dark:border-sky-500/25 dark:bg-slate-900/95 animate-in fade-in zoom-in-95 duration-150">
      {/* Tab Header */}
      <div className="flex items-center justify-between border-b border-slate-100 dark:border-white/10 px-3 py-2 bg-slate-50/70 dark:bg-slate-800/40">
        <div className="flex items-center gap-1 rounded-xl bg-slate-200/60 p-0.5 dark:bg-slate-950/60">
          <button
            type="button"
            onClick={() => setTab("emoji")}
            className={`flex items-center gap-1.5 rounded-lg px-3 py-1 text-xs font-semibold transition cursor-pointer ${
              tab === "emoji"
                ? "bg-white text-sky-600 shadow-xs dark:bg-slate-800 dark:text-sky-300"
                : "text-slate-500 hover:text-slate-800 dark:text-slate-400 dark:hover:text-slate-200"
            }`}
          >
            <Smile size={14} />
            <span>Emoji</span>
          </button>
          <button
            type="button"
            onClick={() => setTab("stickers")}
            className={`flex items-center gap-1.5 rounded-lg px-3 py-1 text-xs font-semibold transition cursor-pointer ${
              tab === "stickers"
                ? "bg-white text-sky-600 shadow-xs dark:bg-slate-800 dark:text-sky-300"
                : "text-slate-500 hover:text-slate-800 dark:text-slate-400 dark:hover:text-slate-200"
            }`}
          >
            <Sparkles size={14} />
            <span>Stickers</span>
          </button>
        </div>
        <button
          type="button"
          onClick={onClose}
          className="rounded-full p-1 text-slate-400 hover:bg-slate-200 dark:hover:bg-slate-800 hover:text-slate-700 dark:hover:text-slate-200 cursor-pointer"
        >
          <Close size={16} />
        </button>
      </div>

      {/* Content Area */}
      <div className="app-scroll flex-1 overflow-y-auto p-3">
        {tab === "emoji" ? (
          <div className="space-y-3">
            {EMOJI_CATEGORIES.map((category) => (
              <div key={category.name}>
                <div className="mb-1 text-[11px] font-bold uppercase tracking-wider text-slate-400 dark:text-slate-500">
                  {category.name}
                </div>
                <div className="grid grid-cols-8 gap-1">
                  {category.emojis.map((emoji) => (
                    <button
                      key={emoji}
                      type="button"
                      onClick={() => onSelectEmoji?.(emoji)}
                      className="flex h-8 w-8 items-center justify-center rounded-lg text-lg transition hover:scale-130 hover:bg-sky-50 dark:hover:bg-sky-950/40 cursor-pointer"
                    >
                      {emoji}
                    </button>
                  ))}
                </div>
              </div>
            ))}
          </div>
        ) : (
          <div>
            <div className="mb-2 text-[11px] font-bold uppercase tracking-wider text-slate-400 dark:text-slate-500">
              Telegram Classic Stickers
            </div>
            <div className="grid grid-cols-4 gap-2">
              {TELEGRAM_STICKERS.map((sticker) => (
                <button
                  key={sticker.id}
                  type="button"
                  onClick={() => {
                    onSendSticker?.(sticker.emoji);
                    onClose?.();
                  }}
                  title={sticker.label}
                  className="group flex flex-col items-center justify-center rounded-2xl p-2.5 transition hover:scale-115 hover:bg-sky-500/10 active:scale-95 cursor-pointer"
                >
                  <span className="text-4xl transition-transform duration-150 group-hover:scale-120 animate-bounce-short">
                    {sticker.emoji}
                  </span>
                  <span className="mt-1 text-[10px] text-slate-500 dark:text-slate-400 truncate max-w-full">
                    {sticker.label}
                  </span>
                </button>
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
