WITH herp_attributes AS (
	SELECT
		attributes.attribute_id,
		attributes.collection_object_id,
		attributes.attribute_type,
		attributes.attribute_value,
		attributes.attribute_units,
		attributes.determined_date,
		TO_CHAR(attributes.determined_date, 'YYYY-MM-DD') AS determined_date_text,
		MCZBASE.get_agentnameoftype(attributes.determined_by_agent_id, 'preferred') AS determiner,
		COUNT(*) OVER (PARTITION BY attributes.collection_object_id, attributes.attribute_type) AS values_of_type
	FROM
		filtered_flat ff
		JOIN attributes ON ff.collection_object_id = attributes.collection_object_id
	WHERE
		ff.collection_cde = 'Herp'
		AND attributes.attribute_type IN (
			'sex',
			'age class',
			'body diameter',
			'carapace height',
			'carapace length',
			'carapace width',
			'chest width',
			'crus length',
			'ear (tympanum) width',
			'eye width',
			'eye-nostril distance',
			'eye-tympanum distance',
			'femur length',
			'foot length',
			'forearm (antebrachium) length',
			'forelimb length',
			'hand length',
			'head height',
			'head length',
			'head width',
			'hindlimb length',
			'humerus length',
			'internarial distance',
			'interocular width',
			'plastron length',
			'plastron width',
			'quadratojugal height',
			'quadratojugal length',
			'size',
			'snout-ear length',
			'snout-eye length',
			'snout-vent length',
			'tail height',
			'tail length',
			'tail width',
			'tarsus length',
			'tibia length',
			'total length',
			'total size',
			'trunk length',
			'tympanum width',
			'ulna length',
			'upper eyelid width',
			'weight',
			'dentary teeth',
			'dorsal scale rows (DSR)',
			'infralabials',
			'maxillary teeth',
			'midbody scale rows',
			'palatine teeth',
			'paravertebrals',
			'postoculars',
			'preoculars',
			'pterygoid teeth',
			'subcaudals',
			'supracilliaries',
			'supralabials',
			'temporals',
			'ventrals'
		)
),
pivoted AS (
	SELECT
		ha.collection_object_id,
		LISTAGG(CASE WHEN ha.attribute_type = 'sex' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "sex",
		LISTAGG(CASE WHEN ha.attribute_type = 'sex' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "sex units",
		LISTAGG(CASE WHEN ha.attribute_type = 'sex' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "sex determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'sex' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "sex determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'age class' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "age class",
		LISTAGG(CASE WHEN ha.attribute_type = 'age class' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "age class determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'age class' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "age class determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'body diameter' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "body diameter",
		LISTAGG(CASE WHEN ha.attribute_type = 'body diameter' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "body diameter units",
		LISTAGG(CASE WHEN ha.attribute_type = 'body diameter' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "body diameter determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'body diameter' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "body diameter determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'carapace height' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "carapace height",
		LISTAGG(CASE WHEN ha.attribute_type = 'carapace height' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "carapace height units",
		LISTAGG(CASE WHEN ha.attribute_type = 'carapace height' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "carapace height determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'carapace height' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "carapace height determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'carapace length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "carapace length",
		LISTAGG(CASE WHEN ha.attribute_type = 'carapace length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "carapace length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'carapace length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "carapace length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'carapace length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "carapace length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'carapace width' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "carapace width",
		LISTAGG(CASE WHEN ha.attribute_type = 'carapace width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "carapace width units",
		LISTAGG(CASE WHEN ha.attribute_type = 'carapace width' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "carapace width determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'carapace width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "carapace width determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'chest width' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "chest width",
		LISTAGG(CASE WHEN ha.attribute_type = 'chest width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "chest width units",
		LISTAGG(CASE WHEN ha.attribute_type = 'chest width' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "chest width determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'chest width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "chest width determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'crus length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "crus length",
		LISTAGG(CASE WHEN ha.attribute_type = 'crus length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "crus length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'crus length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "crus length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'crus length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "crus length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'ear (tympanum) width' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "ear (tympanum) width",
		LISTAGG(CASE WHEN ha.attribute_type = 'ear (tympanum) width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "ear (tympanum) width units",
		LISTAGG(CASE WHEN ha.attribute_type = 'ear (tympanum) width' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "ear (tympanum) width determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'ear (tympanum) width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "ear (tympanum) width determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'eye width' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "eye width",
		LISTAGG(CASE WHEN ha.attribute_type = 'eye width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "eye width units",
		LISTAGG(CASE WHEN ha.attribute_type = 'eye width' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "eye width determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'eye width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "eye width determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'eye-nostril distance' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "eye-nostril distance",
		LISTAGG(CASE WHEN ha.attribute_type = 'eye-nostril distance' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "eye-nostril distance units",
		LISTAGG(CASE WHEN ha.attribute_type = 'eye-nostril distance' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "eye-nostril distance determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'eye-nostril distance' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "eye-nostril distance determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'eye-tympanum distance' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "eye-tympanum distance",
		LISTAGG(CASE WHEN ha.attribute_type = 'eye-tympanum distance' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "eye-tympanum distance units",
		LISTAGG(CASE WHEN ha.attribute_type = 'eye-tympanum distance' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "eye-tympanum distance determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'eye-tympanum distance' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "eye-tympanum distance determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'femur length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "femur length",
		LISTAGG(CASE WHEN ha.attribute_type = 'femur length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "femur length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'femur length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "femur length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'femur length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "femur length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'foot length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "foot length",
		LISTAGG(CASE WHEN ha.attribute_type = 'foot length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "foot length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'foot length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "foot length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'foot length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "foot length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'forearm (antebrachium) length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "forearm (antebrachium) length",
		LISTAGG(CASE WHEN ha.attribute_type = 'forearm (antebrachium) length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "forearm (antebrachium) length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'forearm (antebrachium) length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "forearm (antebrachium) length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'forearm (antebrachium) length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "forearm (antebrachium) length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'forelimb length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "forelimb length",
		LISTAGG(CASE WHEN ha.attribute_type = 'forelimb length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "forelimb length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'forelimb length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "forelimb length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'forelimb length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "forelimb length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'hand length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "hand length",
		LISTAGG(CASE WHEN ha.attribute_type = 'hand length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "hand length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'hand length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "hand length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'hand length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "hand length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'head height' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "head height",
		LISTAGG(CASE WHEN ha.attribute_type = 'head height' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "head height units",
		LISTAGG(CASE WHEN ha.attribute_type = 'head height' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "head height determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'head height' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "head height determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'head length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "head length",
		LISTAGG(CASE WHEN ha.attribute_type = 'head length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "head length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'head length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "head length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'head length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "head length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'head width' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "head width",
		LISTAGG(CASE WHEN ha.attribute_type = 'head width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "head width units",
		LISTAGG(CASE WHEN ha.attribute_type = 'head width' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "head width determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'head width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "head width determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'hindlimb length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "hindlimb length",
		LISTAGG(CASE WHEN ha.attribute_type = 'hindlimb length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "hindlimb length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'hindlimb length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "hindlimb length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'hindlimb length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "hindlimb length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'humerus length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "humerus length",
		LISTAGG(CASE WHEN ha.attribute_type = 'humerus length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "humerus length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'humerus length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "humerus length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'humerus length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "humerus length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'internarial distance' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "internarial distance",
		LISTAGG(CASE WHEN ha.attribute_type = 'internarial distance' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "internarial distance units",
		LISTAGG(CASE WHEN ha.attribute_type = 'internarial distance' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "internarial distance determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'internarial distance' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "internarial distance determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'interocular width' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "interocular width",
		LISTAGG(CASE WHEN ha.attribute_type = 'interocular width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "interocular width units",
		LISTAGG(CASE WHEN ha.attribute_type = 'interocular width' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "interocular width determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'interocular width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "interocular width determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'plastron length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "plastron length",
		LISTAGG(CASE WHEN ha.attribute_type = 'plastron length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "plastron length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'plastron length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "plastron length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'plastron length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "plastron length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'plastron width' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "plastron width",
		LISTAGG(CASE WHEN ha.attribute_type = 'plastron width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "plastron width units",
		LISTAGG(CASE WHEN ha.attribute_type = 'plastron width' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "plastron width determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'plastron width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "plastron width determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'quadratojugal height' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "quadratojugal height",
		LISTAGG(CASE WHEN ha.attribute_type = 'quadratojugal height' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "quadratojugal height units",
		LISTAGG(CASE WHEN ha.attribute_type = 'quadratojugal height' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "quadratojugal height determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'quadratojugal height' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "quadratojugal height determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'quadratojugal length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "quadratojugal length",
		LISTAGG(CASE WHEN ha.attribute_type = 'quadratojugal length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "quadratojugal length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'quadratojugal length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "quadratojugal length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'quadratojugal length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "quadratojugal length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'size' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "size",
		LISTAGG(CASE WHEN ha.attribute_type = 'size' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "size units",
		LISTAGG(CASE WHEN ha.attribute_type = 'size' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "size determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'size' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "size determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'snout-ear length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "snout-ear length",
		LISTAGG(CASE WHEN ha.attribute_type = 'snout-ear length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "snout-ear length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'snout-ear length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "snout-ear length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'snout-ear length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "snout-ear length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'snout-eye length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "snout-eye length",
		LISTAGG(CASE WHEN ha.attribute_type = 'snout-eye length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "snout-eye length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'snout-eye length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "snout-eye length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'snout-eye length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "snout-eye length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'snout-vent length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "snout-vent length",
		LISTAGG(CASE WHEN ha.attribute_type = 'snout-vent length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "snout-vent length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'snout-vent length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "snout-vent length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'snout-vent length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "snout-vent length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'tail height' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tail height",
		LISTAGG(CASE WHEN ha.attribute_type = 'tail height' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tail height units",
		LISTAGG(CASE WHEN ha.attribute_type = 'tail height' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tail height determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'tail height' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tail height determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'tail length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tail length",
		LISTAGG(CASE WHEN ha.attribute_type = 'tail length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tail length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'tail length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tail length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'tail length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tail length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'tail width' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tail width",
		LISTAGG(CASE WHEN ha.attribute_type = 'tail width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tail width units",
		LISTAGG(CASE WHEN ha.attribute_type = 'tail width' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tail width determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'tail width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tail width determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'tarsus length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tarsus length",
		LISTAGG(CASE WHEN ha.attribute_type = 'tarsus length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tarsus length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'tarsus length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tarsus length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'tarsus length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tarsus length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'tibia length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tibia length",
		LISTAGG(CASE WHEN ha.attribute_type = 'tibia length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tibia length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'tibia length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tibia length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'tibia length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tibia length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'total length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "total length",
		LISTAGG(CASE WHEN ha.attribute_type = 'total length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "total length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'total length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "total length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'total length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "total length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'total size' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "total size",
		LISTAGG(CASE WHEN ha.attribute_type = 'total size' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "total size units",
		LISTAGG(CASE WHEN ha.attribute_type = 'total size' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "total size determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'total size' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "total size determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'trunk length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "trunk length",
		LISTAGG(CASE WHEN ha.attribute_type = 'trunk length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "trunk length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'trunk length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "trunk length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'trunk length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "trunk length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'tympanum width' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tympanum width",
		LISTAGG(CASE WHEN ha.attribute_type = 'tympanum width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tympanum width units",
		LISTAGG(CASE WHEN ha.attribute_type = 'tympanum width' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tympanum width determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'tympanum width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "tympanum width determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'ulna length' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "ulna length",
		LISTAGG(CASE WHEN ha.attribute_type = 'ulna length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "ulna length units",
		LISTAGG(CASE WHEN ha.attribute_type = 'ulna length' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "ulna length determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'ulna length' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "ulna length determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'upper eyelid width' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "upper eyelid width",
		LISTAGG(CASE WHEN ha.attribute_type = 'upper eyelid width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "upper eyelid width units",
		LISTAGG(CASE WHEN ha.attribute_type = 'upper eyelid width' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "upper eyelid width determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'upper eyelid width' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "upper eyelid width determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'weight' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "weight",
		LISTAGG(CASE WHEN ha.attribute_type = 'weight' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.attribute_units, 'no units') ELSE ha.attribute_units END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "weight units",
		LISTAGG(CASE WHEN ha.attribute_type = 'weight' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "weight determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'weight' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "weight determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'dentary teeth' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "dentary teeth",
		LISTAGG(CASE WHEN ha.attribute_type = 'dentary teeth' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "dentary teeth determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'dentary teeth' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "dentary teeth determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'dorsal scale rows (DSR)' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "dorsal scale rows (DSR)",
		LISTAGG(CASE WHEN ha.attribute_type = 'dorsal scale rows (DSR)' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "dorsal scale rows (DSR) determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'dorsal scale rows (DSR)' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "dorsal scale rows (DSR) determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'infralabials' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "infralabials",
		LISTAGG(CASE WHEN ha.attribute_type = 'infralabials' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "infralabials determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'infralabials' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "infralabials determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'maxillary teeth' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "maxillary teeth",
		LISTAGG(CASE WHEN ha.attribute_type = 'maxillary teeth' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "maxillary teeth determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'maxillary teeth' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "maxillary teeth determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'midbody scale rows' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "midbody scale rows",
		LISTAGG(CASE WHEN ha.attribute_type = 'midbody scale rows' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "midbody scale rows determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'midbody scale rows' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "midbody scale rows determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'palatine teeth' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "palatine teeth",
		LISTAGG(CASE WHEN ha.attribute_type = 'palatine teeth' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "palatine teeth determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'palatine teeth' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "palatine teeth determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'paravertebrals' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "paravertebrals",
		LISTAGG(CASE WHEN ha.attribute_type = 'paravertebrals' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "paravertebrals determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'paravertebrals' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "paravertebrals determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'postoculars' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "postoculars",
		LISTAGG(CASE WHEN ha.attribute_type = 'postoculars' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "postoculars determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'postoculars' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "postoculars determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'preoculars' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "preoculars",
		LISTAGG(CASE WHEN ha.attribute_type = 'preoculars' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "preoculars determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'preoculars' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "preoculars determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'pterygoid teeth' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "pterygoid teeth",
		LISTAGG(CASE WHEN ha.attribute_type = 'pterygoid teeth' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "pterygoid teeth determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'pterygoid teeth' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "pterygoid teeth determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'subcaudals' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "subcaudals",
		LISTAGG(CASE WHEN ha.attribute_type = 'subcaudals' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "subcaudals determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'subcaudals' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "subcaudals determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'supracilliaries' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "supracilliaries",
		LISTAGG(CASE WHEN ha.attribute_type = 'supracilliaries' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "supracilliaries determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'supracilliaries' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "supracilliaries determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'supralabials' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "supralabials",
		LISTAGG(CASE WHEN ha.attribute_type = 'supralabials' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "supralabials determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'supralabials' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "supralabials determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'temporals' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "temporals",
		LISTAGG(CASE WHEN ha.attribute_type = 'temporals' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "temporals determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'temporals' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "temporals determined date",
		LISTAGG(CASE WHEN ha.attribute_type = 'ventrals' THEN ha.attribute_value END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "ventrals",
		LISTAGG(CASE WHEN ha.attribute_type = 'ventrals' THEN ha.determiner END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "ventrals determiner",
		LISTAGG(CASE WHEN ha.attribute_type = 'ventrals' THEN CASE WHEN ha.values_of_type > 1 THEN NVL(ha.determined_date_text, 'no date') ELSE ha.determined_date_text END END, ' | ')
			WITHIN GROUP (ORDER BY ha.determined_date NULLS LAST, ha.attribute_id) AS "ventrals determined date"
	FROM
		herp_attributes ha
	GROUP BY
		ha.collection_object_id
	HAVING
		COUNT(CASE
			WHEN ha.attribute_type = 'size'
				AND NOT REGEXP_LIKE(TRIM(ha.attribute_value), '^-?[0-9]*\.?[0-9]+$')
				AND NOT REGEXP_LIKE(ha.attribute_value, '[^=;[:space:]][[:space:]]*=[[:space:]]*[^=;[:space:]]') THEN NULL
			WHEN ha.attribute_type IN (
				'body diameter',
				'carapace height',
				'carapace length',
				'carapace width',
				'chest width',
				'crus length',
				'ear (tympanum) width',
				'eye width',
				'eye-nostril distance',
				'eye-tympanum distance',
				'femur length',
				'foot length',
				'forearm (antebrachium) length',
				'forelimb length',
				'hand length',
				'head height',
				'head length',
				'head width',
				'hindlimb length',
				'humerus length',
				'internarial distance',
				'interocular width',
				'plastron length',
				'plastron width',
				'quadratojugal height',
				'quadratojugal length',
				'size',
				'snout-ear length',
				'snout-eye length',
				'snout-vent length',
				'tail height',
				'tail length',
				'tail width',
				'tarsus length',
				'tibia length',
				'total length',
				'total size',
				'trunk length',
				'tympanum width',
				'ulna length',
				'upper eyelid width',
				'weight',
				'dentary teeth',
				'dorsal scale rows (DSR)',
				'infralabials',
				'maxillary teeth',
				'midbody scale rows',
				'palatine teeth',
				'paravertebrals',
				'postoculars',
				'preoculars',
				'pterygoid teeth',
				'subcaudals',
				'supracilliaries',
				'supralabials',
				'temporals',
				'ventrals'
			) THEN 1
		END) > 0
)
SELECT
	ff.guid,
	ff.scientific_name,
	ff.family,
	ff.higher_geog,
	ff.country,
	ff.state_prov,
	ff.county,
	ff.island_group,
	ff.island,
	ff.spec_locality,
	ff.dec_lat,
	ff.dec_long,
	ff.datum,
	ff.coordinateuncertaintyinmeters,
	ff.minimum_elevation,
	ff.maximum_elevation,
	ff.orig_elev_units,
	ff.began_date,
	ff.ended_date,
	ff.verbatim_date,
	pivoted."sex",
	pivoted."sex units",
	pivoted."sex determiner",
	pivoted."sex determined date",
	pivoted."age class",
	pivoted."age class determiner",
	pivoted."age class determined date",
	pivoted."body diameter",
	pivoted."body diameter units",
	pivoted."body diameter determiner",
	pivoted."body diameter determined date",
	pivoted."carapace height",
	pivoted."carapace height units",
	pivoted."carapace height determiner",
	pivoted."carapace height determined date",
	pivoted."carapace length",
	pivoted."carapace length units",
	pivoted."carapace length determiner",
	pivoted."carapace length determined date",
	pivoted."carapace width",
	pivoted."carapace width units",
	pivoted."carapace width determiner",
	pivoted."carapace width determined date",
	pivoted."chest width",
	pivoted."chest width units",
	pivoted."chest width determiner",
	pivoted."chest width determined date",
	pivoted."crus length",
	pivoted."crus length units",
	pivoted."crus length determiner",
	pivoted."crus length determined date",
	pivoted."ear (tympanum) width",
	pivoted."ear (tympanum) width units",
	pivoted."ear (tympanum) width determiner",
	pivoted."ear (tympanum) width determined date",
	pivoted."eye width",
	pivoted."eye width units",
	pivoted."eye width determiner",
	pivoted."eye width determined date",
	pivoted."eye-nostril distance",
	pivoted."eye-nostril distance units",
	pivoted."eye-nostril distance determiner",
	pivoted."eye-nostril distance determined date",
	pivoted."eye-tympanum distance",
	pivoted."eye-tympanum distance units",
	pivoted."eye-tympanum distance determiner",
	pivoted."eye-tympanum distance determined date",
	pivoted."femur length",
	pivoted."femur length units",
	pivoted."femur length determiner",
	pivoted."femur length determined date",
	pivoted."foot length",
	pivoted."foot length units",
	pivoted."foot length determiner",
	pivoted."foot length determined date",
	pivoted."forearm (antebrachium) length",
	pivoted."forearm (antebrachium) length units",
	pivoted."forearm (antebrachium) length determiner",
	pivoted."forearm (antebrachium) length determined date",
	pivoted."forelimb length",
	pivoted."forelimb length units",
	pivoted."forelimb length determiner",
	pivoted."forelimb length determined date",
	pivoted."hand length",
	pivoted."hand length units",
	pivoted."hand length determiner",
	pivoted."hand length determined date",
	pivoted."head height",
	pivoted."head height units",
	pivoted."head height determiner",
	pivoted."head height determined date",
	pivoted."head length",
	pivoted."head length units",
	pivoted."head length determiner",
	pivoted."head length determined date",
	pivoted."head width",
	pivoted."head width units",
	pivoted."head width determiner",
	pivoted."head width determined date",
	pivoted."hindlimb length",
	pivoted."hindlimb length units",
	pivoted."hindlimb length determiner",
	pivoted."hindlimb length determined date",
	pivoted."humerus length",
	pivoted."humerus length units",
	pivoted."humerus length determiner",
	pivoted."humerus length determined date",
	pivoted."internarial distance",
	pivoted."internarial distance units",
	pivoted."internarial distance determiner",
	pivoted."internarial distance determined date",
	pivoted."interocular width",
	pivoted."interocular width units",
	pivoted."interocular width determiner",
	pivoted."interocular width determined date",
	pivoted."plastron length",
	pivoted."plastron length units",
	pivoted."plastron length determiner",
	pivoted."plastron length determined date",
	pivoted."plastron width",
	pivoted."plastron width units",
	pivoted."plastron width determiner",
	pivoted."plastron width determined date",
	pivoted."quadratojugal height",
	pivoted."quadratojugal height units",
	pivoted."quadratojugal height determiner",
	pivoted."quadratojugal height determined date",
	pivoted."quadratojugal length",
	pivoted."quadratojugal length units",
	pivoted."quadratojugal length determiner",
	pivoted."quadratojugal length determined date",
	pivoted."size",
	pivoted."size units",
	pivoted."size determiner",
	pivoted."size determined date",
	pivoted."snout-ear length",
	pivoted."snout-ear length units",
	pivoted."snout-ear length determiner",
	pivoted."snout-ear length determined date",
	pivoted."snout-eye length",
	pivoted."snout-eye length units",
	pivoted."snout-eye length determiner",
	pivoted."snout-eye length determined date",
	pivoted."snout-vent length",
	pivoted."snout-vent length units",
	pivoted."snout-vent length determiner",
	pivoted."snout-vent length determined date",
	pivoted."tail height",
	pivoted."tail height units",
	pivoted."tail height determiner",
	pivoted."tail height determined date",
	pivoted."tail length",
	pivoted."tail length units",
	pivoted."tail length determiner",
	pivoted."tail length determined date",
	pivoted."tail width",
	pivoted."tail width units",
	pivoted."tail width determiner",
	pivoted."tail width determined date",
	pivoted."tarsus length",
	pivoted."tarsus length units",
	pivoted."tarsus length determiner",
	pivoted."tarsus length determined date",
	pivoted."tibia length",
	pivoted."tibia length units",
	pivoted."tibia length determiner",
	pivoted."tibia length determined date",
	pivoted."total length",
	pivoted."total length units",
	pivoted."total length determiner",
	pivoted."total length determined date",
	pivoted."total size",
	pivoted."total size units",
	pivoted."total size determiner",
	pivoted."total size determined date",
	pivoted."trunk length",
	pivoted."trunk length units",
	pivoted."trunk length determiner",
	pivoted."trunk length determined date",
	pivoted."tympanum width",
	pivoted."tympanum width units",
	pivoted."tympanum width determiner",
	pivoted."tympanum width determined date",
	pivoted."ulna length",
	pivoted."ulna length units",
	pivoted."ulna length determiner",
	pivoted."ulna length determined date",
	pivoted."upper eyelid width",
	pivoted."upper eyelid width units",
	pivoted."upper eyelid width determiner",
	pivoted."upper eyelid width determined date",
	pivoted."weight",
	pivoted."weight units",
	pivoted."weight determiner",
	pivoted."weight determined date",
	pivoted."dentary teeth",
	pivoted."dentary teeth determiner",
	pivoted."dentary teeth determined date",
	pivoted."dorsal scale rows (DSR)",
	pivoted."dorsal scale rows (DSR) determiner",
	pivoted."dorsal scale rows (DSR) determined date",
	pivoted."infralabials",
	pivoted."infralabials determiner",
	pivoted."infralabials determined date",
	pivoted."maxillary teeth",
	pivoted."maxillary teeth determiner",
	pivoted."maxillary teeth determined date",
	pivoted."midbody scale rows",
	pivoted."midbody scale rows determiner",
	pivoted."midbody scale rows determined date",
	pivoted."palatine teeth",
	pivoted."palatine teeth determiner",
	pivoted."palatine teeth determined date",
	pivoted."paravertebrals",
	pivoted."paravertebrals determiner",
	pivoted."paravertebrals determined date",
	pivoted."postoculars",
	pivoted."postoculars determiner",
	pivoted."postoculars determined date",
	pivoted."preoculars",
	pivoted."preoculars determiner",
	pivoted."preoculars determined date",
	pivoted."pterygoid teeth",
	pivoted."pterygoid teeth determiner",
	pivoted."pterygoid teeth determined date",
	pivoted."subcaudals",
	pivoted."subcaudals determiner",
	pivoted."subcaudals determined date",
	pivoted."supracilliaries",
	pivoted."supracilliaries determiner",
	pivoted."supracilliaries determined date",
	pivoted."supralabials",
	pivoted."supralabials determiner",
	pivoted."supralabials determined date",
	pivoted."temporals",
	pivoted."temporals determiner",
	pivoted."temporals determined date",
	pivoted."ventrals",
	pivoted."ventrals determiner",
	pivoted."ventrals determined date"
FROM
	filtered_flat ff
	JOIN pivoted ON ff.collection_object_id = pivoted.collection_object_id
WHERE
	ff.collection_cde = 'Herp'
ORDER BY
	ff.guid
