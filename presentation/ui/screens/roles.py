from aiogram.types import InlineKeyboardMarkup
from domain.enums import UserRole, AdvertiserType
from presentation.ui.keyboard import Btn, build_kb
from presentation.ui.callbacks import NavCb, RoleCb

def roles_screen() -> tuple[str, InlineKeyboardMarkup]:
	
    text = "Выберите, кем вы являетесь:"
    news_url = "https://t.me/news_teleport"
    kb = build_kb(
        [
            Btn("Я — владелец/админ канала", cb=RoleCb(role=UserRole.CHANNEL_OWNER.value).pack()),
            Btn("Я — рекламодатель", cb=RoleCb(role=UserRole.ADVERTISER.value).pack()),
            Btn("Как получить выплату?", cb=NavCb(action="open", screen="how_to_payment").pack()),
            Btn("Как добавить канал MAX?", cb=NavCb(action="open", screen="how_to_add_max").pack()),
	    Btn("Следить за новостями и обновлениями", url=news_url), 
        ],
        columns=1,
    )
    return text, kb