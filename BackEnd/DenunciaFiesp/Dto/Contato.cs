using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DenunciaFiesp.Dto
{
    public class Contato
    {
        public Contato()
        {
            this.mensagens = new List<MensagemChat>();
        }

        public string nome { get; set; }

        public string telefone { get; set; }

        public float nivelPerigo { get; set; }

        public int qtdMsg { get; set; }

        public List<MensagemChat> mensagens { get; set; }
    }
}