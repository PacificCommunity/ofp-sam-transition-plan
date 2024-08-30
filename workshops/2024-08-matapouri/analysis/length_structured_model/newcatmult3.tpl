DATA_SECTION
  number multiplier
  number rbpen
  !! multiplier=1.0;
  int non_decreasing_flag
 LOC_CALCS
  int ii=0;
  int lower_flag=4;
  non_decreasing_flag=0;
  get_option("-ndf",non_decreasing_flag,1);
  rbpen=100;
  get_option("-rbp",rbpen,1);

 END_CALCS
  int full_likelihood
 !! full_likelihood=1;
  init_int nyears  
  init_int nages
  init_int nlint
  init_int check3
 LOC_CALCS
  if (check3 != 1258) 
  {
    cerr << "check3 error" << endl;
    ad_exit(1);
  }
 END_CALCS

  init_number shlen
  init_number filen
  init_int sd
  init_int check2
 LOC_CALCS
  if (check2 != 7159) 
  {
    cerr << "check2 error" << endl;
    ad_exit(1);
  }
 END_CALCS
  matrix RR(1,nyears,1,nlint)
  // init_int len_sel_flag    don't need this at the moment
  vector xspl(1,sd)
 !! xspl.fill_seqadd(0,1.0/(sd-1));
  vector fmid(1,nlint)
 !! fmid.fill_seqadd(shlen+0.5*filen,filen);
  // init_matrix obs_catch_composition(1,nyears,1,nages)
  init_matrix obs_length_composition(1,nyears,1,nlint)
  init_int check0
 LOC_CALCS
  if (check0 != 6199) 
  {
    cerr << "check0 error" << endl;
    ad_exit(1);
  }
 END_CALCS
  init_vector obs_sample_size(1,nyears)
  vector scaled_log_obs_sample_size(1,nyears)
  vector recnumbers(1,nyears)
  init_vector otc(1,nyears)
  init_int check5
 LOC_CALCS
  if (check5 != 6609) 
  {
    cerr << "check5 error" << endl;
    ad_exit(1);
  }
 END_CALCS
  init_vector effort(1,nyears)
  init_int check1
 LOC_CALCS
  if (check1 != 2149) 
  {
    cerr << "check1 error" << endl;
    ad_exit(1);
  }
 END_CALCS
  init_number M
  init_vector biomass_index(1,nyears);
  number eps_bi
 !! eps_bi=0.01;
  vector log_biomass_index(1,nyears);
  vector logotc(1,nyears)
 LOC_CALCS
  logotc=log(otc);
  log_biomass_index=log(biomass_index+eps_bi);
  omn=mean(log_biomass_index);
  dvector ll=log(obs_sample_size);
  scaled_log_obs_sample_size=ll-mean(ll);
 END_CALCS
  init_vector mean_wt(1,nages);

 !!ad_comm::change_datafile_name("richards.stuff");
  init_int rgmmax
  init_int kmax
  init_int kinit
  init_int n
  number ftmp

  vector sample_sizes

  number omn
  //number gamma
  vector weights(1,rgmmax)
 LOC_CALCS
  //gamma=1.0;
  int mmin=-(rgmmax-1)/2;
  int mmax=-mmin;
  for (int i=mmin;i<=mmax;i++)
  { 
    weights(i-mmin+1)=exp(-0.5*i*i);
  }
  weights/=sum(weights);



PARAMETER_SECTION
 LOC_CALCS
  double rec_min=20;
  double rec_max=40;
  get_option("-recmin",rec_min,1);
  get_option("-recmax",rec_max,1);
  double sd_min=2.0;
  double sd_max=10.0;
  get_option("-sdmin",sd_min,1);
  get_option("-sdmax",sd_max,1);
 END_CALCS
  init_bounded_number rec_mu(rec_min,rec_max,2)
  init_bounded_number rec_sd(sd_min,sd_max,2)
  init_bounded_number rho(0.01,0.99,2)
  init_bounded_number gamma(0.35,2.0,5)
  init_bounded_number log_q(-5.1,4.0,2)
  init_number log_popscale(1)
  number mean_sel
  number totpop
  init_bounded_vector tsel_coff(2,sd,-15.,15.,3)
  vector tsel(1,sd)
  //init_bounded_dev_vector log_relpop(1,nyears+nlint-1,-15.,15.,-2)
  init_bounded_vector recdevcoffs(1,nyears,-15.,15.,3)
  vector recdevs(1,nyears)
  init_bounded_vector effort_devs(1,nyears,-5.,5.,3)
  vector log_sel(1,nlint)
  vector log_initpop(1,nyears+nlint-1);
  matrix F(1,nyears,1,nlint)
  matrix Z(1,nyears,1,nlint)
  matrix S(1,nyears,1,nlint)
  matrix N(1,nyears,1,nlint)
  matrix mprobs(1,nyears,1,nlint)
  matrix C(1,nyears,1,nlint)
  vector TC(1,nyears)
  vector logTC(1,nyears)
  matrix pred_catch_composition(1,nyears,1,nlint)
  objective_function_value f
  number initsum
  number avg_F
  vector pred_biomass_index(1,nyears)
  number vN
  //sdreport_number vN
  number pen_F
  number pen_relpop
  number like_rel_abund
  number like_totC
  number like_lencomp
  vector tlength(1,nlint-1)
  init_bounded_number l1(0.1,25.)
  vector ln(1,rgmmax)
  init_bounded_number log_mu(3.75,5.0,2)
  init_bounded_number ln_sd(0.01,0.3,2)
  init_number kludge(-1)
  init_bounded_number log_vn(0,12,4)
  number K
 LOC_CALCS
  int mmin=-(rgmmax-1)/2;
  int mmax=-mmin;
  for (int i=mmin;i<=mmax;i++)
  { 
    ln(i-mmin+1)=exp(log_mu+i*ln_sd);
    weights(i-mmin+1)=exp(-0.5*i*i);
  }
  weights/=sum(weights);

   K=-log(rho);
 END_CALCS

  !!CLASS dfrichards_growth_manager_array rgma(l1,ln,n,gamma,nlint,K,weights)

  number recsum
  init_bounded_number log_mean_rec(-3.0,3.0,5)
 !! log_mean_rec.set_scalefactor(0.1);

PROCEDURE_SECTION
  K=-log(rho);
  int mmin=-(rgmmax-1)/2;
  int mmax=-mmin;
  for (int i=mmin;i<=mmax;i++)
  { 
    ln(i-mmin+1)=l1+1.0+exp(log_mu +i*ln_sd);
    weights(i-mmin+1)=exp(-0.5*i*i);
  }
  weights/=sum(weights);
  logTC.initialize();
  pred_catch_composition.initialize();
  dvariable mnr=mean(recdevcoffs);
  recdevs=recdevcoffs-mnr;
  f+=100.0*square(mnr);
  totpop=exp(log_popscale);
  mprobs.initialize();
  N.initialize();
  pad_rgma->set_value(l1,ln,gamma,K);
  get_mortality_and_survivial_rates_by_length();
  dvar_vector ES=S(1);
  //dvar_vector ES=get_equilbrium_survival(nlint);
  dvar_vector IP= get_initial_equil_population(nlint,shlen,fmid,rec_mu,rec_sd,
    filen,ES,*pad_rgma,totpop,recdevs,recnumbers,log_mean_rec,RR);
  N(1)=IP;
  mprobs(1)=N(1)/sum(N(1));

  for (int i=1;i<=nyears;i++)
  {
    catch_the_fish(i,N,C,F,Z,S,pred_catch_composition,logTC);
    if (i<nyears)
    {
      dvar_vector tmpfish=kill_the_fish(i,N,S,filen);
      if (sum(tmpfish)<1.e-10)
      {
        cout << "HERE" << endl;
      }
      N(i+1)=grow_the_fish(i,nlint,tmpfish,fmid,shlen,filen,*pad_rgma);
      dvar_vector R=get_recruitment(i+1,fmid,rec_mu,rec_sd,totpop,recdevs,
        log_mean_rec);
      RR(i+1)=value(R);
      recnumbers(i+1)=sum(value(R));
      N(i+1)+=R;
    }
  }

  evaluate_the_objective_function();

RUNTIME_SECTION
  convergence_criteria .1, .001, .001
  maximum_function_evaluations 5000, 10000, 10000


FUNCTION get_mortality_and_survivial_rates_by_length
  int i, j;
  // calculate the selectivity from the sel_coffs
  tsel(1)=-2.0;
  for (int i=2;i<=sd;i++)
  {
    tsel(i)=tsel(i-1)+0.1*exp(tsel_coff(i));
  }
  vcubic_spline_function csf(xspl,tsel);
  dvariable div=1.0/(1.0-pow(rho,nlint-2));
  tlength(1)=0.0;
  for (j=2;j<=nlint-1;j++)
  {
    tlength(j)=(1.0-pow(rho,j-1))*div;
  }

  log_sel(1,nlint-1)=csf(tlength);
  log_sel(nlint)=log_sel(nlint-1);

  const double penwt=1.e+06;
  for (j=2;j<=nlint;j++)
  {
    if (log_sel(j)<log_sel(j-1))
    {
      dvariable diff=log_sel(j-1)-log_sel(j);
      f+=penwt*cube(diff);
    }
  }

  mean_sel=mean(log_sel);
  log_sel-=mean_sel;


  // This is the same as F(i,j)=exp(q)*effort(i)*exp(log_sel(j));
  F=outer_prod(mfexp(log_q)*effort,mfexp(log_sel));
  if (active(effort_devs))
  {
    for (i=1;i<=nyears;i++)
    {
      F(i)=F(i)*exp(effort_devs(i));
    }
  }
  // get the total mortality
  Z=F+M;
  // get the survival rate
  S=mfexp(-1.0*Z);


FUNCTION get_catch_at_age
  C=elem_prod(elem_div(F,Z),elem_prod(1.-S,N));
  for (int i=1;i<=nyears;i++)
  {
    TC(i)=sum(C(i));
    logTC(i)=log(TC(i));
    pred_catch_composition(i)=
      C(i)/TC(i);
  }

FUNCTION evaluate_the_objective_function
  // penalty functions to ``regularize '' the solution
  dvariable f1=0.0;
  f1+=5.0*norm2(recdevs);
  f1+=5.0*norm2(effort_devs);

  f1+=100.0*square(mean_sel);

  f1+=0.01*norm2(tsel);

  avg_F=sum(F)/double(size_count(F));
  pen_F = 0.0;
  if (last_phase())
  {
    // a very small penalty on the average fishing mortality
    pen_F = .001*square(log(avg_F/.2));
    f1+= pen_F;
  }
  else
  {
    f1+= 1000.*square(log(avg_F/.2));
  }

  dvar_vector wlen=pow(fmid,3);  
  for (int i=1;i<=nyears;i++)
  {
    pred_biomass_index(i)=N(i)*wlen;
  }

  dvar_vector log_pred_biomass_index=log(pred_biomass_index+eps_bi);
  dvariable pmn=mean(log_pred_biomass_index);
  like_rel_abund = 0.0;

  like_rel_abund=rbpen*norm2(log_biomass_index-log_pred_biomass_index-(omn-pmn));
  f+=like_rel_abund;


  //double mvv=mean(log(obs_sample_size));
  //const double l1000=log(1000.);
  like_totC=0.0;
  like_totC=50.*norm2(logTC-logotc);
  f+=like_totC;

  
  /*
  for (int i=1;i<=nyears;i++)
  {
    f+=norm2(log(.001+pred_catch_composition(i))
         -log(0.001+obs_length_composition(i)));
  }
  */
  
  like_lencomp=0.0;
  for (int i=1;i<=nyears;i++)
  {
    vN=exp(log_vn);
    dvar_vector obsl=obs_length_composition(i);
    dvariable Phi=0.0;
    dvariable tmp=0.0;
    int np=0;
    for (int ii=1;ii<=nlint;ii++)
    {
      if (obsl(ii)>0.0)
      {
        tmp+=obsl(ii)*log(obsl(ii));
        np++;
      }
    }

    Phi=multiplier*0.5*(np-1.0)*log(vN)-vN*tmp;
    like_lencomp-=Phi;
    like_lencomp-=vN*(obsl*log(1.e-5+pred_catch_composition(i)));
  }
  f+=like_lencomp;
  f+=square(kludge);


  if (full_likelihood)
    f+=f1;

REPORT_SECTION

  if (last_phase())
  {
    ofstream ofs("analyzer.truth");
    ofs << "Equilibrium test" << endl;
    ofs << N(1) << endl;
    ofs << N(2)-RR(2)+RR(1) << endl;
    ofs << "Pred total catch" << endl;
    ofs << exp(logTC) << endl;
    ofs << "Pred catch composition" << endl;
    ofs << pred_catch_composition << endl;
    ofs << "True numbers at length" << endl;
    ofs << N << endl;
    ofs << "F" << endl;
    ofs << F << endl;
    ofs << "Z" << endl;
    ofs << Z << endl;
    ofs << "Length Composition" << endl;
    for (int i=1;i<=nyears;i++)
    {
      ofs << N(i)/sum(N(i)) << endl;
    }
    ofs << "  Growth curves" << endl;
    ofs << " l1"  << "    "  << l1 << endl;
    ofs <<  " ln\'s" << "    " << ln  << endl;
    ofs <<  "  K " <<"    " << -log(rho) << endl;
    double crho=value(rho);
    double cgamma=value(gamma);
    double gaminv=1.0/cgamma;
    double l1gam=pow(value(l1),gaminv);
    dvector lngam=pow(value(ln),gaminv);
    dvector linf=pow(l1gam+(lngam-l1gam)/(1.0-pow(crho,n-1.0)),cgamma);
    ofs <<  "  Linfinity " <<"    " << linf << endl;
    ofs <<  "  gamma " << "    " <<  cgamma << endl;
    ofs << "  weights" << "    " << weights << endl;

    dvar_matrix NN(1,nyears,1,nlint);
    NN.initialize();
    dvar_vector R=get_recruitment(1,fmid,rec_mu,rec_sd,totpop,recdevs,
      log_mean_rec);
    NN(1)=R;

    for (int i=1;i<=nyears;i++)
    {
      if (i<nyears)
      {
        NN(i+1)=grow_the_fish(i,nlint,NN(i),fmid,shlen,filen,*pad_rgma);
      }
    }
    dvar_vector means(1,nyears);
    for (int i=1;i<=nyears;i++)
    {
      NN(i)/=sum(NN(i));
      means(i)=fmid*NN(i);
    }
    ofstream ofss("lencomp");
    ofss << NN << endl;
    ofstream ofss1("lenmeans");
    ofss1 << means << endl;
    ofstream ofss1p("lenmeans_app",ios::app);
    ofss1p << means << endl;
  }

  report << "obs catch pred catch ratio " << endl;
  for (int i=1;i<=nyears;i++)
  {
    report << elem_div(0.001+obs_length_composition(i),0.001+pred_catch_composition(i))
           << endl;
  }
  report << "mean_sel" << endl;
  report << mean_sel << endl;
  report << "log selectivities" << endl;
  report << log_sel << endl;
  report << "selectivities" << endl;
  report << exp(log_sel) << endl;
  report << "Recruitment " << endl;
  report << recnumbers << endl;
  report << "Estimated numbers of fish " << endl;
  report << N << endl;
  report << "Estimated numbers in catch " << endl;
  report << C << endl;
  report << "Estimated fishing mortality " << endl;
  report << F << endl; 
  //report << "estimated effective sample size" << endl;
  //report << vN << endl;
  //report << "estimated effective sample sizes" << endl;
  if (last_phase())
  {
    ofstream ofs("neweffsize",ios::app);
    ofs << vN << endl;
  }
  if (last_phase())
  {
    ofstream ofs("effsize_years",ios::app);
  }
  if (last_phase())
  {
    ofstream ofspx("vn_app.out",ios::app);
    ofspx << exp(log_vn) << endl;
    ofstream ofsp("totn_analyser_app.out",ios::app);
    ofsp << sum(N(nyears)) << endl;
    ofstream ofs("totn_analyser.out");
    for (int i=1;i<=nyears;i++)
    {
      ofs << sum(N(i)) << endl;
    }
    ofs << "  " << endl;
    ofs << "  Observed catch  " << endl;
    ofs << logotc << endl;
    ofs << "  Predicted catch  " << endl;
    ofs << logTC << endl;

  }
  if (last_phase())
  {
    ofstream ofs("obj_fn.out",ios::app);
    ofs << "# Length_composition" << endl;
    ofs << like_lencomp << endl;
    ofs << "# Total_catch" << endl;
    ofs << like_totC << endl;
    ofs << "# Relative_abundance" << endl;
    ofs << like_rel_abund << endl;
    ofs << "# Fmort_penalty" << endl;
    ofs << pen_F << endl;
    ofs << "# Relpop_penalty" << endl;
    ofs << pen_relpop << endl;
    ofs << "# Total likelihood" << endl;
    ofs << f << endl; 
    ofstream ofs1("otc");
    ofstream ofs2("ptc");
    dmatrix tmp(1,2,1,nyears);
    tmp(1).fill_seqadd(1.0,1.0);
    tmp(2)=logotc;
    ofs1 << trans(tmp) << endl;
    tmp(2)=value(logTC);
    ofs2 << trans(tmp) << endl;

    ofstream ofs3("obs_lenfrq");
    ofstream ofs4("pred_lenfrq");
    dmatrix tmp2(1,nlint+1,1,nyears);
    tmp2(1).fill_seqadd(1.0,1.0);
    dmatrix tmp2_1=value(obs_length_composition);
    for (int i=2;i<=nlint+1;++i)
    {
      tmp2(i)=trans(tmp2_1)(i-1);
    }
    ofs3 << trans(tmp2) << endl;
    tmp2_1=value(pred_catch_composition);
    for (int i=2;i<=nlint+1;++i)
    {
      tmp2(i)=trans(tmp2_1)(i-1);
    }
    ofs4 << trans(tmp2) << endl;

    ofstream ofs5("rel_abund_fit");
    dmatrix tmp3(1,3,1,nyears);
    dvector log_pred_biomass_index;
    log_pred_biomass_index=value(pred_biomass_index);
    log_pred_biomass_index=log(log_pred_biomass_index+.01);
    tmp3(1).fill_seqadd(1.0,1.0);
    tmp3(2)=log_biomass_index;
    tmp3(3)=log_pred_biomass_index;
    ofs5 << "  Year  Obs   Pred " << endl;
    ofs5 << trans(tmp3) << endl;
  }


TOP_OF_MAIN_SECTION
  feenableexcept(FE_DIVBYZERO | FE_INVALID | FE_OVERFLOW );
GLOBALS_SECTION
  #include <admodel.h>
  #include "richards.h"
  // ********************************************************
  // ********************************************************
  //#include "equilib.cpp"
  int get_option(const char s[],double& option_value,int nargs)
  {
    int on,nopt;
    int option_flag=0;
    if ( (on=option_match(ad_comm::argc,ad_comm::argv,s,nopt))>-1)
    {
      if (nopt ==nargs)
      {
        option_value=std::stod(ad_comm::argv[on+1]);
        option_flag=nargs;
      }
      else
      {
        cerr << "Wrong number of options to " << s << " -- must be 1"
          " you have " << nopt << endl;
        ad_exit(1);
      }
      return option_flag;
    }
  }
  int get_option(const char s[],int& option_value,int nargs)
  {
    int on,nopt;
    int option_flag=0;
    if ( (on=option_match(ad_comm::argc,ad_comm::argv,s,nopt))>-1)
    {
      if (nopt ==nargs)
      {
        option_value=atoi(ad_comm::argv[on+1]);
        option_flag=nargs;
      }
      else
      {
        cerr << "Wrong number of options to " << s << " -- must be 1"
          " you have " << nopt << endl;
        ad_exit(1);
      }
      return option_flag;
    }
  }
 dvariable smooth1(const prevariable& x)
 {
    const dvariable e=1.e-2;
    const dvariable einv=1.0/1.e-2;
    const dvariable a=-einv*einv;
    const dvariable b=2.0*einv;
    if (value(x)<0.5-e || value(x)>0.5+e)
    {
      return x;
    }
    else if (value(x) >= 0.5)
    {
      dvariable y=x-0.5;
      dvariable z=y*y*(a*y+b)+0.5;
      return z;
    }
    else
    {
      dvariable y=0.5-x;
      dvariable z=0.5-y*y*(a*y+b);
      return z;
    }
 }

  double smoothpow(double x,double gamma,double eps);
  dvariable smoothpow(const prevariable& x,double gamma,double eps);
  
  
  /*
  dvar_matrix get_equil_matrix(int nlint,double xmin,double xwidth,
    const dvar_vector& _ES,const dfrichards_growth_manager_array& _rgma)
  {
    ADUNCONST(dvar_vector,ES)
    ADUNCONST(dfrichards_growth_manager_array,rgma)
    int rgmmax=rgma.indexmax();
    dvar_matrix M(1,nlint,1,nlint);
    M.initialize();
    dvar_vector surv(1,nlint);
    surv=ES;
    double v=xmin-0.5*xwidth;
    for (int current_bin=1;current_bin<=nlint;current_bin++)
    {
      v+=xwidth;
      dvar_vector & cp=M(current_bin);
      for (int ll=1;ll<=rgmmax;ll++)
      {
        int low=0;
        //double p1=0;
        //double p2=0;
        //double increment=-0.001;
        //double increment=1.999;
        double increment=1.0;
        {
          // deal with first bin in plus group
          dvariable x=rgma(ll).G(v,increment);
          //double x=v+increment;
          dvariable d=fgetindex(x,xmin,xwidth); 
          {
            //double ipart;
            //double frac=modf(d,&ipart);
            int ipart=int(value(d));
            dvariable frac=smooth1(d-ipart);
            //cout << v << " " << x << " " << frac << " " << ipart << endl;
            if (frac<=0.5)   // first half of of bin
            {
              // average over ipart and one less than ipart
              //p1=1.0;
              if (ipart==1)
              {
                cp(ipart)+=rgma.get_weights(ll)*surv(ipart);
                //cp(ipart)+=prevprobs(current_bin)*rgma.get_weights(ll);
                //newbin(ipart)+=1.0;
              }
              else if (ipart<=nlint)
              {
                dvariable p2=0.5+frac;
                dvariable p1=1.0-p2;
                //cp(ipart-1)+=p1*prevprobs(current_bin)
                cp(ipart-1)+=p1*rgma.get_weights(ll)*surv(ipart-1);
                //cp(ipart)+=p2*prevprobs(current_bin)
                cp(ipart)+=p2*rgma.get_weights(ll)*surv(ipart);
              }
              else if (ipart >nlint)
              {
                cp(nlint)+=rgma.get_weights(ll)*surv(nlint);
                //cp(nlint)+=prevprobs(current_bin)*rgma.get_weights(ll);
                //cout << " Deal with this" << endl;
              }
              else
              {
                cerr << "Fucked" << endl;
              }
            }
            else if (ipart< (nlint))
            {
              dvariable p1=1.0-(frac-0.5);
              dvariable p2=1.0-p1;
              //cp(ipart)+=p1*prevprobs(current_bin)
              cp(ipart)+=p1*rgma.get_weights(ll)*surv(ipart);
              //cp(ipart+1)+=p2*prevprobs(current_bin)
              cp(ipart+1)+=p2*rgma.get_weights(ll)*surv(ipart+1);
            }
            else if (ipart >=nlint)
            {
              //cp(nlint)+=prevprobs(current_bin)*rgma.get_weights(ll);
              cp(nlint)+=rgma.get_weights(ll)*surv(nlint);
              //cout << " Deal with this" << endl;
            }
            else
            {
              cerr << "Fucked" << endl;
            }
          }
        }
      }
    }
    //cout << M << endl;
    dvar_matrix TM=trans(M);
    return TM;
  }
  */
  
  dvar_matrix get_equil_matrix(int nlint,double xmin,double xwidth,
    const dvar_vector& _ES,const dfrichards_growth_manager_array& _rgma)
  {
    ADUNCONST(dvar_vector,ES)
    ADUNCONST(dfrichards_growth_manager_array,rgma)
    int rgmmax=rgma.indexmax();
    dvar_matrix M(1,nlint,1,nlint);
    M.initialize();
    dvar_vector surv(1,nlint);
    surv=ES;
    double v=xmin-0.5*xwidth;
    for (int current_bin=1;current_bin<=nlint;current_bin++)
    {
      v+=xwidth;
      dvar_vector & cp=M(current_bin);
      for (int ll=1;ll<=rgmmax;ll++)
      {
        int low=0;
        //double p1=0;
        //double p2=0;
        //double increment=-0.001;
        //double increment=1.999;
        double increment=1.0;
        {
          // deal with first bin in plus group
          dvariable x=rgma(ll).G(v,increment);
          //double x=v+increment;
          dvariable d=fgetindex(x,xmin,xwidth); 
          {
            //double ipart;
            //double frac=modf(d,&ipart);
            int ipart=int(value(d));
            dvariable frac=smooth1(d-ipart);
            //cout << v << " " << x << " " << frac << " " << ipart << endl;
            if (frac<=0.5)   // first half of of bin
            {
              // average over ipart and one less than ipart
              //p1=1.0;
              if (ipart==1)
              {
                cp(ipart)+=rgma.get_weights(ll)*surv(current_bin);
                //cp(ipart)+=prevprobs(current_bin)*rgma.get_weights(ll);
                //newbin(ipart)+=1.0;
              }
              else if (ipart<=nlint)
              {
                dvariable p2=0.5+frac;
                dvariable p1=1.0-p2;
                //cp(ipart-1)+=p1*prevprobs(current_bin)
                cp(ipart-1)+=p1*rgma.get_weights(ll)*surv(current_bin);
                //cp(ipart)+=p2*prevprobs(current_bin)
                cp(ipart)+=p2*rgma.get_weights(ll)*surv(current_bin);
              }
              else if (ipart >nlint)
              {
                cp(nlint)+=rgma.get_weights(ll)*surv(current_bin);
                //cp(nlint)+=prevprobs(current_bin)*rgma.get_weights(ll);
                //cout << " Deal with this" << endl;
              }
              else
              {
                cerr << "Fucked" << endl;
              }
            }
            else if (ipart< (nlint))
            {
              dvariable p1=1.0-(frac-0.5);
              dvariable p2=1.0-p1;
              //cp(ipart)+=p1*prevprobs(current_bin)
              cp(ipart)+=p1*rgma.get_weights(ll)*surv(current_bin);
              //cp(ipart+1)+=p2*prevprobs(current_bin)
              cp(ipart+1)+=p2*rgma.get_weights(ll)*surv(current_bin);
            }
            else if (ipart >=nlint)
            {
              //cp(nlint)+=prevprobs(current_bin)*rgma.get_weights(ll);
              cp(nlint)+=rgma.get_weights(ll)*surv(current_bin);
              //cout << " Deal with this" << endl;
            }
            else
            {
              cerr << "Fucked" << endl;
            }
          }
        }
      }
    }
    //cout << M << endl;
    dvar_matrix TM=trans(M);
    return TM;
  }
  
  dvar_vector get_recruitment(int i,dvector& fmid,const prevariable& rec_mu,
    const prevariable& rec_sd,const prevariable& totpop,const dvar_vector& recdevs,
    const prevariable& log_mean_rec)
  {
    const double spi=1.0/sqrt(2.0*3.14159);
    dvar_vector R=spi/rec_sd*exp(-0.5*square((fmid-rec_mu)/rec_sd));
    R/=sum(R);
    R*=totpop*exp(log_mean_rec)*exp(recdevs(i));
    return R;
  }
  
  dvector get_equilbrium_survival(int nlint)
  {
    dvector S(1,nlint);
    dvector Z(1,nlint);
    Z.fill_seqadd(0.1,.01);
    S=exp(-Z);
    return S;
  }
  
  dmatrix get_equil_matrix(int nlint,double xmin,double xwidth,
    dvector& ES,richards_growth_manager_array& rgma)
  {
    int rgmmax=rgma.indexmax();
    dmatrix M(1,nlint,1,nlint);
    M.initialize();
    dvector surv(1,nlint);
    surv=ES;
    double v=xmin-0.5*xwidth;
    for (int current_bin=1;current_bin<=nlint;current_bin++)
    {
      v+=xwidth;
      dvector & cp=M(current_bin);
      for (int ll=1;ll<=rgmmax;ll++)
      {
        int low=0;
        double p1=0;
        double p2=0;
        //double increment=-0.001;
        //double increment=1.999;
        double increment=1.0;
        {
          // deal with first bin in plus group
          double x=rgma(ll).G(v,increment);
          //double x=v+increment;
          double d=fgetindex(x,xmin,xwidth); 
          {
            double ipart;
            double frac=modf(d,&ipart);
            //cout << v << " " << x << " " << frac << " " << ipart << endl;
            if (frac<=0.5)   // first half of of bin
            {
              // average over ipart and one less than ipart
              p1=1.0;
              if (ipart==1)
              {
                cp(ipart)+=rgma.get_weights(ll)*surv(ipart);
                //cp(ipart)+=prevprobs(current_bin)*rgma.get_weights(ll);
                //newbin(ipart)+=1.0;
              }
              else if (ipart<nlint)
              {
                double p2=0.5+frac;
                double p1=1.0-p2;
                //cp(ipart-1)+=p1*prevprobs(current_bin)
                cp(ipart-1)+=p1*rgma.get_weights(ll)*surv(ipart-1);
                //cp(ipart)+=p2*prevprobs(current_bin)
                cp(ipart)+=p2*rgma.get_weights(ll)*surv(ipart);
              }
              else if (ipart >=nlint)
              {
                cp(nlint)+=rgma.get_weights(ll)*surv(nlint);
                //cp(nlint)+=prevprobs(current_bin)*rgma.get_weights(ll);
                //cout << " Deal with this" << endl;
              }
              else
              {
                cerr << "Fucked" << endl;
              }
            }
            else if (ipart< (nlint))
            {
              double p1=1.0-(frac-0.5);
              double p2=1.0-p1;
              //cp(ipart)+=p1*prevprobs(current_bin)
              cp(ipart)+=p1*rgma.get_weights(ll)*surv(ipart);
              //cp(ipart+1)+=p2*prevprobs(current_bin)
              cp(ipart+1)+=p2*rgma.get_weights(ll)*surv(ipart+1);
            }
            else if (ipart >=nlint)
            {
              //cp(nlint)+=prevprobs(current_bin)*rgma.get_weights(ll);
              cp(nlint)+=rgma.get_weights(ll)*surv(nlint);
              //cout << " Deal with this" << endl;
            }
            else
            {
              cerr << "Fucked" << endl;
            }
          }
        }
      }
    }
    //cout << M << endl;
    dmatrix TM=trans(M);
    return TM;
  }
  
  dvar_vector get_initial_equil_population(int nlint,double xmin,dvector& fmid,
    const prevariable & rec_mu,const prevariable& rec_sd,
    double xwidth,const dvar_vector & ES,
    const dfrichards_growth_manager_array& rgma,const prevariable& totpop,
    dvar_vector& recdevs,dvector& recnumbers,
    const prevariable& log_mean_rec,dmatrix& RR)
  {
    dvar_matrix TM=get_equil_matrix(nlint,xmin,xwidth,ES,rgma);
  
    dvar_vector R=get_recruitment(1,fmid,rec_mu,rec_sd,totpop,recdevs,
      log_mean_rec);
    RR(1)=value(R);
    recnumbers(1)=sum(value(R));
  
    dmatrix Id(1,nlint,1,nlint);
    Id.initialize();
    for (int i=1;i<=nlint;i++)
    {
      Id(i,i)=1.0;
    }
    
    dvar_vector N= solve(Id-TM,R);
    //cout << norm2(N-(TM*N+R)) << endl;
    return N;
  }
  
  double smoothpow(double x,double gamma,double eps)
  {
    if (x>=eps)
    {
      return pow(x,gamma);
    }
    else  if (x<=-eps)
    {
      return -pow(-x,gamma);
    }
    else if (x>=0)
    {
      double a=pow(eps,gamma-2.0)*(gamma-1.0);
      double b=pow(eps,gamma-1.0)*(2.0-gamma);
      return (a*x+b)*x;
    }
    else if (x<=0)
    {
      double a=pow(eps,gamma-2.0)*(gamma-1.0);
      double b=pow(eps,gamma-1.0)*(2.0-gamma);
      double mx=-x;
      return -(a*mx+b)*mx;
    }
  }
  
  dvariable smoothpow(const prevariable& x ,double gamma,double eps)
  {
    if (x>=eps)
    {
      return pow(x,gamma);
    }
    else  if (x<=-eps)
    {
      return -pow(-x,gamma);
    }
    else if (x>=0)
    {
      double a=pow(eps,gamma-2.0)*(gamma-1.0);
      double b=pow(eps,gamma-1.0)*(2.0-gamma);
      return (a*x+b)*x;
    }
    else if (x<=0)
    {
      double a=pow(eps,gamma-2.0)*(gamma-1.0);
      double b=pow(eps,gamma-1.0)*(2.0-gamma);
      dvariable mx=-x;
      return -(a*mx+b)*mx;
    }
  }
  dvariable smoothpow(const prevariable& x ,const prevariable&  gamma,double eps)
  {
    if (x>=eps)
    {
      return pow(x,gamma);
    }
    else  if (x<=-eps)
    {
      return -pow(-x,gamma);
    }
    else if (x>=0)
    {
      dvariable a=pow(eps,gamma-2.0)*(gamma-1.0);
      dvariable b=pow(eps,gamma-1.0)*(2.0-gamma);
      return (a*x+b)*x;
    }
    else if (x<=0)
    {
      dvariable a=pow(eps,gamma-2.0)*(gamma-1.0);
      dvariable b=pow(eps,gamma-1.0)*(2.0-gamma);
      dvariable mx=-x;
      return -(a*mx+b)*mx;
    }
  }
  
    
  
  richards_growth_manager::richards_growth_manager(double _l1,double _ln,
    double _n,double _gamma,double _N,double _K,double _epsilon) 
  {
    allocate(_l1,_ln,_n,_gamma,_N,_K,_epsilon); 
  }
  
  void richards_growth_manager::allocate(double _l1,double _ln,
    double _n,double _gamma,double _N,double _K,double _epsilon) 
  { 
    l1=_l1;ln=_ln;n=_n;gamma=_gamma;N=_N;K=_K;epsilon=_epsilon;
    rho=exp(-K);
    gamminv=1.0/gamma;
    l1gamm=pow(l1,gamminv);	
    lngamm=pow(ln,gamminv);	
    l1ngamm=pow(ln,gamminv)-l1gamm;
    if (l1ngamm<0.0)
    {
      cerr << "Fucked" << endl;
      ad_exit(1);
    }
  }
  
  void dfrichards_growth_manager::allocate(prevariable& _l1,const prevariable&  _ln,
    double _n, double _gamma,double _N,const prevariable& _K,double _epsilon)
  { 
    l1=_l1;ln=_ln;n=_n;gamma=_gamma;N=_N;K=_K;epsilon=_epsilon;
    rho=exp(-K);
    gamminv=1.0/gamma;
    l1gamm=pow(l1,gamminv);	
    lngamm=pow(ln,gamminv);	
    l1ngamm=pow(ln,gamminv)-l1gamm;
    if (l1ngamm<0.0)
    {
      cerr << "Fucked" << endl;
      ad_exit(1);
    }
  }

  void dfrichards_growth_manager::allocate(prevariable& _l1,const prevariable&  _ln,
    double _n, const prevariable& _gamma,double _N,const prevariable& _K,
    double _epsilon)
  { 
    l1=_l1;ln=_ln;n=_n;gamma=_gamma;N=_N;K=_K;epsilon=_epsilon;
    rho=exp(-K);
    gamminv=1.0/gamma;
    l1gamm=pow(l1,gamminv);	
    lngamm=pow(ln,gamminv);	
    l1ngamm=pow(ln,gamminv)-l1gamm;
    if (l1ngamm<0.0)
    {
      cerr << "Fucked" << endl;
      ad_exit(1);
    }
  }
  
  double richards_growth_manager::richardsu(double t)
  {
    double l,lt;
    if (l1ngamm<0.0)
    {
      cerr << "Fucked" << endl;
      ad_exit(1);
    }
    if (t<=N)
    {
      lt=(1.0-pow(rho,t-1.0))/(1.0-pow(rho,n-1));
      l=smoothpow(l1gamm+l1ngamm * lt,gamma,0.1);
    }
    else
    {
      lt=(1.0-pow(rho,N-1.0)-pow(rho,N-1.0)*log(rho)*(t-N))/(1.0-pow(rho,n-1));
      l=smoothpow(l1gamm+l1ngamm * lt,gamma,0.1);
    }
    return l;
  }  
  double richards_growth_manager::richardsu_inv(double lt)
  {
    if (l1ngamm<0.0)
    {
      cerr << "Fucked" << endl;
      ad_exit(1);
    }
    double ltgamm=pow(lt,gamminv);	
    double tmpn=(1.0-pow(rho,N-1.0))/(1.0-pow(rho,n-1));
    double lNgamm=l1gamm+l1ngamm * tmpn;
    double t;
    if (ltgamm<=lNgamm)
    {
      t=1.0+log(1.0+(l1gamm-ltgamm)/l1ngamm*(1.0-pow(rho,n-1)))/log(rho);
    }
    else
    {
      t=N+(1.0-pow(rho,N-1.0)-(ltgamm-l1gamm)/(lngamm-l1gamm)*(1-pow(rho,n-1)))/
        (pow(rho,N-1.0)*log(rho));
    }
    return t;
  }  

  dvar_vector grow_the_fish(int k,int nlint,dvar_vector& tmpfish,dvector& xmid,
    double xmin,double xwidth,dfrichards_growth_manager_array& rgma)
  {
    dvariable tmptot=sum(tmpfish);
    int rgmmax=rgma.indexmax();
    //dvar_vector prevprobs=tmpfish/tmptot;
    dvar_vector prevprobs=tmpfish;
    dvar_vector curprobs(1,nlint);
    curprobs.initialize();
    dvector lastbin(1,nlint-1);
    lastbin.initialize();
    for (int ll=1;ll<=rgmmax;ll++)
    {
      //int current_bin=nlint;
      double ssum=0;
      for (int current_bin=1;current_bin<=nlint;current_bin++)
      {
        int low=0;
        //double p1=0;
        //double p2=0;
        //double increment=-0.001;
        //double increment=1.999;
        double increment=1.0;
        {
          // deal with first bin in plus group
          double v=xmid(current_bin);
          dvariable x=rgma(ll).G(v,increment);
          //double x=v+increment;
          dvariable d=fgetindex(x,xmin,xwidth); 
          {
            //double ipart;
            //double frac=modf(d,&ipart);
            int ipart=int(value(d));
            dvariable frac=smooth1(d-ipart);
            if (frac<=0.5)   // first half of of bin
            {
              // average over ipart and one less than ipart
              //p1=1.0;
              if (ipart==1)
              {
                curprobs(ipart)+=prevprobs(current_bin)*rgma.get_weights(ll);
                //newbin(ipart)+=1.0;
              }
              else if (ipart<=nlint)
              {
                dvariable p2=0.5+frac;
                dvariable p1=1.0-p2;
                curprobs(ipart-1)+=p1*prevprobs(current_bin)
                  *rgma.get_weights(ll);
                curprobs(ipart)+=p2*prevprobs(current_bin)
                  *rgma.get_weights(ll);
              }
              else if (ipart >nlint)
              {
                curprobs(nlint)+=prevprobs(current_bin)*rgma.get_weights(ll);
                //cout << " Deal with this" << endl;
              }
              else
              {
                cerr << "Fucked" << endl;
              }
            }
            else if (ipart< (nlint))
            {
              dvariable p1=1.0-(frac-0.5);
              dvariable p2=1.0-p1;
              curprobs(ipart)+=p1*prevprobs(current_bin)
                *rgma.get_weights(ll);
              curprobs(ipart+1)+=p2*prevprobs(current_bin)
                *rgma.get_weights(ll);
            }
            else if (ipart >=nlint)
            {
              curprobs(nlint)+=prevprobs(current_bin)*rgma.get_weights(ll);
              //cout << " Deal with this" << endl;
            }
            else
            {
              cerr << "Fucked" << endl;
            }
          }
        }
      }
    }
    //cout << "VV " << sum(prevprobs(1,nlint-1)) << " " 
    //     << sum(curprobs(1,nlint-1)) << endl;
    //cout << "XUU " << sum(prevprobs(1,nlint-1)) << " " 
    //     << sum(curprobs(1,nlint-1))+curprobs(nlint)/xwidth << endl;
    dvariable num=sum(prevprobs(1,nlint-1)); 
    dvariable den=sum(curprobs(1,nlint-1))+curprobs(nlint)/xwidth;
    curprobs*=(num/den);
    //cout << "YUU " << sum(prevprobs(1,nlint-1)) << " " 
    //     << sum(curprobs(1,nlint-1))+curprobs(nlint)/xwidth << endl;
    //return tmptot*curprobs;
    return curprobs;
  }
  
  void myerror(double x,double xmin,double p1,double p2,const char s[])
  {
    if (x>=xmin && (p1<0.0 || p2<0.0)) 
    {
      cout << s << endl;
    }
  }
  
  double fgetindex(double x,double xmin,double xwidth)
  {
    return  (x-xmin)/xwidth+1.0;
  }
  
  dvariable fgetindex(const prevariable& x,double xmin,double xwidth)
  {
    return  (x-xmin)/xwidth+1.0;
  }
  
  int getindex(double x,double xmin,double xwidth)
  {
    return  floor((x-xmin)/xwidth)+1.0;
  }

  void catch_the_fish(int k,dvar_matrix& N,dvar_matrix& C,dvar_matrix& F,
   dvar_matrix & Z, dvar_matrix & S, dvar_matrix & pred_catch_composition,
   dvar_vector & logTC)
  {
    C(k)=elem_prod(elem_prod(elem_div(F(k),Z(k)),1-exp(-Z(k))),N(k));
    logTC(k)=log(sum(C(k)));
    pred_catch_composition(k)=C(k)/sum(C(k));
  }

  dvar_vector  kill_the_fish(int k,dvar_matrix& N,dvar_matrix & S,double xwidth)
  {
    dvar_vector tmp=elem_prod(N(k),S(k));
    return tmp;
  }
  
  double normdist(double x,double mu,double sd,double Nsize)
  {
    const double sqrt_tpinv=0.39894228040143267794;
    double siginv=1.0/sd;
    double tmp=(x-mu)*siginv;
    if (fabs(tmp)>3.1)
    {
      return 0.0;
    }
    else
    {
      return exp(-0.5*tmp*tmp)*siginv*Nsize*sqrt_tpinv;
    }
  }
  dvariable dfrichards_growth_manager::richardsu_inv(const prevariable& lt)
  {
    if (l1ngamm<0.0)
    {
      cerr << "Fucked" << endl;
      ad_exit(1);
    }
    dvariable ltgamm=pow(lt,gamminv);	
    dvariable tmpn=(1.0-pow(rho,N-1.0))/(1.0-pow(rho,n-1));
    dvariable lNgamm=l1gamm+l1ngamm * tmpn;
    dvariable t;
    if (ltgamm<=lNgamm)
    {
      t=1.0+log(1.0+(l1gamm-ltgamm)/l1ngamm*(1.0-pow(rho,n-1)))/log(rho);
    }
    else
    {
      t=N+(1.0-pow(rho,N-1.0)-(ltgamm-l1gamm)/(lngamm-l1gamm)*(1-pow(rho,n-1)))/
        (pow(rho,N-1.0)*log(rho));
    }
    return t;
  }  
  dvariable dfrichards_growth_manager::richardsu_inv(double lt)
  {
    if (l1ngamm<0.0)
    {
      cerr << "Fucked" << endl;
      ad_exit(1);
    }
    dvariable ltgamm=pow(lt,gamminv);	
    dvariable tmpn=(1.0-pow(rho,N-1.0))/(1.0-pow(rho,n-1));
    dvariable lNgamm=l1gamm+l1ngamm * tmpn;
    dvariable t;
    if (ltgamm<=lNgamm)
    {
      t=1.0+log(1.0+(l1gamm-ltgamm)/l1ngamm*(1.0-pow(rho,n-1)))/log(rho);
    }
    else
    {
      t=N+(1.0-pow(rho,N-1.0)-(ltgamm-l1gamm)/(lngamm-l1gamm)*(1-pow(rho,n-1)))/
        (pow(rho,N-1.0)*log(rho));
    }
    return t;
  }  
  dvariable dfrichards_growth_manager::richardsu(const prevariable&  t)
  {
    dvariable l,lt;
    if (l1ngamm<0.0)
    {
      cerr << "Fucked" << endl;
      ad_exit(1);
    }
    if (t<=N)
    {
      lt=(1.0-pow(rho,t-1.0))/(1.0-pow(rho,n-1));
      l=smoothpow(l1gamm+l1ngamm * lt,gamma,0.1);
    }
    else
    {
      lt=(1.0-pow(rho,N-1.0)-pow(rho,N-1.0)*log(rho)*(t-N))/(1.0-pow(rho,n-1));
      l=smoothpow(l1gamm+l1ngamm * lt,gamma,0.1);
    }
    return l;
  }  
    // ********************************************************
    // ********************************************************
  
  #include <fenv.h>
  #include <admodel.h>

  void mp(double& v)
  {
    cout << v << endl;
  }
  void mp(prevariable& v)
  {
    cout << v << endl;
  }
  void mp(ivector& v)
  {
    cout << v << endl;
  }
  void mp(ivector& v,int i)
  {
    cout << v(i) << endl;
  }
  void mp(dvar_vector& v)
  {
    cout << v << endl;
  }
  void mp(dvar_vector& v,int i)
  {
    cout << v(i) << endl;
  }
  void mp(dvector& v)
  {
    cout << v << endl;
  }
  void mp(dvector& v,int i)
  {
    cout << v(i) << endl;
  }
  void mp(dmatrix& v)
  {
    cout << v << endl;
  }
  void mp(dmatrix& v,int i)
  {
    cout << v(i) << endl;
  }
  void mp(dvar_matrix& v)
  {
    cout << v << endl;
  }
  void mp(dvar_matrix& v,int i)
  {
    cout << v(i) << endl;
  }
  void mp(d3_array& v)
  {
    cout << v << endl;
  }
  void mp(d3_array& v,int i)
  {
    cout << v(i) << endl;
  }
  void mp(d3_array& v,int i,int j)
  {
    cout << v(i,j) << endl;
  }
  void mp(d4_array& v)
  {
    cout << v << endl;
  }
  void mp(d4_array& v,int i)
  {
    cout << v(i) << endl;
  }
  void mp(d4_array& v,int i,int j)
  {
    cout << v(i,j) << endl;
  }
  void mp(d4_array& v,int i,int j,int k)
  {
    cout << v(i,j,k) << endl;
  }
  void mp(d5_array& v)
  {
    cout << v << endl;
  }
  void mp(d5_array& v,int i)
  {
    cout << v(i) << endl;
  }
  void mp(d5_array& v,int i,int j)
  {
    cout << v(i,j) << endl;
  }
  void mp(d5_array& v,int i,int j,int k)
  {
    cout << v(i,j,k) << endl;
  }
  void mp(d5_array& v,int i,int j,int k,int l)
  {
    cout << v(i,j,k,l) << endl;
  }
  void mpeig(const dmatrix& M)
  {
    cout << eigenvalues(M) << endl;
  }
  void mpeig(const dvar_matrix& M)
  {
    cout << eigenvalues(M) << endl;
  }
  void mpld(const dvar_matrix& M)
  {
    cout << ln_det(M) << endl;
  }
  void mpld(const dmatrix& M)
  {
    cout << ln_det(M) << endl;
  }
  void mpsum(const dvector& M)
  {
    cout << sum(M) << endl;
  }
  void mpsum(const dmatrix& M)
  {
    cout << sum(M) << endl;
  }
  void mpsum(const dvar_vector& M)
  {
    cout << sum(M) << endl;
  }
  void mpsum(const dvar_matrix& M)
  {
    cout << sum(M) << endl;
  }
