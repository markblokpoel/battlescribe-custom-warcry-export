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

	<xsl:strip-space elements="bs:selection" />

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
					{alignHoriz:
					true, alignVert: true, multiLine: true})
					textFit(document.getElementsByClassName('abilities'), {alignVert:
					true, maxFontSize: 25})
					textFit(document.getElementsByClassName('weapon-name'),
					{alignHoriz:
					true, alignVert: true, maxFontSize: 28})
					}
				</script>
			</head>
			<body onload="doFit();">
				<xsl:for-each
					select="bs:selections/bs:selection[@type='model' or @type='unit']">
					<xsl:variable name="unit" select="." />
					<div class="card">
						<div class="base">
							<div class="unit-name">
								<xsl:value-of select="@name" />
							</div>
							<div class="cost">
								<xsl:value-of
									select="substring-before(bs:costs/bs:cost/@value, '.')" />
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
													select="translate(@name, $uppercase, $lowercase)" />
												<xsl:if test="contains($runemark, $faction) = false">
													<xsl:call-template name="runemarkImg">
														<xsl:with-param name="runemark"
															select="$runemark" />
													</xsl:call-template>
												</xsl:if>
											</xsl:for-each>
										</xsl:when>
										<xsl:otherwise>
											<xsl:variable name="runemark"
												select="translate(@name, $uppercase, $lowercase)" />
											<xsl:if test="contains($runemark, $faction) = false">
												<xsl:call-template name="runemarkImg">
													<xsl:with-param name="runemark"
														select="$runemark" />
												</xsl:call-template>
											</xsl:if>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</div>
						</div>
						<div class="stats">
							<xsl:for-each
								select="bs:profiles/bs:profile[@typeName='Model']/bs:characteristics/bs:characteristic">
								<xsl:variable name="runemark"
									select="translate(@name, $uppercase, $lowercase)" />
								<div class="stat {$runemark}">
									<xsl:value-of select="." />
								</div>
							</xsl:for-each>
						</div>
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
									<xsl:variable name="ability-runemarks"
										select="substring-before(substring-after(@name, '('), ')')" />

									<xsl:call-template name="tokenize">
										<xsl:with-param name="string"
											select="$ability-runemarks" />
										<xsl:with-param name="ability-name"
											select="$ability-name" />
										<xsl:with-param name="ability-description"
											select="$ability-description" />
										<xsl:with-param name="unit" select="$unit" />
									</xsl:call-template>
								</xsl:for-each>
							</div>
						</div>
					</div>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="tokenize">
		<xsl:param name="string" />
		<xsl:param name="ability-name" />
		<xsl:param name="ability-description" />
		<xsl:param name="unit" />
		<xsl:choose>
			<xsl:when test="contains($string,',')">
				<xsl:variable name="ability-runemark"
					select="substring-before($string,',')" />

				<xsl:for-each
					select="$unit/bs:selections/bs:selection[@type='upgrade']">
					<xsl:choose>
						<xsl:when test="count(bs:profiles) > 0">
							<xsl:for-each
								select="bs:selections/bs:selection[@type='upgrade']">
								<xsl:choose>
									<xsl:when test="contains(@name, $ability-runemark)">
										<xsl:call-template name="abilityPrint">
											<xsl:with-param name="runemark" select="@name" />
											<xsl:with-param name="name"
												select="$ability-name" />
											<xsl:with-param name="description"
												select="$ability-description" />
										</xsl:call-template>
									</xsl:when>
									<xsl:otherwise>
										<xsl:call-template name="tokenize">
											<xsl:with-param name="string"
												select="substring-after($string,',')" />
											<xsl:with-param name="ability-name"
												select="$ability-name" />
											<xsl:with-param name="ability-description"
												select="$ability-description" />
											<xsl:with-param name="unit" select="$unit" />
										</xsl:call-template>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="contains(@name, $ability-runemark)">
									<xsl:call-template name="abilityPrint">
										<xsl:with-param name="runemark" select="@name" />
										<xsl:with-param name="name"
											select="$ability-name" />
										<xsl:with-param name="description"
											select="$ability-description" />
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="tokenize">
										<xsl:with-param name="string"
											select="substring-after($string,',')" />
										<xsl:with-param name="ability-name"
											select="$ability-name" />
										<xsl:with-param name="ability-description"
											select="$ability-description" />
										<xsl:with-param name="unit" select="$unit" />
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="ability-runemark" select="$string" />
				<xsl:for-each
					select="$unit/bs:selections/bs:selection[@type='upgrade']">
					<xsl:choose>
						<xsl:when test="count(bs:profiles) > 0">
							<xsl:for-each
								select="bs:selections/bs:selection[@type='upgrade']">
								<xsl:if test="contains(@name, $ability-runemark)">
									<xsl:call-template name="abilityPrint">
										<xsl:with-param name="runemark" select="@name" />
										<xsl:with-param name="name"
											select="$ability-name" />
										<xsl:with-param name="description"
											select="$ability-description" />
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="contains(@name, $ability-runemark)">
								<xsl:call-template name="abilityPrint">
									<xsl:with-param name="runemark" select="@name" />
									<xsl:with-param name="name"
										select="$ability-name" />
									<xsl:with-param name="description"
										select="$ability-description" />
								</xsl:call-template>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="runemarkImg">
		<xsl:param name="runemark" />
		<xsl:param name="color" select="'white'" />

		<xsl:choose>
			<xsl:when
				test="string-length(translate(substring($runemark, 1,1), $letters, '')) > 0">
				<xsl:variable name="runemark-file"
					select="translate(substring($runemark, 2, string-length($runemark)-1), ' ', '-')" />
				<img src="assets/runemarks/{$color}/{$runemark-file}.svg" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="runemark-file"
					select="translate($runemark, ' ', '-')" />
				<img src="assets/runemarks/{$color}/{$runemark-file}.svg" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="abilityPrint">
		<xsl:param name="runemark" />
		<xsl:param name="name" />
		<xsl:param name="description" />

		<div class="ability">
			<div class="ability-runemark">
				<xsl:call-template name="runemarkImg">
					<xsl:with-param name="runemark"
						select="translate($runemark, $uppercase, $lowercase)" />
					<xsl:with-param name="color" select="'black'" />
				</xsl:call-template>
			</div>
			<div class="ability-text">
				<span class="ability-title">
					<xsl:value-of select="$name" />
				</span>
				<br />
				<xsl:value-of select="$description" />
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>