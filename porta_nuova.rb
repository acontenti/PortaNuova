class PortaNuova
	LINES = {
		1 => [
			'Cascine Vica',
			'Leumann',
			'Collegno Centro',
			'Certosa',
			'Fermi',
			'Paradiso',
			'Marche',
			'Massaua',
			'Pozzo Strada',
			'Monte Grappa',
			'Rivoli',
			'Racconigi',
			'Bernini',
			'Principi d\'Acaja',
			'XVIII Dicembre',
			'Porta Susa',
			'Vinzaglio',
			'Re Umberto',
			'Porta Nuova',
			'Marconi',
			'Nizza',
			'Dante',
			'Carducci-Molinette',
			'Spezia',
			'Lingotto',
			'Italia \'61-Regione Piemonte',
			'Bengasi'
		],
		2 => [
			'Cimitero Parco',
			'Fiat Mirafiori',
			'Cattaneo',
			'Omero',
			'Pitagora',
			'Parco Rignon',
			'Santa Rita',
			'Gessi',
			'Largo Orbassano',
			'Caboto',
			'Politecnico',
			'Stati Uniti',
			'Porta Nuova',
			'C.L.N.',
			'Castello',
			'Regina Margherita',
			'Verona',
			'Novara',
			'Regaldi',
			'Cimarosa',
			'Bologna',
			'Corelli',
			'Mercadante',
			'Giulio Cesare',
			'Vercelli',
			'Rebaudengo',
		]
	}

	def initialize(source)
		setup
		source.gsub /\t+/, ''
		lines = source.split(/[\r\n]+/)
		lines.each { |line| parse line.strip }
	end

	def setup
		@last_station = 'Porta Nuova'
		@last_line = 1
		@line_pattern = /(?:prendi la linea|take line) ([12]) (?:fino a|to) ([A-Za-z.' ]+)/i
	end

	def parse(statement)
		if statement =~ @line_pattern
			line, station = $1.to_i, $2
			if LINES[line].include? station
				if line != @last_line
					puts "Changing from line #{@last_line} to line #{line}"
					if LINES[line].include? @last_station
						execute line, station
					else
						throw "In #{@last_station} station you cannot change to line #{line}"
					end
				else
					execute line, station
				end
			else
				throw "There is no #{station} station in line #{line}"
			end
		else
			throw 'Error parsing line'
		end
	end

	def execute(line, station)
		puts "Taking line #{line} to #{station}"
		@last_line = line
		@last_station = station
	end
end

source = File.read(ARGV[0])
PortaNuova.new source