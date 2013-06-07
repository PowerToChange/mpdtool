delete from mpd_contacts;
delete from mpd_letters;
delete from mpd_letter_images;
update mpd_expenses set amount = 0.0;
delete from mpd_priorities;
update mpd_users set show_follow_up_help = 1;
update mpd_users set show_welcome = 1;
update mpd_users set show_calculator = 1;
