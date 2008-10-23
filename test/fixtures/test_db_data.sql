-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.0.41-community-nt


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO,MYSQL323' */;


USE activeanalyzer_test;

--
-- Dumping data for table `applications`
--

/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` (`id`,`name`,`created_at`,`updated_at`) VALUES 
 (1,'TestApp1','2008-09-19 03:05:54','2008-09-19 03:05:54'),
 (2,'TestApp2','2008-09-19 06:07:29','2008-09-19 06:07:29');
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;


--
-- Dumping data for table `batches`
--

/*!40000 ALTER TABLE `batches` DISABLE KEYS */;
INSERT INTO `batches` (`id`,`first_event`,`last_event`,`line_count`,`processing_time`,`created_at`,`updated_at`,`application_id`) VALUES 
 (2,'2008-07-31 06:40:43','2008-08-01 06:25:26',18207,2869,'2008-09-19 06:10:14','2008-09-19 06:10:14',2),
 (4,'2008-07-11 06:31:37','2008-07-12 06:25:26',14379,2605,'2008-09-19 06:10:39','2008-09-19 06:10:39',2),
 (5,'2008-07-26 06:40:10','2008-07-27 06:25:29',17027,3144,'2008-09-19 06:10:47','2008-09-19 06:10:47',2),
 (6,'2008-07-08 06:29:03','2008-07-09 06:25:27',12408,2193,'2008-09-19 06:10:54','2008-09-19 06:10:54',2),
 (7,'2008-07-09 06:32:07','2008-07-10 06:25:28',18382,2254,'2008-09-19 06:11:03','2008-09-19 06:11:03',1),
 (8,'2008-08-14 06:27:27','2008-08-15 06:25:26',9925,1249,'2008-09-19 06:11:09','2008-09-19 06:11:09',1);
/*!40000 ALTER TABLE `batches` ENABLE KEYS */;


--
-- Dumping data for table `event_logs`
--

/*!40000 ALTER TABLE `event_logs` DISABLE KEYS */;
INSERT INTO `event_logs` (`id`,`batch_id`,`log_source_id`,`log_source_type`,`event_count`,`mean_time`,`max_time`,`min_time`,`median_time`,`std_dev`,`total_time`) VALUES 
 (262,2,215,'Request',10,0.447844,1.61235,0.00421,0.010005,0.674065,4.47844),
 (263,2,214,'Request',10,0.603884,1.71602,0.05951,0.21881,0.635556,6.03884),
 (264,2,213,'Request',10,0.045157,0.05527,0.03142,0.046865,0.00712783,0.45157),
 (265,2,216,'Request',10,0.110883,0.16509,0.00609,0.150135,0.0559215,1.10883),
 (266,2,219,'Request',1,0.02644,0.02644,0.02644,0.02644,0,0.02644),
 (267,2,218,'Request',1,0.28279,0.28279,0.28279,0.28279,0,0.28279),
 (268,2,217,'Request',1,0.10065,0.10065,0.10065,0.10065,0,0.10065),
 (269,2,220,'Request',1,0.1557,0.1557,0.1557,0.1557,0,0.1557),
 (278,2,231,'Request',148,0.00701507,0.01285,0.00095,0.00714,0.00229166,1.03823),
 (279,2,230,'Request',148,0.10209,0.39802,0.05881,0.081735,0.0744634,15.1093),
 (280,2,229,'Request',148,0.0912841,0.38755,0.05087,0.07096,0.0722618,13.51),
 (281,2,232,'Request',148,0.00379041,0.19575,0.00108,0.00184,0.0159168,0.56098),
 (293,2,53,'Template',34,0.109073,0.39092,0.03881,0.05396,0.10844,3.70849),
 (305,2,65,'Template',299,0.0275262,0.31843,0.01562,0.02174,0.0337445,8.23034),
 (311,2,71,'Template',5,0.019886,0.04931,0.0089,0.0106,0.0154367,0.09943),
 (314,2,74,'Template',299,0.00533341,0.01329,0.0002,0.00556,0.00163154,1.59469),
 (316,2,76,'Template',242,0.000913223,0.01727,0,0.000625,0.00127581,0.221),
 (317,2,77,'Template',242,0.000941736,0.00582,1e-005,0.00073,0.000845383,0.2279),
 (426,3,215,'Request',4,0.01066,0.0126,0.00826,0.01089,0.001558,0.04264),
 (427,3,214,'Request',4,0.237363,0.24936,0.22016,0.239965,0.0106472,0.94945),
 (428,3,213,'Request',4,0.0493025,0.05546,0.04335,0.0492,0.00431208,0.19721),
 (429,3,216,'Request',4,0.1774,0.19018,0.15916,0.18013,0.0127545,0.7096),
 (438,3,219,'Request',1,0.01518,0.01518,0.01518,0.01518,0,0.01518),
 (439,3,218,'Request',1,0.2694,0.2694,0.2694,0.2694,0,0.2694),
 (440,3,217,'Request',1,0.0685,0.0685,0.0685,0.0685,0,0.0685),
 (441,3,220,'Request',1,0.18572,0.18572,0.18572,0.18572,0,0.18572),
 (442,3,231,'Request',164,0.00684616,0.01266,0.00098,0.00706,0.00227902,1.12277),
 (443,3,230,'Request',164,0.116144,0.40331,0.06237,0.084305,0.085716,19.0477),
 (444,3,229,'Request',164,0.105793,0.39133,0.05319,0.075125,0.0831189,17.35),
 (445,3,232,'Request',164,0.00350561,0.05008,0.00109,0.001785,0.00637432,0.57492),
 (472,3,53,'Template',11,0.0780964,0.2642,0.03944,0.05019,0.0628633,0.85906),
 (489,3,65,'Template',270,0.031773,0.30685,0.01609,0.02264,0.0424069,8.57872),
 (496,3,71,'Template',3,0.0118633,0.01508,0.01009,0.01042,0.00227851,0.03559),
 (502,3,74,'Template',270,0.00617563,0.02763,0.00022,0.005695,0.00291472,1.66742),
 (508,3,76,'Template',244,0.000955041,0.01835,1e-005,0.00068,0.00134907,0.23303),
 (509,3,77,'Template',244,0.00221074,0.28916,0,0.00075,0.0184399,0.53942),
 (609,4,215,'Request',5,0.015158,0.04146,0.0062,0.00637,0.0136317,0.07579),
 (610,4,214,'Request',5,0.23897,0.35033,0.20118,0.20912,0.0562453,1.19485),
 (611,4,213,'Request',5,0.130686,0.34129,0.07274,0.0822,0.105374,0.65343),
 (612,4,216,'Request',5,0.093126,0.12012,0.00284,0.11247,0.0452738,0.46563),
 (617,4,219,'Request',2,0.025045,0.02562,0.02447,0.025045,0.000575,0.05009),
 (618,4,218,'Request',2,0.21662,0.22075,0.21249,0.21662,0.00413,0.43324),
 (619,4,217,'Request',2,0.07659,0.08966,0.06352,0.07659,0.01307,0.15318),
 (620,4,220,'Request',2,0.114985,0.12335,0.10662,0.114985,0.008365,0.22997),
 (629,4,231,'Request',207,0.00668256,0.01762,0.00025,0.00658,0.00244459,1.38329),
 (630,4,230,'Request',207,0.120073,0.43265,0.05976,0.08755,0.0906664,24.8551),
 (631,4,229,'Request',207,0.110751,0.42184,0.05243,0.07784,0.0905173,22.9254),
 (632,4,232,'Request',207,0.00263981,0.00951,0.00105,0.00185,0.00162958,0.54644),
 (645,4,53,'Template',5,0.132928,0.40824,0.05285,0.06532,0.137836,0.66464),
 (663,4,65,'Template',341,0.0347906,0.34567,0.01609,0.02389,0.0482774,11.8636),
 (668,4,71,'Template',8,0.0171237,0.02377,0.01017,0.017155,0.00552646,0.13699),
 (676,4,74,'Template',341,0.00681933,0.05849,0.00035,0.0062,0.00456085,2.32539),
 (682,4,76,'Template',311,0.000964244,0.00836,0,0.00063,0.00105988,0.29988),
 (683,4,77,'Template',311,0.00117466,0.00766,1e-005,0.00077,0.00112782,0.36532),
 (763,5,215,'Request',3,0.00800667,0.01056,0.00543,0.00803,0.00209438,0.02402),
 (764,5,214,'Request',3,0.194687,0.19639,0.19261,0.19506,0.0015656,0.58406),
 (765,5,213,'Request',3,0.0561233,0.05936,0.05406,0.05495,0.00231733,0.16837),
 (766,5,216,'Request',3,0.130557,0.13297,0.12647,0.13223,0.00290546,0.39167),
 (771,5,231,'Request',191,0.00806728,0.0332,0.001,0.0077,0.00401611,1.54085),
 (772,5,230,'Request',191,0.137486,0.76908,0.06016,0.08813,0.129537,26.2599),
 (773,5,229,'Request',191,0.127,0.75102,0.05018,0.07744,0.127561,24.257),
 (774,5,232,'Request',191,0.00241911,0.00757,0.00118,0.00168,0.00136387,0.46205),
 (783,5,53,'Template',179,0.122457,0.5898,0.04247,0.0929,0.088018,21.9199),
 (791,5,65,'Template',316,0.0300653,0.31895,0.01564,0.02288,0.0341577,9.50062),
 (794,5,71,'Template',3,0.0132,0.0144,0.01205,0.01315,0.000960035,0.0396),
 (798,5,74,'Template',316,0.00585263,0.02985,0.00023,0.00575,0.00286501,1.84943),
 (800,5,76,'Template',295,0.000910814,0.02945,1e-005,0.00064,0.0017682,0.26869),
 (801,5,77,'Template',295,0.00104088,0.00665,0,0.00078,0.000915948,0.30706),
 (880,6,215,'Request',3,0.0123867,0.01523,0.01048,0.01145,0.00204917,0.03716),
 (881,6,214,'Request',3,0.169763,0.18219,0.1598,0.1673,0.00930516,0.50929),
 (882,6,213,'Request',3,0.05712,0.06555,0.04934,0.05647,0.00663365,0.17136),
 (883,6,216,'Request',3,0.100257,0.10141,0.09901,0.10035,0.000982016,0.30077),
 (888,6,231,'Request',164,0.00667854,0.01864,0.00075,0.006695,0.00251531,1.09528),
 (889,6,230,'Request',164,0.118004,0.44538,0.06516,0.09214,0.0841176,19.3526),
 (890,6,229,'Request',164,0.108216,0.435,0.05497,0.082635,0.0838879,17.7474),
 (891,6,232,'Request',164,0.00310951,0.02068,0.00104,0.00213,0.00258178,0.50996),
 (900,6,53,'Template',25,0.0517324,0.07447,0.04272,0.05073,0.00746936,1.29331),
 (908,6,65,'Template',275,0.0350878,0.38365,0.0167,0.02484,0.0492671,9.64914),
 (911,6,71,'Template',1,0.0111,0.0111,0.0111,0.0111,0,0.0111),
 (915,6,74,'Template',275,0.00636778,0.03307,0.00031,0.0063,0.00267371,1.75114),
 (917,6,76,'Template',243,0.000897531,0.00401,0,0.00067,0.000721971,0.2181),
 (918,6,77,'Template',243,0.00123309,0.00576,3e-005,0.00089,0.00101516,0.29964),
 (1045,7,215,'Request',1,0.01294,0.01294,0.01294,0.01294,0,0.01294),
 (1046,7,214,'Request',1,0.18957,0.18957,0.18957,0.18957,0,0.18957),
 (1047,7,213,'Request',1,0.07152,0.07152,0.07152,0.07152,0,0.07152),
 (1048,7,216,'Request',1,0.10511,0.10511,0.10511,0.10511,0,0.10511),
 (1053,7,219,'Request',3,0.02705,0.03573,0.02225,0.02317,0.00614917,0.08115),
 (1054,7,218,'Request',3,0.20113,0.21193,0.19372,0.19774,0.00781111,0.60339),
 (1055,7,217,'Request',3,0.0683133,0.07043,0.06688,0.06763,0.00152771,0.20494),
 (1056,7,220,'Request',3,0.105767,0.10769,0.10384,0.10577,0.00157176,0.3173),
 (1073,7,231,'Request',194,0.00645371,0.02912,0.00023,0.005805,0.00324684,1.25202),
 (1074,7,230,'Request',194,0.109443,0.38157,0.0629,0.086895,0.0720417,21.2318),
 (1075,7,229,'Request',194,0.0998352,0.35991,0.05517,0.076975,0.0711865,19.368),
 (1076,7,232,'Request',194,0.00315366,0.04603,0.00103,0.001905,0.00467064,0.61181),
 (1113,7,53,'Template',13,0.0762931,0.32831,0.04443,0.05413,0.0732108,0.99181),
 (1124,7,77,'Template',397,0.00195715,0.2764,0,0.00076,0.0138741,0.77699),
 (1125,7,74,'Template',437,0.00723606,0.2208,0.00031,0.00599,0.0110097,3.16216),
 (1150,7,65,'Template',437,0.0360592,0.37245,0.01749,0.02608,0.0477964,15.7578),
 (1156,7,76,'Template',397,0.000881511,0.01024,0,0.0006,0.000904665,0.34996),
 (1157,7,71,'Template',7,0.0189314,0.02444,0.01002,0.02303,0.00554106,0.13252),
 (1244,8,215,'Request',3,0.0107,0.01718,0.00608,0.00884,0.00471856,0.0321),
 (1245,8,214,'Request',3,0.257613,0.27914,0.23566,0.25804,0.0177532,0.77284),
 (1246,8,213,'Request',3,0.04848,0.05459,0.04419,0.04666,0.00443654,0.14544),
 (1247,8,216,'Request',3,0.198433,0.20777,0.18016,0.20737,0.0129222,0.5953),
 (1252,8,219,'Request',1,0.01281,0.01281,0.01281,0.01281,0,0.01281),
 (1253,8,218,'Request',1,0.24483,0.24483,0.24483,0.24483,0,0.24483),
 (1254,8,217,'Request',1,0.05283,0.05283,0.05283,0.05283,0,0.05283),
 (1255,8,220,'Request',1,0.17919,0.17919,0.17919,0.17919,0,0.17919),
 (1260,8,231,'Request',135,0.00794541,0.01473,0.001,0.00807,0.00212529,1.07263),
 (1261,8,230,'Request',135,0.117839,0.41703,0.06585,0.09183,0.0843589,15.9082),
 (1262,8,229,'Request',135,0.107396,0.40586,0.05974,0.08098,0.0839322,14.4985),
 (1263,8,232,'Request',135,0.00249733,0.00814,0.00097,0.00182,0.00142634,0.33714),
 (1278,8,53,'Template',22,0.0625586,0.32551,0.04309,0.048735,0.0575783,1.37629),
 (1287,8,65,'Template',216,0.0304016,0.31977,0.016,0.02242,0.0432546,6.56674),
 (1291,8,71,'Template',2,0.011695,0.01188,0.01151,0.011695,0.000185,0.02339),
 (1296,8,74,'Template',216,0.00703519,0.29274,0.00032,0.005735,0.0196201,1.5196),
 (1300,8,76,'Template',186,0.00105608,0.0354,2e-005,0.00066,0.00262034,0.19643),
 (1301,8,77,'Template',186,0.00134022,0.00618,0,0.000945,0.00123475,0.24928);
/*!40000 ALTER TABLE `event_logs` ENABLE KEYS */;


--
-- Dumping data for table `requests`
--

/*!40000 ALTER TABLE `requests` DISABLE KEYS */;
INSERT INTO `requests` (`id`,`action`,`first_event`,`most_recent_event`,`application_id`,`time_source`) VALUES 
 (213,'AccountController#signup','2008-07-01 07:58:45','2008-10-03 23:29:44',2,'render'),
 (214,'AccountController#signup','2008-07-01 07:58:45','2008-10-03 23:29:44',2,'total'),
 (215,'AccountController#signup','2008-07-01 07:58:45','2008-10-03 23:29:44',2,'action'),
 (216,'AccountController#signup','2008-07-01 07:58:45','2008-10-03 23:29:44',2,'db'),
 (217,'AccountController#login','2008-07-02 12:27:05','2008-10-04 01:15:31',2,'render'),
 (218,'AccountController#login','2008-07-02 12:27:05','2008-10-04 01:15:31',2,'total'),
 (219,'AccountController#login','2008-07-02 12:27:05','2008-10-04 01:15:31',2,'action'),
 (220,'AccountController#login','2008-07-02 12:27:05','2008-10-04 01:15:31',2,'db'),
 (229,'SearchController#view','2008-07-01 06:31:58','2008-10-04 06:15:11',2,'render'),
 (230,'SearchController#view','2008-07-01 06:31:58','2008-10-04 06:15:11',2,'total'),
 (231,'SearchController#view','2008-07-01 06:31:58','2008-10-04 06:15:11',2,'action'),
 (232,'SearchController#view','2008-07-01 06:31:58','2008-10-04 06:15:11',2,'db');
/*!40000 ALTER TABLE `requests` ENABLE KEYS */;


--
-- Dumping data for table `templates`
--

/*!40000 ALTER TABLE `templates` DISABLE KEYS */;
INSERT INTO `templates` (`id`,`path`,`first_event`,`most_recent_event`,`application_id`) VALUES 
 (53,'mytrails/_list','2008-07-01 06:28:47','2008-10-04 01:15:46',2),
 (65,'shared/_top','2008-07-01 06:28:47','2008-10-04 06:18:37',2),
 (71,'account/_remotelogin','2008-07-01 12:55:41','2008-10-04 03:55:20',2),
 (74,'shared/_account_links','2008-07-01 06:28:47','2008-10-04 06:18:37',2),
 (76,'shared/_panel_toggle','2008-07-01 06:31:58','2008-10-04 06:18:37',2),
 (77,'shared/_tabs','2008-07-01 06:31:58','2008-10-04 06:18:37',2);
/*!40000 ALTER TABLE `templates` ENABLE KEYS */;




/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;