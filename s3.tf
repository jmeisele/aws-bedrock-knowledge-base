resource "aws_s3_bucket" "pokemon" {
  bucket_prefix = "pokemon"
  force_destroy = true
}

resource "aws_s3_object" "poke_corpus_csv" {
  bucket = aws_s3_bucket.pokemon.bucket
  key    = "poke_corpus.csv"
  source = "./poke_corpus.csv"
}

resource "aws_s3_object" "pokedex_csv" {
  bucket = aws_s3_bucket.pokemon.bucket
  key    = "pokedex.csv"
  source = "./pokedex.csv"
}