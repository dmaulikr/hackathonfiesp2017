using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DenunciaFiesp.Dto
{
    public class Conversa
    {
        public Conversa()
        {
            this.Mensagens = new List<Mensagem>();
        }

        /// <summary>
        /// Lista de Mensagens
        /// </summary>
        public List<Mensagem> Mensagens { get; set; }
    }
}