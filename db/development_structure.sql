CREATE TABLE `applications` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `batches` (
  `id` int(11) NOT NULL auto_increment,
  `first_event` datetime NOT NULL,
  `last_event` datetime NOT NULL,
  `line_count` int(11) default NULL,
  `processing_time` int(11) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  `application_id` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `event_logs` (
  `id` int(11) NOT NULL auto_increment,
  `batch_id` int(11) NOT NULL,
  `log_source_id` int(11) NOT NULL,
  `log_source_type` varchar(255) NOT NULL,
  `event_count` int(11) default NULL,
  `mean_time` float default NULL,
  `max_time` float default NULL,
  `min_time` float default NULL,
  `median_time` float default NULL,
  `std_dev` float default NULL,
  `total_time` float default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `requests` (
  `id` int(11) NOT NULL auto_increment,
  `action` varchar(255) default NULL,
  `first_event` datetime default NULL,
  `most_recent_event` datetime default NULL,
  `application_id` int(11) NOT NULL,
  `time_source` varchar(16) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `templates` (
  `id` int(11) NOT NULL auto_increment,
  `path` varchar(255) default NULL,
  `first_event` datetime default NULL,
  `most_recent_event` datetime default NULL,
  `application_id` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO schema_migrations (version) VALUES ('1');

INSERT INTO schema_migrations (version) VALUES ('3');

INSERT INTO schema_migrations (version) VALUES ('4');

INSERT INTO schema_migrations (version) VALUES ('5');

INSERT INTO schema_migrations (version) VALUES ('7');

INSERT INTO schema_migrations (version) VALUES ('8');

INSERT INTO schema_migrations (version) VALUES ('9');