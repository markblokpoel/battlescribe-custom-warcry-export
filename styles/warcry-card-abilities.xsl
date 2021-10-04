<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:bs="http://www.battlescribe.net/schema/rosterSchema"
	xmlns:exslt="http://exslt.org/common"
	extension-element-prefixes="exslt">

	<xsl:output method="html" indent="yes" />

	<xsl:variable name="lowercase"
		select="'abcdefghijklmnopqrstuvwxyz'" />
	<xsl:variable name="uppercase"
		select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:variable name="letters"
		select="'abdcefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'" />
	<xsl:variable name="characters"
		select="'abdcefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789-'" />


	<xsl:template match="bs:roster/bs:forces/bs:force">
		<xsl:variable name="faction"
			select="translate(substring-after(@catalogueName, ' - '), $uppercase, $lowercase)" />
		<html>
			<head>
				<link rel="stylesheet" type="text/css" href="css/style.css" />
				<script id="textFitLib" src="js/textFit.min.js" />
				<script>
					function doFit(){
					textFit(document.getElementsByClassName('unit-name'),
					{alignHoriz: true, alignVert: true, maxFontSize: 28})
					textFit(document.getElementsByClassName('abilities'),
					{minFontSize: 10, maxFontSize: 16})
					textFit(document.getElementsByClassName('weapon-name'),
					{alignHoriz: true, alignVert: true, maxFontSize: 28})
					textFit(document.getElementsByClassName('weapon-stat-value'),
					{alignHoriz: true, alignVert: true, maxFontSize: 14})
					textFit(document.getElementsByClassName('faction-title'),
					{alignHoriz: true, alignVert: true, maxFontSize: 28})
					textFit(document.getElementsByClassName('generic-abilities'),
					{maxFontSize: 16})
					}
				</script>
			</head>
			<body onload="doFit();">
				<xsl:for-each
					select="bs:selections/bs:selection[@type='model' or @type='unit']">
					<xsl:variable name="unit" select="." />
					<div class="card">
						<div class="unit-name">
							<xsl:value-of select="@name" />
						</div>
						<div class="cost">
							<xsl:variable name="baseCost"
								select="substring-before(bs:costs/bs:cost/@value, '.')" />
							<xsl:variable name="upgradeCosts"
								select="sum(bs:selections/bs:selection[@type='upgrade' or @type='model']/bs:costs/bs:cost/@value)" />
							<xsl:value-of select="$baseCost + $upgradeCosts" />
						</div>
						<div class="faction">
							<xsl:variable name="faction-file"
								select="translate($faction, ' ', '-')" />
							<img src="assets/runemarks/white/{$faction-file}.svg" />
						</div>
						<div class="runemarks">
							<xsl:for-each
								select="bs:selections/bs:selection[@type='upgrade']">
								<xsl:choose>
									<xsl:when test="count(bs:profiles) > 0">
										<xsl:for-each
											select="bs:selections/bs:selection[@type='upgrade']">
											<xsl:variable name="runemark"
												select="translate(translate(@name, translate(@name, $characters, ''), ''), $uppercase, $lowercase)" />

											<xsl:if test="contains($runemark, $faction) = false">
												<xsl:variable name="runemark-file"
													select="translate($runemark, ' ', '-')" />
												<img src="assets/runemarks/white/{$runemark-file}.svg" />
											</xsl:if>
										</xsl:for-each>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="runemark"
											select="translate(translate(@name, translate(@name, $characters, ''), ''), $uppercase, $lowercase)" />
										<xsl:if test="contains($runemark, $faction) = false">
											<xsl:variable name="runemark-file"
												select="translate($runemark, ' ', '-')" />
											<img src="assets/runemarks/white/{$runemark-file}.svg" />
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</div>
						<xsl:for-each
							select="bs:profiles/bs:profile[@typeName='Model']/bs:characteristics/bs:characteristic">
							<xsl:variable name="runemark"
								select="translate(@name, $uppercase, $lowercase)" />
							<div class="stat {$runemark}">
								<xsl:value-of select="." />
							</div>
						</xsl:for-each>

						<div class="weapons">

							<xsl:for-each
								select=".//bs:profiles/bs:profile[@typeName='Weapon']">
								<div class="weapon">
									<div class="weapon-name">
										<xsl:value-of select="@name" />
									</div>
									<div class="weapon-stats">
										<xsl:for-each
											select="bs:characteristics/bs:characteristic">
											<xsl:variable name="runemark"
												select="translate(@name, $uppercase, $lowercase)" />
											<div class="weapon-stat">
												<img src="assets/runemarks/black/{$runemark}.svg" />
												<div class="weapon-stat-value">
													<xsl:value-of select="." />
												</div>
											</div>
										</xsl:for-each>
									</div>
								</div>
							</xsl:for-each>
						</div>
						<div class="abilities-bg">
							<div class="abilities">
								<xsl:for-each
									select="//bs:rule[substring-before(substring-after(@name, '('), ')') != '']">
									<xsl:sort select="@name" />
									<xsl:variable name="ability-name"
										select="substring-before(@name, ' (')" />
									<xsl:variable name="ability-description"
										select="." />
									<xsl:variable name="ability-runemarks-string"
										select="substring-before(substring-after(@name, '('), ')')" />
									<xsl:variable name="ability-runemarks"
										select="translate($ability-runemarks-string, translate($ability-runemarks-string, concat($characters, ','), ''), '')" />
									<xsl:variable name="showDesc"
										select="contains($ability-runemarks, ',')" />
									<xsl:call-template name="processAbility">
										<xsl:with-param name="string"
											select="$ability-runemarks" />
										<xsl:with-param name="ability-name"
											select="$ability-name" />
										<xsl:with-param name="ability-runemarks"
											select="$ability-runemarks" />
										<xsl:with-param name="ability-description"
											select="$ability-description" />
										<xsl:with-param name="showDesc"
											select="$showDesc" />
										<xsl:with-param name="unit" select="$unit" />
									</xsl:call-template>

								</xsl:for-each>
							</div>
						</div>
					</div>
				</xsl:for-each>


				<div class="generic-abilities-card">
					<div class="faction-title">
						<xsl:value-of select="/bs:roster/bs:forces/bs:force/@catalogueName" />
					</div>
					<div class="generic-abilities">
						<xsl:for-each
							select="//bs:rule[substring-before(substring-after(@name, '('), ')') != '']">
							<xsl:sort select="@name" />
							<xsl:variable name="ability-name"
								select="substring-before(@name, ' (')" />
							<xsl:variable name="ability-description" select="." />
							<xsl:variable name="ability-runemarks-string"
								select="substring-before(substring-after(@name, '('), ')')" />
							<xsl:variable name="ability-runemarks"
								select="translate($ability-runemarks-string, translate($ability-runemarks-string, concat($characters, ','), ''), '')" />

							<xsl:if test="not(contains($ability-runemarks, ','))">
								<xsl:call-template name="abilityPrint">
									<xsl:with-param name="runemarks"
										select="$ability-runemarks" />
									<xsl:with-param name="name"
										select="$ability-name" />
									<xsl:with-param name="description"
										select="$ability-description" />
									<xsl:with-param name="showDesc" select="true()" />
								</xsl:call-template>
							</xsl:if>

						</xsl:for-each>
					</div>
				</div>


			</body>
		</html>
	</xsl:template>

	<xsl:template name="processAbility">
		<xsl:param name="string" />
		<xsl:param name="ability-name" />
		<xsl:param name="ability-runemarks" />
		<xsl:param name="ability-description" />
		<xsl:param name="showDesc" />
		<xsl:param name="unit" />
		<xsl:param name="hasAllRunemarks" select="'true'" />
		<xsl:choose>
			<xsl:when test="contains($string,',')">
				<xsl:variable name="ability-runemark"
					select="normalize-space(substring-before($string,','))" />

				<xsl:variable name="hasRunemark"
					select="count($unit//@name[contains(., $ability-runemark)]) > 0" />

				<xsl:call-template name="processAbility">
					<xsl:with-param name="string"
						select="substring-after($string,',')" />
					<xsl:with-param name="ability-name"
						select="$ability-name" />
					<xsl:with-param name="ability-runemarks"
						select="$ability-runemarks" />
					<xsl:with-param name="ability-description"
						select="$ability-description" />
					<xsl:with-param name="showDesc" select="$showDesc" />
					<xsl:with-param name="unit" select="$unit" />
					<xsl:with-param name="hasAllRunemarks"
						select="$hasAllRunemarks and $hasRunemark" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="ability-runemark"
					select="normalize-space($string)" />

				<xsl:variable name="hasRunemark"
					select="$unit//@name[contains(., $ability-runemark)] != ''" />

				<xsl:if test="$hasAllRunemarks and $hasRunemark">
					<xsl:call-template name="abilityPrint">
						<xsl:with-param name="runemarks"
							select="$ability-runemarks" />
						<xsl:with-param name="name" select="$ability-name" />
						<xsl:with-param name="description"
							select="$ability-description" />
						<xsl:with-param name="showDesc" select="$showDesc" />
					</xsl:call-template>
				</xsl:if>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="runemarkImages">
		<xsl:param name="runemarks" />

		<xsl:choose>
			<xsl:when test="contains($runemarks,',')">
				<xsl:variable name="runemark"
					select="normalize-space(substring-before($runemarks,','))" />
				<xsl:variable name="runemark-file"
					select="translate(translate($runemark, ' ', '-'), $uppercase, $lowercase)" />

				<!-- <div class="ability-runemark"> -->
					<img src="assets/runemarks/black/{$runemark-file}.svg" />
				<!-- </div> -->

				<xsl:call-template name="runemarkImages">
					<xsl:with-param name="runemarks"
						select="substring-after($runemarks,',')" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="runemark"
					select="normalize-space($runemarks)" />
				<xsl:variable name="runemark-file"
					select="translate(translate($runemark, ' ', '-'), $uppercase, $lowercase)" />
				<!-- <div class="ability-runemark"> -->
					<img src="assets/runemarks/black/{$runemark-file}.svg" />
				<!-- </div> -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="abilityPrint">
		<xsl:param name="runemarks" />
		<xsl:param name="name" />
		<xsl:param name="description" />
		<xsl:param name="showDesc" />
		<div class="ability">
			<p>
				<xsl:call-template name="runemarkImages">
					<xsl:with-param name="runemarks" select="$runemarks" />
				</xsl:call-template>
				<span class="ability-title">
					<xsl:value-of
						select="substring($name, 2, string-length($name)-1)" />
				</span>
				<xsl:if test="$showDesc">
					<xsl:value-of select="$description" />
				</xsl:if>
			</p>
		</div>
	</xsl:template>

</xsl:stylesheet>