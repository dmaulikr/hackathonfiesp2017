using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DenunciaFiesp.Dto
{
    public class NLCResposta
    {
        public NLCResposta()
        {
            this.classes = new List<Classes>();
        }

        public string classifier_id { get; set; }

        public string text { get; set; }

        public List<Classes> classes { get; set; }
    }
}