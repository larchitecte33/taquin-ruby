# Le jeu du Taqui se compose d'une grille de n lignes et m colonnes.
# Chaque case, sauf une, est occupée par une pièce.
# Sur chaque pièce, il y a un numéro
# Au début du jeu, les pièces sont mélangées
# Le but du jeu est de remettre les pièces dans l'ordre

# Exemple Taquin ordonné
#  1  2  3  4
#  5  6  7  8
#  9 10 11 12
# 13 14 15

# Exemple Taquin désordonné
# 10 3  8 12
# 6  1  2  7
# 11 15 4 14
# 5  9 13

require 'matrix.rb'

class String
  def is_i?
	self =~ /\A[-+]?\d+\z/
  end
end

class Matrix
	def []=(i, j, x)
		@rows[i][j] = x
	end
end

class Taquin
	def initialize(niveau, tailleMatrice)
		case tailleMatrice
		when 1
			@grille = Matrix[[1, 2, 3], [4, 5, 6], [7, 8, 9], [10, 11, -1]]
			@nbColonnes = 3
		when 2
			@grille = Matrix[[1, 2, 3, 4], [5, 6, 7, 8], [9, 10, 11, 12], [13, 14, 15, -1]]
			@nbColonnes = 4
		else
			@grille = Matrix[[1, 2, 3, 4, 5], [6, 7, 8, 9, 10], [11, 12, 13, 14, 15], [16, 17, 18, 19, -1]]
			@nbColonnes = 5
		end
		
		@niveau = niveau
		MelangerGrille(@niveau, @nbColonnes)
		#self.Test
	end
	
	def RechercherPositionCaseVide
		for i in 0..3
			for j in 0..@nbColonnes - 1
				if @grille[i, j] == -1
					return true, i, j
					break
				end
			end
		end
		
		return false
	end
	
	def deplacerCase(caseADeplacer, direction)
		x = caseADeplacer[1]
		y = caseADeplacer[2]
		numeroCaseADeplacer = @grille[x, y]
		
		puts "x = #{x} - y = #{y}"
		
		case direction
		when "G"
			xDest = caseADeplacer[1]
			yDest = caseADeplacer[2] - 1
			puts "xDest, yDest = #{xDest}, #{yDest}"
			numeroCaseDest = @grille[xDest, yDest]
		when "D"
			xDest = caseADeplacer[1]
			yDest = caseADeplacer[2] + 1
			puts "xDest, yDest = #{xDest}, #{yDest}"
			numeroCaseDest = @grille[xDest, yDest]
		when "H"
			xDest = caseADeplacer[1] - 1
			yDest = caseADeplacer[2]
			puts "xDest, yDest = #{xDest}, #{yDest}"
			numeroCaseDest = @grille[xDest, yDest]
		else
			xDest = caseADeplacer[1] + 1
			yDest = caseADeplacer[2]
			puts "xDest, yDest = #{xDest}, #{yDest}"
			numeroCaseDest = @grille[xDest, yDest]
		end	
		
		puts "numeroCaseADeplacer = #{numeroCaseADeplacer} - numeroCaseDest = #{numeroCaseDest}"
		
		@grille[xDest, yDest] = numeroCaseADeplacer
		@grille[x, y] = numeroCaseDest
	end
	
	def Afficher
		for i in 0..3
			if @nbColonnes == 3
				puts "#{@grille[i, 0]} , #{@grille[i, 1]}, #{@grille[i, 2]} "
			elsif @nbColonnes == 4
				puts "#{@grille[i, 0]} , #{@grille[i, 1]}, #{@grille[i, 2]}, #{@grille[i, 3]} "
			elsif @nbColonnes == 5
				puts "#{@grille[i, 0]} , #{@grille[i, 1]}, #{@grille[i, 2]}, #{@grille[i, 3]}, #{@grille[i, 4]} "
			end
		end
		#puts @grille[1, 2]
	end
	
	def Test
		caseVide = self.RechercherPositionCaseVide
		deplacerCase(caseVide, 'G')
	end
	
	def MelangerGrille(niveau, nbColonnes)
		nbMelanges = 5 * niveau
		srand
		
		# Pour chaque mélange
		for i in 0..nbMelanges - 1
			caseVide = false, -1, -1
			
			# On va rechercher la case vide
			caseVide = self.RechercherPositionCaseVide
			
			puts "caseVide[1] = #{caseVide[1]} - caseVide[2] = #{caseVide[2]}"
			
			# Si on a pas trouvé la case vide, on affiche un message
			if not caseVide[0]
				puts "La case vide a disparu"
				break
			else
				directionsPossibles = []
			
				if caseVide[2] > 0
					directionsPossibles.push("G")
					puts "peutAllerAGauche"
				end
				
				if caseVide[2] < nbColonnes - 1
					directionsPossibles.push("D")
					puts "peutAllerADroite"
				end
				
				if caseVide[1] > 0
					directionsPossibles.push("H")
					puts "peutAllerEnHaut"
				end
				
				if caseVide[1] < 3
					directionsPossibles.push("B")
					puts "peutAllerEnBas"
				end
				
				if directionsPossibles.length == 0
					puts "Aucune case ne peut etre deplacee."
					break
				else
					self.Afficher
					puts "Nb posibilitees : #{directionsPossibles.length}"
					deplacement = rand(directionsPossibles.length)
					deplacerCase(caseVide, directionsPossibles[deplacement])
					
					puts deplacement
					puts '********************'
				end
			end
		end
	end
	
	# fonction utilisee pour savoir si une case peut etre deplacee
	# Parametres d'entree : x, y => coordonnees de la case
	# Retourne true, direction si la case est deplacable, false sinon
	def casePeutEtreDeplacee(x, y)
		caseVide = self.RechercherPositionCaseVide
		
		puts "x = #{x} - y = #{y}"
		puts "caseVide[1] = #{caseVide[1]} - caseVide[2] = #{caseVide[2]}"
		
		if x.to_i == caseVide[1] then
			puts "test3"
			if y.to_i == caseVide[2] + 1 then
				puts "test1"
				return true, "G"
			elsif y.to_i == caseVide[2] - 1 then
				puts "test2"
				return true, "D"
			end
		elsif y.to_i == caseVide[2] then
			if x.to_i == caseVide[1] + 1 then
				return true, "H"
			elsif x.to_i == caseVide[1] - 1 then
				return true, "B"
			end
		end
	end
end

# Demande de la taille de la matrice
tailleMatrice = 0

while (tailleMatrice < 1) or (tailleMatrice > 3) do
	puts "Entrez la taille de la matrice (entre 1 et 3)" 
	valeurEntree = gets.chomp

	if valeurEntree.is_i?
		tailleMatrice = valeurEntree.to_i
	else
		puts "La valeur entree est incorrecte"
	end
end

# Demande du niveau
niveau = 0

while (niveau < 1) or (niveau > 5) do
	puts "Entrez le niveau de difficulte (entre 1 et 5)"
	valeurEntree = gets.chomp
	
	if valeurEntree.is_i?
		niveau = valeurEntree.to_i
	else
		puts "La valeur entree est incorrecte"
	end
end

t = Taquin.new(niveau, tailleMatrice)
t.Afficher
quit = false

while not quit do
	puts "Entrez les coordonnees de la case a deplacer ou q pour quitter."
	puts "x = "
	x = gets
	
	if x == 'q'
		quit = true
	else
		puts "y = "
		y = gets
		
		if y == "q"
			quit = true
		else 
			caseDeplacable, direction = t.casePeutEtreDeplacee(x, y)
			puts "caseDeplacable = #{caseDeplacable} - direction = #{direction}"
			if not caseDeplacable
				puts "La case ne peut etre deplacee"
			else
				caseADeplacer = false, x.to_i, y.to_i
				t.deplacerCase(caseADeplacer, direction)
				t.Afficher
			end
		end
	end
end