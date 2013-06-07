CREATE TABLE `mpd_contact_actions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mpd_contact_id` int(11) DEFAULT NULL,
  `event_id` int(11) DEFAULT NULL,
  `gift_amount` float DEFAULT NULL,
  `letter_sent` tinyint(1) DEFAULT '0',
  `contacted` tinyint(1) DEFAULT '0',
  `thankyou_sent` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `is_selected_letter` tinyint(1) DEFAULT NULL,
  `is_selected_call` tinyint(1) DEFAULT NULL,
  `is_selected_thankyou` tinyint(1) DEFAULT NULL,
  `postproject_sent` tinyint(1) DEFAULT '0',
  `partner_financial` tinyint(1) DEFAULT '0',
  `partner_prayer` tinyint(1) DEFAULT '0',
  `gift_pledged` tinyint(1) DEFAULT '0',
  `gift_received` tinyint(1) DEFAULT '0',
  `date_received` varchar(255) DEFAULT NULL,
  `form_received` varchar(255) DEFAULT 'Not Received',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_mpd_contact_actions_on_mpd_contact_id_and_event_id` (`mpd_contact_id`,`event_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12890 DEFAULT CHARSET=latin1;

CREATE TABLE `mpd_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mpd_user_id` int(11) DEFAULT NULL,
  `mpd_priority_id` int(11) DEFAULT NULL,
  `full_name` varchar(255) NOT NULL DEFAULT '',
  `address_1` varchar(255) DEFAULT '',
  `address_2` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT '',
  `state` varchar(255) DEFAULT '',
  `zip` varchar(255) DEFAULT '',
  `phone` varchar(255) DEFAULT '',
  `email_address` varchar(255) DEFAULT '',
  `notes` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `salutation` varchar(255) DEFAULT NULL,
  `phone_2` varchar(25) DEFAULT '',
  `relationship` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `mpd_contacts_mpd_user_id_index` (`mpd_user_id`),
  KEY `mpd_contacts_mpd_priority_id_index` (`mpd_priority_id`)
) ENGINE=InnoDB AUTO_INCREMENT=10082 DEFAULT CHARSET=latin1;

CREATE TABLE `mpd_events` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `cost` int(11) DEFAULT NULL,
  `mpd_user_id` int(11) DEFAULT NULL,
  `project_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `current_letter` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=429 DEFAULT CHARSET=latin1;

CREATE TABLE `mpd_expense_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `default_amount` float DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `mpd_expenses` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mpd_user_id` int(11) DEFAULT NULL,
  `mpd_expense_type_id` int(11) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT '0',
  `mpd_event_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mpd_expenses_mpd_user_id_index` (`mpd_user_id`),
  KEY `mpd_expenses_mpd_expense_type_id_index` (`mpd_expense_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `mpd_letter_images` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mpd_letter_id` int(11) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `content_type` varchar(255) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `thumbnail` varchar(255) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  `width` int(11) DEFAULT NULL,
  `height` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=382 DEFAULT CHARSET=latin1;

CREATE TABLE `mpd_letter_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `thumbnail_filename` varchar(255) DEFAULT '',
  `pdf_preview_filename` varchar(255) DEFAULT '',
  `description` text,
  `number_of_images` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

CREATE TABLE `mpd_letters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mpd_letter_template_id` int(11) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `salutation` varchar(255) DEFAULT 'Dear [[FULL_NAME]],',
  `update_section` text,
  `educate_section` text,
  `needs_section` text,
  `involve_section` text,
  `acknowledge_section` text,
  `closing` varchar(255) DEFAULT 'Thank you,',
  `printed_name` varchar(255) DEFAULT NULL,
  `mpd_user_id` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mpd_letters_mpd_letter_template_id_index` (`mpd_letter_template_id`),
  KEY `mpd_letters_mpd_user_id_index` (`mpd_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=216 DEFAULT CHARSET=latin1;

CREATE TABLE `mpd_priorities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mpd_user_id` int(11) NOT NULL DEFAULT '0',
  `rateable_id` int(11) NOT NULL DEFAULT '0',
  `priority` int(11) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `rateable_type` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `fk_mpd_priorities_mpd_user` (`mpd_user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2120 DEFAULT CHARSET=latin1;

CREATE TABLE `mpd_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `mpd_roles_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `mpd_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) NOT NULL,
  `data` text,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_mpd_sessions_on_session_id` (`session_id`),
  KEY `index_mpd_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB AUTO_INCREMENT=309644 DEFAULT CHARSET=latin1;

CREATE TABLE `mpd_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `mpd_role_id` int(11) DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `show_welcome` tinyint(1) DEFAULT '1',
  `show_follow_up_help` tinyint(1) DEFAULT '1',
  `show_calculator` tinyint(1) DEFAULT '1',
  `show_thank_help` tinyint(1) DEFAULT '1',
  `created_at` datetime DEFAULT NULL,
  `current_event_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `mpd_users_mpd_role_id_index` (`mpd_role_id`),
  KEY `mpd_users_user_id_index` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=385 DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('20081125201327');

INSERT INTO schema_migrations (version) VALUES ('20081126205214');

INSERT INTO schema_migrations (version) VALUES ('20081201212733');

INSERT INTO schema_migrations (version) VALUES ('20081205215020');

INSERT INTO schema_migrations (version) VALUES ('20081217194356');

INSERT INTO schema_migrations (version) VALUES ('20081217201612');

INSERT INTO schema_migrations (version) VALUES ('20090105185440');

INSERT INTO schema_migrations (version) VALUES ('20090113185048');

INSERT INTO schema_migrations (version) VALUES ('20100716144408');

INSERT INTO schema_migrations (version) VALUES ('20100805202342');

INSERT INTO schema_migrations (version) VALUES ('20100812144253');

INSERT INTO schema_migrations (version) VALUES ('20100812175727');