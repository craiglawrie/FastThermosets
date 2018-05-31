
DROP TABLE IF EXISTS dsc_data_interpolation;
DROP TABLE IF EXISTS dsc_data_values;
DROP TABLE IF EXISTS dsc_data;
DROP TABLE IF EXISTS user_component_category_associative;
DROP TABLE IF EXISTS user_component_associative;
DROP TABLE IF EXISTS user_system_associative;
DROP TABLE IF EXISTS resin_system_component_associative;
DROP TABLE IF EXISTS resin_component;
DROP TABLE IF EXISTS component_category;
DROP TABLE IF EXISTS resin_system;


CREATE TABLE resin_system (
	id				int				identity(1,1),
	nickname		varchar(max)	NOT NULL,
	created_date	date			DEFAULT(GETDATE()),

	CONSTRAINT pk_resin_system PRIMARY KEY (id)
);

CREATE TABLE component_category (
	id				int				identity(1,1),
	[description]	varchar(max)	NOT NULL,
	created_date	date			DEFAULT(GETDATE()),

	CONSTRAINT pk_component_category PRIMARY KEY (id)
);

CREATE TABLE resin_component (
	id						int				identity(1,1),
	[name]					varchar(max)	NOT NULL,
	manufacturer			varchar(max)	NOT NULL,
	component_category_id	int				NOT NULL,
	created_date			date			DEFAULT(GETDATE()),

	CONSTRAINT pk_resin_component PRIMARY KEY (id),
	CONSTRAINT fk_resin_component_component_category FOREIGN KEY (component_category_id) REFERENCES component_category (id)
);

CREATE TABLE resin_system_component_associative (
	resin_system_id		int		NOT NULL,
	resin_component_id	int		NOT NULL,
	parts_by_weight		int		DEFAULT (100),

	CONSTRAINT pk_resin_system_component_associative PRIMARY KEY (resin_system_id, resin_component_id),
	CONSTRAINT fk_rsca_resin_system FOREIGN KEY (resin_system_id) REFERENCES resin_system (id),
	CONSTRAINT fk_rsca_resin_component FOREIGN KEY (resin_component_id) REFERENCES resin_component (id)
);

CREATE TABLE user_system_associative (
	[user_id]			nvarchar(128)		NOT NULL,
	resin_system_id		int					NOT NULL,

	CONSTRAINT pk_user_system_associative PRIMARY KEY ([user_id], resin_system_id),
	CONSTRAINT fk_usa_aspnetusers FOREIGN KEY ([user_id]) REFERENCES AspNetUsers (id),
	CONSTRAINT fk_usa_resin_system FOREIGN KEY (resin_system_id) REFERENCES resin_system (id)
);

CREATE TABLE user_component_associative (
	[user_id]				nvarchar(128)		NOT NULL,
	resin_component_id		int					NOT NULL,

	CONSTRAINT pk_user_component_associative PRIMARY KEY ([user_id], resin_component_id),
	CONSTRAINT fk_uca_aspnetusers FOREIGN KEY ([user_id]) REFERENCES AspNetUsers (id),
	CONSTRAINT fk_uca_resin_component FOREIGN KEY (resin_component_id) REFERENCES resin_component (id)
);

CREATE TABLE user_component_category_associative (
	[user_id]				nvarchar(128)		NOT NULL,
	component_category_id	int					NOT NULL,

	CONSTRAINT pk_component_category_associative PRIMARY KEY ([user_id], component_category_id),
	CONSTRAINT fk_ucca_aspnetusers FOREIGN KEY ([user_id]) REFERENCES AspNetUsers (id),
	CONSTRAINT fk_ucca_component_category FOREIGN KEY (component_category_id) REFERENCES component_category (id)
);

CREATE TABLE dsc_data (
	id					int		identity(1,1),
	resin_system_id		int		NOT NULL,

	CONSTRAINT pk_dsc_data PRIMARY KEY (id),
	CONSTRAINT fk_dsc_data_resin_system FOREIGN KEY (resin_system_id) REFERENCES resin_system (id)
);

CREATE TABLE dsc_data_values (
	dsc_data_id			int			NOT NULL,
	[index]				int			NOT NULL,
	time_in_s			numeric		NOT NULL,
	temperature_in_k	numeric		NOT NULL,
	heat_flux_in_w		numeric		NOT NULL,

	CONSTRAINT pk_dsc_data_values PRIMARY KEY (dsc_data_id, [index]),
	CONSTRAINT fk_dsc_data_values_dsc_data FOREIGN KEY (dsc_data_id) REFERENCES dsc_data (id)
);

CREATE TABLE dsc_data_interpolation (
	dsc_data_id			int			NOT NULL,
	degree_of_cure		numeric		NOT NULL,
	time_in_s			numeric		NOT NULL,
	temperature_in_k	numeric		NOT NULL,
	heat_flux_in_w		numeric		NOT NULL,

	CONSTRAINT pk_dsc_data_interpolation PRIMARY KEY (dsc_data_id, degree_of_cure),
	CONSTRAINT fk_dsc_data_interpololation_dsc_data FOREIGN KEY (dsc_data_id) REFERENCES dsc_data (id)
);