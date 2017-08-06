using System;

namespace DenunciaFiesp.Dto
{
    public class Mensagem
    {
        public string Texto { get; set; }

        public string NomeContato { get; set; }

        public string NumeroTelefone { get; set; }

        public string DataEnvio { get; set; }

        public bool Minha { get; set; }
    }
}