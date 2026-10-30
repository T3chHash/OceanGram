import { useEffect, useLayoutEffect, useRef, useState } from "react";
import { createPortal } from "react-dom";

const SCREEN_GAP = 12;

const TELEGRAM_REACTIONS = ["👍", "❤️", "🔥", "😂", "👏", "⚡", "🌊"];

export default function AppContextMenu({ menu, onClose }) {
  const menuRef = useRef(null);
  const [desktopPosition, setDesktopPosition] = useState({ x: 0, y: 0 });
  const [verticalPlacement, setVerticalPlacement] = useState("below");
  const [focusedIndex, setFocusedIndex] = useState(-1);
  const [activeReaction, setActiveReaction] = useState(null);

  useEffect(() => {
    if (!menu) return undefined;
    // Reset focused index and move focus into the menu
    setFocusedIndex(0);
    return undefined;
  }, [menu]);

  // Focus the active menu item whenever focusedIndex changes
  useEffect(() => {
    if (!menu || focusedIndex < 0) return;
    const container = menuRef.current;
    if (!container) return;
    const items = container.querySelectorAll('[role="menuitem"]');
    const target = items[focusedIndex];
    if (target) {
      try {
        target.focus({ preventScroll: true });
      } catch {
        target.focus();
      }
    }
  }, [focusedIndex, menu]);

  useEffect(() => {
    if (!menu) return undefined;
    const items = menu.items || [];
    const handleKeyDown = (event) => {
      if (event.key === "Escape") {
        onClose?.();
        return;
      }
      if (event.key === "ArrowDown") {
        event.preventDefault();
        setFocusedIndex((prev) => (prev + 1) % items.length);
        return;
      }
      if (event.key === "ArrowUp") {
        event.preventDefault();
        setFocusedIndex((prev) => (prev - 1 + items.length) % items.length);
        return;
      }
      if (event.key === "Home") {
        event.preventDefault();
        setFocusedIndex(0);
        return;
      }
      if (event.key === "End") {
        event.preventDefault();
        setFocusedIndex(items.length - 1);
      }
    };
    window.addEventListener("keydown", handleKeyDown);
    return () => window.removeEventListener("keydown", handleKeyDown);
  }, [menu, onClose]);

  useEffect(() => {
    const targetEl = menu?.targetEl;
    if (!menu || !targetEl || typeof MutationObserver === "undefined") return undefined;
    if (!targetEl.isConnected) {
      onClose?.();
      return undefined;
    }
    const observer = new MutationObserver(() => {
      if (!targetEl.isConnected) {
        observer.disconnect();
        onClose?.();
      }
    });
    observer.observe(document.body, {
      childList: true,
      subtree: true,
    });
    return () => observer.disconnect();
  }, [menu, onClose]);

  useLayoutEffect(() => {
    if (!menu || !menuRef.current || typeof window === "undefined") return;
    const rect = menuRef.current.getBoundingClientRect();
    const nextX = Math.min(
      Math.max(SCREEN_GAP, Number(menu.point?.x || 0)),
      window.innerWidth - rect.width - SCREEN_GAP,
    );
    const preferY = Number(menu.point?.y || 0);
    const fitsBelow = preferY + rect.height + SCREEN_GAP <= window.innerHeight;
    const nextY = fitsBelow
      ? preferY
      : Math.max(SCREEN_GAP, preferY - rect.height);
    setDesktopPosition({ x: nextX, y: nextY });
    setVerticalPlacement(fitsBelow ? "below" : "above");
  }, [menu]);

  if (!menu || typeof document === "undefined") return null;

  return createPortal(
    <div
      className="fixed inset-0 z-200"
      onContextMenu={(event) => event.preventDefault()}
    >
      {/* Telegram-style Blurred Backdrop Overlay */}
      <button
        type="button"
        aria-label="Close context menu"
        className="absolute inset-0 h-full w-full cursor-default border-0 bg-black/40 backdrop-blur-xs p-0 transition-opacity animate-in fade-in duration-200"
        onClick={() => onClose?.()}
      />

      <div
        ref={menuRef}
        role="menu"
        aria-label="Context menu"
        className={`fixed overflow-hidden rounded-[1.4rem] border border-white/60 dark:border-cyan-500/25 bg-white/90 dark:bg-slate-900/90 text-slate-900 dark:text-slate-100 backdrop-blur-2xl shadow-[0_24px_60px_-12px_rgba(0,0,0,0.4),0_0_24px_rgba(14,165,233,0.18)] ${
          verticalPlacement === "below"
            ? "sb-context-menu-open-down"
            : "sb-context-menu-open-up"
        }`}
        style={{
          top: `${desktopPosition.y}px`,
          left: `${desktopPosition.x}px`,
          minWidth: "240px",
          maxWidth: "300px",
          transformOrigin:
            verticalPlacement === "below" ? "top left" : "bottom left",
        }}
      >
        {/* Telegram-Style Floating Reaction Bar */}
        <div className="flex items-center justify-between gap-1 border-b border-slate-100 px-3 py-2 dark:border-white/10 bg-slate-50/50 dark:bg-slate-800/40">
          {TELEGRAM_REACTIONS.map((emoji) => (
            <button
              key={emoji}
              type="button"
              className="flex h-8 w-8 items-center justify-center rounded-full text-lg transition-transform duration-150 hover:scale-135 hover:-translate-y-1 active:scale-95 cursor-pointer"
              onClick={() => {
                setActiveReaction(emoji);
                setTimeout(() => onClose?.(), 220);
              }}
              title={emoji}
            >
              <span className={`inline-block ${activeReaction === emoji ? "animate-bounce scale-140" : ""}`}>
                {emoji}
              </span>
            </button>
          ))}
        </div>

        <div className="py-1.5 px-1">
          {menu.items.map((item, index) => {
            const Icon = item.icon;
            const isDisabled = Boolean(item.disabled);
            return (
              <button
                key={item.id}
                type="button"
                role="menuitem"
                disabled={isDisabled}
                tabIndex={focusedIndex === index ? 0 : -1}
                onClick={() => {
                  if (isDisabled) return;
                  item.onSelect?.();
                  onClose?.();
                }}
                onFocus={() => setFocusedIndex(index)}
                className={`flex w-full items-center gap-3 px-3 py-2.5 text-left text-sm rounded-xl transition duration-150 ${
                  isDisabled
                    ? "cursor-not-allowed opacity-50 text-slate-400 dark:text-slate-500"
                    : item.danger
                      ? "text-rose-600 dark:text-rose-300 hover:bg-rose-500/10 active:scale-[0.98]"
                      : "hover:bg-cyan-500/10 dark:hover:bg-cyan-400/15 text-slate-800 dark:text-slate-100 active:scale-[0.98]"
                }`}
              >
                {Icon ? (
                  <span className="inline-flex h-4 w-4 shrink-0 items-center justify-center text-cyan-600 dark:text-cyan-400" aria-hidden="true">
                    <Icon size={16} />
                  </span>
                ) : null}
                <span className="min-w-0 flex-1 truncate font-medium">{item.label}</span>
              </button>
            );
          })}
        </div>
      </div>
    </div>,
    document.body,
  );
}
